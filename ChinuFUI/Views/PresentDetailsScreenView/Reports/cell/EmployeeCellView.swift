//
//  EmployeeCellView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 15/05/25.
//
import SwiftUI

struct EmployeeCellView: View {
    let name: String
    let empCode: String
    let department: String
    let imageUrl: String

    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                     .scaledToFill()
            } placeholder: {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))

            VStack(alignment: .leading, spacing: 5) {
                Text(name.uppercased())
                    .font(.headline)

                Text("Emp ID: \(empCode)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("\(department)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
