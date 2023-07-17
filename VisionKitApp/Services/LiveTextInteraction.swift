//
//  LiveTextInteraction.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import UIKit
import SwiftUI
import VisionKit

@MainActor
struct LiveTextInteraction: UIViewRepresentable {
    
    var image: UIImage
    private let imageView = LiveTextImageView()
    private let analyzer = ImageAnalyzer()
    private let interaction = ImageAnalysisInteraction()
    
    @Binding var errorMessage: String

    func makeUIView(context: Context) -> some UIView {
        self.imageView.image = self.image
        self.imageView.addInteraction(self.interaction)
        self.imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        Task {
            let configuration = ImageAnalyzer.Configuration([.text, .machineReadableCode])
            do {
                if let image = imageView.image {
                    let analysis = try await analyzer.analyze(image, configuration: configuration)
                    self.interaction.analysis = analysis
                    self.interaction.preferredInteractionTypes = .automatic
                }
            }
            catch {
                errorMessage = "Failure to analyze"
            }
        }
    }
}

class LiveTextImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        .zero
    }
}
