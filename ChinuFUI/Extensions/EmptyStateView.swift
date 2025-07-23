//
//  EmptyStateView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 11/07/25.
//
import SwiftUI

struct EmptyStateView: View {
    var imageName: String
    var message: String
    var imageSize: CGFloat = 150

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .opacity(0.6)

            Text(message)
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
