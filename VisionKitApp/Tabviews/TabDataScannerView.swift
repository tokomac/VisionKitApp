//
//  TabDataScannerView.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import SwiftUI
import VisionKit

struct TabDataScannerView: View {

    @State private var isScanning: Bool = false
    @State private var captureImage: UIImage?
    @State private var isSupportLiveText = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            if isSupportLiveText {
                DataScanner(isScanning: $isScanning,
                            captureImage: $captureImage,
                            errorMessage: $errorMessage)
                .navigationTitle("LiveText")
                .navigationBarItems(trailing: HStack {
                    if captureImage != nil {
                        Button {
                            captureImage = nil
                        } label: {
                            Label("Trash", systemImage: "trash")
                                .font(.title2 )
                        }
                    }
                })
            } else {
                MessageView(message: "LiveText is not available.")
            }
        }
        .overlay(alignment: .center) {
            ZStack(alignment: .center) {
                liveTextInteractionImage(image: captureImage, errorMessage: $errorMessage)
                    .padding()
            }
        }
        .overlay(alignment: .center, content: {
            if errorMessage != "" {
                MessageView(message: errorMessage)
            }
        })
        .onTapGesture(count: 2) {
            isScanning = false
            errorMessage = ""
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
