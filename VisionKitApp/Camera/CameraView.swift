//
//  CameraView.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import SwiftUI
import PhotosUI

struct CameraView: UIViewControllerRepresentable {

    let dataModel: DocumentDataModel
    @Binding var isScanning: Bool

    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }


    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                self.parent.dataModel.detectedFromImage(image: uiImage)
            }

            self.parent.isScanning = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.isScanning = false
        }
    }
}
