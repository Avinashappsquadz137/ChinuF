//
//  DropdownMenuView.swift
//  ChinuFUI
//
//  Created by Sanskar IOS Dev on 06/06/26.
//

import SwiftUI

struct DropdownMenuView: View {
    
    var onChinuTap: () -> Void
    var onTotalTap: () -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            dropdownRow(
                image: "chinuF_logo",
                title: "CHINU FILMS",
                action: onChinuTap
            )
            
            Divider()
            
            dropdownRow(
                image: "Total_multi",
                title: "TOTAL MULTIMEDIA",
                action: onTotalTap
            )
        }
        .frame(width: 250)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(
            color: .black.opacity(0.12),
            radius: 12,
            x: 0,
            y: 4
        )
    }
    
    // MARK: ROW
    
    func dropdownRow(
        image: String,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        
        Button(action: action) {
            
            HStack(spacing: 12) {
                
                Image(image)
                    .resizable()
                    .frame(width: 34, height: 34)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                   
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
    }
}
