//
//  DrawingCanvasView.swift
//  iHospital Admin
//
//  Created by Adnan Ahmad on 11/07/24.
//

import SwiftUI
import PencilKit

struct DrawingCanvasView: UIViewRepresentable {
    @Binding var canvasChanged: Bool
    @Binding var canvasImage: UIImage?

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: DrawingCanvasView

        init(parent: DrawingCanvasView) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.canvasChanged = true
            parent.canvasImage = canvasView.drawing.image(from: canvasView.drawing.bounds, scale: 1)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 2)
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Our canvasImage binding is updated via the delegate method, no additional updates are needed here.
    }
}
