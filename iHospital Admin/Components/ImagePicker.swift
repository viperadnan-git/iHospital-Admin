//
//  ImagePicker.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 18/07/24.
//

import SwiftUI
import PhotosUI
import UIKit

/// A SwiftUI wrapper for `UIImagePickerController` to select or capture images.
struct ImagePicker: UIViewControllerRepresentable {
    /// The coordinator to manage the interaction between SwiftUI and `UIImagePickerController`.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        /// Called when an image is picked.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImageData = uiImage.jpegData(compressionQuality: 0.5)
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        /// Called when the picker is cancelled.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImageData: Data?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    /// Creates the `UIImagePickerController` instance.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = false // Set to true if you want to allow image editing
        return picker
    }

    /// Updates the `UIImagePickerController` instance.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
