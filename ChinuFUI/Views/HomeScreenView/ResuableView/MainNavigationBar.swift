//
//  MainNavigationBar.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/04/25.
//

import SwiftUI

struct MainNavigationBar: View {
    var logoName: String = "chinuF_logo"
    var projectName: String = "CF"
    var onSearchTapped: () -> Void = {}
    var onNotificationTapped: () -> Void = {}

    var body: some View {
        HStack(spacing: 16) {
            Image(logoName)
                .resizable()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(projectName)
                .font(.headline)
                .foregroundColor(.primary)

            Spacer()

            Button(action: onSearchTapped) {
                Image(systemName: "")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(8)
            }

            Button(action: onNotificationTapped) {
                Image(systemName: "bell")
                    .foregroundColor(.black)
                    .font(.title2)
                    .padding(8)
            }
        }
        .padding(.top , -10)
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .bottom)
    }
}
