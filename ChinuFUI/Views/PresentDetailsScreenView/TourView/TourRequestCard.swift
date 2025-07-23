//
//  TourRequestCard.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/06/25.
//

import SwiftUI

struct TourRequestCard: View {
    let tourId: String
    let status: String
    let location: String
    let date: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("TourId:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(tourId)
                            .truncationMode(.tail)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                            .padding(10)
                    }

                    HStack {
                        Text("Status:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(status == "-1" ? "Saved" : "")
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Location:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(location)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }

                    HStack {
                        Text("Date:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(date)
                            .font(.caption2) 
                            .lineLimit(1)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)

            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
