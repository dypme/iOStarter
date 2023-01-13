//
//  CameraView.swift
//  iOStarter
//
//  Created by MBP2022_1 on 06/01/23.
//  Copyright © 2023 dypme. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CameraController
    
    private let cameraController: CameraController
    private let didCapture: ((_ image: UIImage) -> ())?
    
    init(position: AVCaptureDevice.Position, isSquare: Bool, enableSwitchCamera: Bool = true, enableFlashlight: Bool = true, didCapture: ((_ image: UIImage) -> ())? = nil) {
        cameraController = CameraController(position: position, isSquare: isSquare, enableSwitchCamera: enableSwitchCamera, enableFlashlight: enableFlashlight)
        self.didCapture = didCapture
    }
    
    func makeUIViewController(context: Context) -> CameraController {
        cameraController.delegate = context.coordinator
        return cameraController
    }
    
    func updateUIViewController(_ uiViewController: CameraController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: CameraControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func didCapture(_ picker: CameraController, image: UIImage) {
            parent.didCapture?(image)
        }
    }
}
