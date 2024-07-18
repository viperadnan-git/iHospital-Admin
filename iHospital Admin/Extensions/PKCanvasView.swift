//
//  PKCanvasView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 18/07/24.
//

import PencilKit

extension PKCanvasView {
    func drawingImage(from rect: CGRect, scale: CGFloat, backgroundColor: UIColor) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(bounds: rect, format: format)
        return renderer.image { context in
            backgroundColor.setFill()
            context.fill(rect)
            self.drawHierarchy(in: rect, afterScreenUpdates: true)
        }
    }
}
