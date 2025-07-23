//
//  FilePickerAdsView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 31/05/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct FilePickerAdsView: View {
    @Binding var selectedCategory: KathaCategory?
    @Binding var selectedUIImage: UIImage?
    @Binding var selectedFileUrl: URL?
    
    @State private var showImagePicker = false
    @State private var showDocumentPicker = false
    @State private var filePickerAds = false
    @State private var isCamera = false
    
    var body: some View {
        VStack {
            if let image = selectedUIImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .padding(.horizontal)
            }

            if selectedCategory?.kathaName == "Ads" {
                Button(action: {
                    filePickerAds = true
                }) {
                    HStack {
                        Text(selectedFileUrl?.lastPathComponent ?? (selectedUIImage != nil ? "Image Selected" : "Choose File"))
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    .padding(.horizontal)
                }
            }
        }
        .confirmationDialog("Choose From", isPresented: $filePickerAds, titleVisibility: .visible) {
            Button("Camera") {
                isCamera = true
                showImagePicker = true
            }
            Button("Photo Library") {
                isCamera = false
                showImagePicker = true
            }
            Button("Files") {
                showDocumentPicker = true
            }
            Button("Cancel", role: .cancel) {}
        }

        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(sourceType: isCamera ? .camera : .photoLibrary, selectedImage: $selectedUIImage)
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(selectedFile: $selectedFileUrl)
        }
    }
}
