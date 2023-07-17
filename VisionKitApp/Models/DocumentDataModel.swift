//
//  DocumentDataModel.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import SwiftUI
import Vision

class DocumentDataModel: ObservableObject {

    @Published var imageData: [UIImage] = []
    @Published var errorMessage: String = ""
    
    func detectedFromImage(image: UIImage) {
        let request = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results as? [VNRecognizedTextObservation] {
                if results.count != 0 {
                    DispatchQueue.main.async {
                        var result = ""
                        let maximumCandidates = 1
                        for observation in results {
                            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                            result += candidate.string
                            result += "\n"
                        }
                        let renderer = ImageRenderer(content: RenderView(text: result, color: Color.white))
                        if let uiImage = renderer.uiImage {
                            self.imageData.append(uiImage)
                        }
                    }
                }
                self.imageData.append(image)
            }
        })
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["ja"]
        
        guard let cgImage = image.cgImage else {
            errorMessage = "Failed to get cgimage from input image"
            return
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            errorMessage = "ImageRequestHandler failure"
        }
    }
}

