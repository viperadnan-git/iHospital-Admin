//
//  DocumentPickerView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import Foundation
import SwiftUI

struct DocumentPickerView: UIViewControllerRepresentable {
    @Binding var documentData: Data?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerView
        
        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            do {
                parent.documentData = try Data(contentsOf: url)
            } catch {
                print("Error reading document data: \(error)")
            }
        }
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .image])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}
