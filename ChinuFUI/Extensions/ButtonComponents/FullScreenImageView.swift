//
//  FullScreenImageView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 29/04/25.
//
import SwiftUI

struct FullScreenImageView: View {
    let imageURL: String?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            if let imageURL = imageURL,
               let url = URL(string: imageURL),
               imageURL.starts(with: "http") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(.top,70)
                    case .failure:
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(.top,70)
            }

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
            }
        }
        
    }
}

