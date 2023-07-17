//
//  MessageView.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import SwiftUI

struct MessageView: View {
    
    let message: String

    var body: some View {
        VStack {
            Text(message)
                .font(.title)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.red.cornerRadius(20))
        }
    }
}
