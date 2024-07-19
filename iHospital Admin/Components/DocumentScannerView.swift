//
//  DocumentScannerView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 15/07/24.
//

import SwiftUI
import VisionKit
import PDFKit

struct DocumentScannerView: UIViewControllerRepresentable {
    var completionHandler: (Result<URL, Error>) -> Void
    var filename: String = UUID().uuidString // Optional filename for the PDF

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: DocumentScannerView

        init(_ parent: DocumentScannerView) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            guard scan.pageCount > 0 else {
                parent.completionHandler(.failure(NSError(domain: "DocumentScannerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No document was scanned."])))
                controller.dismiss(animated: true)
                return
            }
            
            // Save the scanned document as a PDF
            let tempDir = FileManager.default.temporaryDirectory
            let tempURL = tempDir.appendingPathComponent(parent.filename).appendingPathExtension("pdf")
            
            let pdfDocument = PDFDocument()
            
            for i in 0..<scan.pageCount {
                let pageImage = scan.imageOfPage(at: i)
                if let pdfPage = PDFPage(image: pageImage) {
                    pdfDocument.insert(pdfPage, at: i)
                }
            }
            
            do {
                try pdfDocument.dataRepresentation()?.write(to: tempURL)
                parent.completionHandler(.success(tempURL))
            } catch {
                parent.completionHandler(.failure(NSError(domain: "DocumentScannerError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to save PDF."])))
            }
            
            controller.dismiss(animated: true)
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.completionHandler(.failure(NSError(domain: "DocumentScannerError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Scanner was cancelled."])))
            controller.dismiss(animated: true)
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.completionHandler(.failure(error))
            controller.dismiss(animated: true)
        }
    }
}
