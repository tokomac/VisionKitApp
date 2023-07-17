//
//  BarcodeScannerModel.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import SwiftUI
import VisionKit

struct BarcodeScanner: UIViewControllerRepresentable {
    
    @Binding var isScanning: Bool
    @Binding var qrString: String
    @Binding var positionX: Double
    @Binding var positionY: Double
    @Binding var captureImage: UIImage?
    @Binding var tapBarcode: String
    @Binding var errorMessage: String
    
    @Environment(\.displayScale) var displayScale
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let recognizedDataTypes:Set<DataScannerViewController.RecognizedDataType> = [
            .barcode(),
            .text(textContentType: .URL),
        ]
        let dataScanner = DataScannerViewController(
            recognizedDataTypes: recognizedDataTypes,
            qualityLevel: .accurate,
            recognizesMultipleItems: false,
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
    
    @MainActor func render() {
        let renderer = ImageRenderer(content: RenderView(text: tapBarcode, color: Color.yellow))
        renderer.scale = displayScale

        if let uiImage = renderer.uiImage {
            captureImage = uiImage
        }
    }
    
    private func openURL(url: String) {
        if let nsurl = NSURL(string: url) {
            if UIApplication.shared.canOpenURL(nsurl as URL) {
                UIApplication.shared.open(nsurl as URL)
            }
        }
    }
    
    private func URLCheck(urlString: String) -> [String] {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return []
        }
        let enableLinkTuples = detector.matches(in: urlString, range: NSRange(location: 0, length: urlString.count))
        return enableLinkTuples.map { checkingResult -> String in
            return (urlString as NSString).substring(with: checkingResult.range)
        }
    }
    
    private func recognizedItem(item: RecognizedItem) {
        switch item {
        case .text( _):
            break
        case .barcode(let barcode):
            if let code = barcode.payloadStringValue {
                if URLCheck(urlString: code) != [] {
                    let arr:[String] = code.components(separatedBy: "/")
                    qrString = arr[2]
                } else {
                    qrString = code
                }
                positionX = (item.bounds.bottomLeft.x + item.bounds.bottomRight.x) / 2
                positionY = item.bounds.bottomLeft.y + 50
            }
        default:
            break
        }
    }
    
    private func updateItems(allItems: [RecognizedItem]) {
        for item in allItems {
            recognizedItem(item: item)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: BarcodeScanner
        
        init(_ parent: BarcodeScanner) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            parent.updateItems(allItems: allItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            parent.updateItems(allItems: allItems)
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didRemove updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            parent.qrString = ""
            parent.positionX = 0.0
            parent.positionY = 0.0
            parent.tapBarcode = ""
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            parent.captureImage = nil
            
            switch item {
            case .text(let text):
                if parent.URLCheck(urlString: text.transcript) != [] {
                    parent.openURL(url: text.transcript)
                }
            case .barcode(let barcode):
                if let code = barcode.payloadStringValue {
                    if parent.URLCheck(urlString: code) == [] {
                        parent.tapBarcode = code.trimmingCharacters(in: .whitespaces).enterInsert(40)
                        parent.render()
                    } else {
                        parent.openURL(url: code)
                    }
                }
            default:
                break
            }
        }
    }
}
