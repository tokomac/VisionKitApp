//
//  TabDocumentDataView.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import SwiftUI
import VisionKit

private struct detailView: View{
    
    @State private var errorMessage: String = ""
    
    let image: UIImage
    
    var body: some View{
        VStack {
            liveTextInteractionImage(image: image, errorMessage: $errorMessage)
        }
        .overlay(alignment: .center, content: {
            if !errorMessage.isEmpty {
                MessageView(message: errorMessage)
            }
        })
        .onTapGesture(count: 2) {
            errorMessage = ""
        }
    }
}

struct TabDocumentDataView: View {

    @StateObject private var model: DocumentDataModel = .init()
    @State private var isScanning: Bool = false
    @State private var isPhoto: Bool = false
    @State private var navigationPath = NavigationPath()
    @State private var isSupportLiveText = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                ForEach(model.imageData, id: \.self) { data in
                    Button(action: {
                        navigationPath.append(data)
                    }, label: {
                        VStack {
                            Image(uiImage: data)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    })
                }
                .onDelete(perform: rowRemove)
            }
            .navigationTitle("DocumentCamera")
            .navigationBarItems(trailing: HStack {
                Button {
                    isPhoto.toggle()
                } label: {
                    Label("Photo", systemImage: "photo.on.rectangle")
                        .font(.title2)
                }
                .disabled(!self.isSupportLiveText)
                .fullScreenCover(isPresented: $isPhoto) {
                    ImagePickerView(dataModel: model, errorMessage: $errorMessage)
                }
                Button {
                    isScanning.toggle()
                } label: {
                    Label("Scan", systemImage: "camera")
                        .font(.title2)
                }
                .disabled(!self.isSupportLiveText)
                .fullScreenCover(isPresented: $isScanning) {
                    CameraView(dataModel: model, isScanning: $isScanning)
                }
            })
            .overlay(alignment: .center, content: {
                if !model.errorMessage.isEmpty {
                    MessageView(message: model.errorMessage)
                }
            })
            .overlay(alignment: .center, content: {
                if !errorMessage.isEmpty {
                    MessageView(message: errorMessage)
                }
            })
            .onTapGesture(count: 2) {
                model.errorMessage = ""
                errorMessage = ""
            }
            .navigationDestination(for: UIImage.self) { data in
                detailView(image: data)
            }
        }
        .onAppear {
            self.isSupportLiveText = ImageAnalyzer.isSupported
        }
    }

    private func rowRemove(offsets: IndexSet) {
        model.imageData.remove(atOffsets: offsets)
    }
    
}

@ViewBuilder
private func liveTextInteractionImage(image: UIImage?, errorMessage: Binding<String>) -> some View {
    if let img = image {
        LiveTextInteraction(image: img, errorMessage: errorMessage)
    }
}
