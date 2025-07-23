//
//  CustomNavigationBar.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 07/05/25.
//
import SwiftUI

struct CustomNavigationBar: View {

    var title: String = ""
    var onFilter: (() -> Void)? = nil
    var onSearch: ((String) -> Void)? = nil
    var onAddListToggle: (() -> Void)? = nil
    var isListMode: Bool = true
    var showFilter: Bool = false

    @State private var isSearching = false
    @State private var searchText = ""

    var body: some View {
        VStack {
            HStack {
                if isSearching {
                    TextField("Search...", text: $searchText)
                        .onChange(of: searchText) { newValue in
                            onSearch?(newValue)
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .transition(.move(edge: .trailing))
                    
                    Button(action: {
                        isSearching = false
                        searchText = ""
                        onSearch?("") 
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                } else {
                    if !showFilter {
                        if let onFilter = onFilter {
                            Button(action: onFilter) {
                                Image(systemName: "line.horizontal.3.decrease.circle")
                                    .font(.system(size: 22))
                            }
                        }
                    }
                    if onSearch != nil {
                        Button(action: {
                            withAnimation {
                                isSearching = true
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 22))
                        }
                    }
                    Spacer()
                    if let onAddListToggle = onAddListToggle {
                        Button(action: onAddListToggle) {
                            HStack(spacing: 4) {
                                Image(systemName: isListMode ? "plus" : "plus")
                                Text(isListMode ? "New Guest" : "New")
                            }
                        }
                    }
                }
            }
            .padding(10)
        }
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding()
    }
}
