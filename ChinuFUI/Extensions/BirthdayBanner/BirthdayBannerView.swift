//
//  BirthdayBannerView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 24/03/26.
//

import SwiftUI

struct BirthdayBannerView: View {
    
    var body: some View {
        ZStack {
            
            // 🎨 Gradient Background
            LinearGradient(
                colors: [Color.orange, Color.pink],
                startPoint: .leading,
                endPoint: .trailing
            )
            
            // 🎊 Confetti Overlay (static icons for now)
            GeometryReader { geo in
                ForEach(0..<15, id: \.self) { _ in
                    Circle()
                        .fill(randomColor())
                        .frame(width: CGFloat.random(in: 6...10),
                               height: CGFloat.random(in: 6...10))
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                        .opacity(0.8)
                }
            }
            
            // 🎂 Text Content
            VStack(spacing: 4) {
                Text("🎉 Happy Birthday! 🎂")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Wishing you a fantastic year ahead!")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.95))
            }
        }
        .frame(height: 70)
        .cornerRadius(16)
        //.padding()
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
    }
    
    // 🎨 Random confetti colors
    func randomColor() -> Color {
        [Color.yellow, Color.blue, Color.green, Color.red, Color.purple].randomElement()!
    }
}




struct BirthdayBadgeView: View {
    var body: some View {
        VStack(spacing: -10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.orange, Color.pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(color: .orange.opacity(0.5), radius: 8, x: 0, y: 4)
                
                Text("🎂")
                    .font(.system(size: 20))
            }
            Text("Birthday Today")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    LinearGradient(
                        colors: [Color.red, Color.pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
        }
    }
}
import SwiftUI

struct ConfettiView: View {
    @State private var animate = false
    let particleCount = 60
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<particleCount, id: \.self) { i in
                    Circle()
                        .fill(randomColor())
                        .frame(width: CGFloat.random(in: 6...10),
                               height: CGFloat.random(in: 6...10))
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: animate
                                ? geo.size.height + CGFloat.random(in: 0...100)
                                : -20
                        )
                        .animation(
                            Animation.easeIn(duration: Double.random(in: 3...5))
                                .delay(Double(i) * 0.03),
                            value: animate
                        )
                }
            }
            .onAppear {
                animate = true
            }
        }
        .ignoresSafeArea()
    }
    
    func randomColor() -> Color {
        [
            .red, .yellow, .blue,
            .green, .pink, .orange,
            .purple
        ].randomElement()!
    }
}
