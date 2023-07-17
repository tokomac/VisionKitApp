//
//  RenderView.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import SwiftUI

struct RenderView: View {
    
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(size: 14))
            .frame(minWidth: 0, minHeight: 0, alignment: .leading)
            .foregroundStyle(.black)
            .padding(10)
            .background(color.cornerRadius(20))
    }
}
