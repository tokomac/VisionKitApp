//
//  TabBarcodeScannerVew.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import SwiftUI
import VisionKit

struct TabBarcodeScannerVew: View {
    
    @State private var isScanning: Bool = false
    @State private var qrString: String = ""
    @State private var positionX: Double = 0.0
    @State private var positionY: Double = 0.0
    @State private var captureImage: UIImage?
    @State private var tapBarcode: String = ""
    @State private var isSupportLiveText = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            if isSupportLiveText {
                BarcodeScanner(isScanning: $isScanning,
                               qrString: $qrString,
                               positionX: $positionX,
                               positionY: $positionY,
                               captureImage: $captureImage,
                               tapBarcode: $tapBarcode,
                               errorMessage: $errorMessage)
                .overlay(alignment: .bottomLeading, content: {
                    if !qrString.isEmpty {
                        VStack {
                            Text(qrString)
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.yellow.cornerRadius(20))
                                .position(x: positionX, y: positionY)
                        }
                    }
                })
                .overlay(alignment: .bottomLeading, content: {
                    ZStack(alignment: .center) {
                        liveTextInteractionImage(image: captureImage, errorMessage: $errorMessage)
                            .padding()
                    }
                })
                .overlay(alignment: .center, content: {
                    if !errorMessage.isEmpty {
                        MessageView(message: errorMessage)
                    }
                })
                .onTapGesture(count: 2) {
                    captureImage = nil
                    errorMessage = ""
                }
            } else {
                MessageView(message: "LiveText is not available.")
            }
        }
        .onAppear{
            isScanning = true
            self.isSupportLiveText = ImageAnalyzer.isSupported
            if !self.isSupportLiveText {
                isScanning = false
            }
        }
        .onDisappear{
            isScanning = false
        }
    }
}

@ViewBuilder
private func liveTextInteractionImage(image: UIImage?, errorMessage: Binding<String>) -> some View {
    if let img = image {
        LiveTextInteraction(image: img, errorMessage: errorMessage)
    }
}
