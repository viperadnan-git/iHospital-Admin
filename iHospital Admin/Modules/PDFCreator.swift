//
//  PDFCreator.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import Foundation
import SwiftUI
import PDFKit

class PDFCreator {
    static let shared = PDFCreator()
    
    private let metaData = [
        kCGPDFContextAuthor: "iHospital",
        kCGPDFContextSubject: "Patient Records",
    ]
    
    private var rect: CGRect {
        return CGRect(x: 0, y: 0, width: 8.5 * 72, height: 11 * 72) // Standard US Letter size
    }
    
    // Creates a PDF file from an array of SwiftUI views
    @MainActor
    func createPDFData<V: View>(fileName: String, pages: [V], displayScale: CGFloat) -> URL {
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = metaData as [String: Any]
        let renderer = UIGraphicsPDFRenderer(bounds: rect, format: format)
        
        let tempFolder = FileManager.default.temporaryDirectory
        let tempURL = tempFolder.appendingPathComponent(fileName).appendingPathExtension("pdf")
        
        do {
            try renderer.writePDF(to: tempURL) { context in
                for page in pages {
                    context.beginPage()
                    let imageRenderer = ImageRenderer(content: page)
                    imageRenderer.scale = displayScale
                    if let uiImage = imageRenderer.uiImage {
                        uiImage.draw(in: rect)
                    }
                }
            }
        } catch {
            print("Could not create PDF file: \(error.localizedDescription)")
        }

        return tempURL
    }
}
