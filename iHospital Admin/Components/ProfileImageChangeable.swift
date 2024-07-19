//
//  ProfileImageChangeable.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 18/07/24.
//

import SwiftUI
import PhotosUI

struct ProfileImageChangeable: View {
    let userId: String
    var placeholder: Image = Image(systemName: "person.crop.circle.fill")
    
    @State private var image: Image?
    @State private var imageData: Data?
    @State private var isChangingImage: Bool = false
    @State private var showActionSheet: Bool = false
    @State private var isShowingPhotoPicker: Bool = false
    @State private var isShowingCamera: Bool = false
    @State private var error: String?

    var body: some View {
        VStack {
            Group {
                if isChangingImage {
                    ProgressView()
                } else if let imageData = imageData {
                    if image == nil {
                        ProgressView()
                            .onAppear {
                                loadImage(from: imageData)
                            }
                    } else {
                        image?.resizable()
                    }
                } else {
                    Image.asyncImage(
                        loadData: {
                            try await fetchImageData(for: userId)
                        },
                        placeholder: placeholder,
                        cacheKey: "AV#\(userId)",
                        showProgress: false
                    )
                }
            }
            .scaledToFill()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            
            Button {
                showActionSheet = true
            } label: {
                HStack {
                    Image(systemName: "photo.fill")
                    Text("Change Image")
                }
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Select Image Source"),
                    buttons: [
                        .default(Text("Photo Library")) {
                            isShowingPhotoPicker = true
                        },
                        .default(Text("Camera")) {
                            isShowingCamera = true
                        },
                        .cancel()
                    ]
                )
            }
            .alert(isPresented: Binding<Bool>.constant(error != nil)) {
                Alert(title: Text("Error"), message: Text(error ?? "An unknown error occurred."), dismissButton: .default(Text("OK")))
            }
        }
        .sheet(isPresented: $isShowingPhotoPicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImageData: $imageData)
        }
        .sheet(isPresented: $isShowingCamera) {
            ImagePicker(sourceType: .camera, selectedImageData: $imageData)
        }
        .onChange(of: imageData) { newImageData in
            Task {
                guard let data = newImageData else { return }
                
                do {
                    isChangingImage = true
                    defer { isChangingImage = false }
                    
                    try await uploadImage(image: data)
                    ImageCache.shared.setImage(UIImage(data: data)!, forKey: "AV#\(userId)")
                    print("Image uploaded successfully")
                } catch {
                    self.error = error.localizedDescription
                    print("Error while saving data \(error)")
                }
            }
        }
    }
    
    private func fetchImageData(for userId: String) async throws -> Data {
        let path = "\(userId.lowercased())/avatar.jpeg"
        return try await supabase.storage.from(SupabaseBucket.avatars.id)
            .download(path: path)
    }
    
    private func loadImage(from data: Data) {
        if let uiImage = UIImage(data: data) {
            image = Image(uiImage: uiImage)
        } else {
            image = placeholder
        }
    }
    
    private func uploadImage(image: Data) async throws {
        let path = "\(userId.lowercased())/avatar.jpeg"
        try await supabase.storage.from(SupabaseBucket.avatars.id).upload(path: path, file: image, options: .init(upsert: true))
    }
}
