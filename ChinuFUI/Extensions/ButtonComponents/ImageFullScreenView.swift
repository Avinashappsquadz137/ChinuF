//
//  ImageFullScreenView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/08/25.

import SwiftUI

struct ImageFullScreenView: View {
    let imageURL: String
    @Binding var isPresented: Bool
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    // For opening animation
    @State private var appearAnim: Bool = false
    
    var body: some View {
        if isPresented {
            ZStack {
                // Background fade-in
                Color.black.opacity(appearAnim ? 0.6 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) { isPresented = false }
                    }
                
                VStack {
                    Spacer()
                    
                    if let url = URL(string: imageURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .shadow(radius: 10)
                                    // entry animation
                                    .scaleEffect(scale * (appearAnim ? 1 : 0.7))
                                    .opacity(appearAnim ? 1 : 0)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: appearAnim)
                                    .gesture(
                                        MagnificationGesture()
                                            .onChanged { value in
                                                scale = lastScale * value
                                            }
                                            .onEnded { _ in
                                                lastScale = scale
                                                if scale < 1 {
                                                    withAnimation {
                                                        scale = 1
                                                        lastScale = 1
                                                    }
                                                }
                                            }
                                    )
                            default:
                                ProgressView()
                            }
                        }
                    }
                    
                    Spacer()
                }
                
                // Close button
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.spring()) { isPresented = false }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .padding()
                                .opacity(appearAnim ? 1 : 0)
                                .scaleEffect(appearAnim ? 1 : 0.8)
                                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: appearAnim)
                        }
                    }
                    Spacer()
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    appearAnim = true
                }
            }
            .onDisappear {
                appearAnim = false
            }
            .transition(.opacity)
        }
    }
}

