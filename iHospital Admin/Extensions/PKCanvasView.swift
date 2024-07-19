//
//  PKCanvasView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 18/07/24.
//

import PencilKit

extension PKCanvasView {
    // Generates an image from the specified rect with the given scale and background color
    func drawingImage(from rect: CGRect, scale: CGFloat, backgroundColor: UIColor) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(bounds: rect, format: format)
        
        // Render the image with the specified background color and content of the PKCanvasView
        return renderer.image { context in
            backgroundColor.setFill()
            context.fill(rect)
            self.drawHierarchy(in: rect, afterScreenUpdates: true)
        }
    }
}
