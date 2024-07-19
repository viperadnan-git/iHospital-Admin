//
//  ProfileImage.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 18/07/24.
//

import SwiftUI

struct ProfileImage: View {
    let userId: String
    var placeholder: Image = Image(systemName: "person.crop.circle.fill")
    
    @State private var image: Image? = nil
    @State private var isLoading: Bool = true
    @State private var error: Error? = nil
    
    var body: some View {
        Group {
            if isLoading {
                placeholder
                    .onAppear {
                        loadImage()
                    }
            } else if let image = image {
                image
            } else if let error = error {
                placeholder // Or show an error placeholder
                    .overlay(
                        VStack {
                            Text("Error loading image")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    )
            }
        }
        .clipShape(Circle())
        .onAppear {
            if image == nil {
                loadImage()
            }
        }
    }
    
    private func loadImage() {
        Task {
            do {
                let data = try await fetchImageData(for: userId)
                if let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                } else {
                    error = NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to decode image data"])
                }
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
    
    private func fetchImageData(for userId: String) async throws -> Data {
        let path = "\(userId.lowercased())/avatar.jpeg"
        return try await supabase.storage.from(SupabaseBucket.avatars.id)
            .download(path: path)
    }
}
