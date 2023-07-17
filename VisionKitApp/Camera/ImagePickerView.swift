//
//  ImagePickerView.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    let dataModel: DocumentDataModel
    var itemProviders: [NSItemProvider] = []
    
    @Binding var errorMessage: String

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {

        var parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

            picker.dismiss(animated: true)
            
            if !results.isEmpty {
                parent.itemProviders = []
            }
            
            parent.itemProviders = results.map(\.itemProvider)
            
            for itemProvider in parent.itemProviders {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { selectImage, error in
                        if error != nil {
                            self.parent.errorMessage = "Image acquisition failure"
                            return
                        }
                        DispatchQueue.main.async {
                            guard let image = selectImage as? UIImage else { return }
                            self.parent.dataModel.detectedFromImage(image: image)
                        }
                    }
                }
            }
        }
    }
}
