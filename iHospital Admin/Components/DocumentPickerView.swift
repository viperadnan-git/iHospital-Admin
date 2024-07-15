//
//  DocumentPickerView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import Foundation
import SwiftUI

struct DocumentPickerView: UIViewControllerRepresentable {
    var completionHandler: (Result<URL, Error>) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        documentPicker.delegate = context.coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerView

        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.completionHandler(.failure(NSError(domain: "DocumentPickerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No document was selected."])))
                return
            }
            parent.completionHandler(.success(url))
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.completionHandler(.failure(NSError(domain: "DocumentPickerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document picker was cancelled."])))
        }
    }
}
