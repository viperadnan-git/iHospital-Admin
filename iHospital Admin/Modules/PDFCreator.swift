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
    private let metaData = [
        kCGPDFContextAuthor: "iHospital",
        kCGPDFContextSubject: "Patient Records",
    ]
    
    private var rect: CGRect {
        return CGRect(x: 0, y: 0, width: Constants.PDF.pageWidth * Constants.PDF.dotsPerInch, height: Constants.PDF.pageHeight * Constants.PDF.dotsPerInch)
    }
    
    @MainActor
    func createPDFData<V: View>(fileName: String, pages: [V], displayScale: CGFloat) -> URL {
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = metaData as [String : Any]
        let renderer = UIGraphicsPDFRenderer(bounds: rect, format: format)
        
        let tempFolder = FileManager.default.temporaryDirectory
        let fileName = fileName + ".pdf"
        let tempURL = tempFolder.appendingPathComponent(fileName)
        
        try? renderer.writePDF(to: tempURL) { context in
            for Page in pages {
                context.beginPage()
                let imageRenderer = ImageRenderer(content: Page)
                imageRenderer.scale = displayScale
                imageRenderer.uiImage?.draw(at: CGPoint.zero)
            }
        }

        return tempURL
    }
}
