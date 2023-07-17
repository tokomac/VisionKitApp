//
//  DataScannerModel.swift
//  VisionKitApp
//
//  Created by tokokmac.
//

import SwiftUI
import VisionKit

struct DataScanner: UIViewControllerRepresentable {
    
    @Binding var isScanning: Bool
    @Binding var captureImage: UIImage?
    @Binding var errorMessage: String
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        
        let recognizedDataTypes:Set<DataScannerViewController.RecognizedDataType> = [
            .text(),
            .text(languages: ["ja"])
        ]
        let dataScanner = DataScannerViewController(
            recognizedDataTypes: recognizedDataTypes,
            qualityLevel: .accurate,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: false,
            isPinchToZoomEnabled: true,
            isHighlightingEnabled: true)
        dataScanner.delegate = context.coordinator
        
        return dataScanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if isScanning {
            do {
                try uiViewController.startScanning()
            } catch(let error) {
                errorMessage = "Scan start failure" + "\n" + error.localizedDescription
            }
        } else {
            uiViewController.stopScanning()
        }
    }
    
    private func openURL(usrString: String) {
        guard let encurl = usrString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return
        }
        if let nsurl = NSURL(string: encurl) {
            if UIApplication.shared.canOpenURL(nsurl as URL) {
                UIApplication.shared.open(nsurl as URL)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: DataScanner
        
        init(_ parent: DataScanner) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {

        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            
            parent.captureImage = nil
            
            Task {
                if let image = try? await dataScanner.capturePhoto() {
                    parent.captureImage = image
                }
            }
        }
    }
}
