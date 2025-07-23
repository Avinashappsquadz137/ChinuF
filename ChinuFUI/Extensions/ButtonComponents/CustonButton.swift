//
//  CustonButton.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 26/04/25.
//

import SwiftUI

struct CustonButton: View {
    var title: String
    var backgroundColor: Color = .blue
    var titleColor: Color = .white
    var cornerRadius: CGFloat = 10
    var width: CGFloat? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(titleColor)
                .font(.headline)
                .frame(maxWidth: width == nil ? .infinity : nil)
                .padding(10)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
    }
}
