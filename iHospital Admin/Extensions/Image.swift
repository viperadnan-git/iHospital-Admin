//
//  Image.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    // Retrieves an image from the cache
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    // Stores an image in the cache
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

extension Image {
    // Loads an image asynchronously with caching and optional progress indicator
    static func asyncImage(loadData: @escaping () async throws -> Data, placeholder: Image = Image(systemName: "photo.fill"), cacheKey: String, showProgress: Bool = true) -> some View {
        AsyncImage(loadData: loadData, placeholder: placeholder, cacheKey: cacheKey, showProgress: showProgress)
    }
    
    // Returns a validation icon based on the presence of an error
    static func validationIcon(for error: String?) -> some View {
        Group {
            if let error = error {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                    .popover(isPresented: .constant(true)) {
                        Text(error).padding()
                    }
            }
        }
    }
}

struct AsyncImage: View {
    let loadData: () async throws -> Data
    let placeholder: Image
    let cacheKey: String
    let showProgress: Bool
    
    @State private var image: Image? = nil
    @State private var errorOccurred = false
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            } else if errorOccurred || !showProgress {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color(.systemGray))
                    .task {
                        await loadImage()
                    }
            } else {
                ProgressView()
                    .task {
                        await loadImage()
                    }
            }
        }
    }
    
    // Loads the image asynchronously, using the cache if available
    private func loadImage() async {
        if let cachedUIImage = ImageCache.shared.getImage(forKey: cacheKey) {
            image = Image(uiImage: cachedUIImage)
            return
        }
        
        do {
            let data = try await loadData()
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.setImage(uiImage, forKey: cacheKey)
                image = Image(uiImage: uiImage)
            } else {
                errorOccurred = true
            }
        } catch {
            errorOccurred = true
        }
    }
}
