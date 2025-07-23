//
//  SavedTourView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/06/25.
//

import SwiftUI
import PhotosUI

struct SavedTourView: View {
    let request: BillingList
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var fileName: String = ""
    @State private var remarkText = ""
    @State private var amounts = ""
    @State private var showDateilScreen = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSno: Int? = nil
    @State private var navigate = false
    var totalAmount: Double = 0.0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("TourId:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(request.tourID ?? "")
                            .truncationMode(.tail)
                    }
                    HStack {
                        Text("Location:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(request.location ?? "")
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    HStack {
                        Text("Amount")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("₹\(String(format: "%.2f", calculateTotalAmount()))")
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 2)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Add Bill Image")
                            .fontWeight(.semibold)
                        Spacer()
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Image(systemName: "plus.square.dashed")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                        }
                    }

                    if let selectedImage = selectedImage {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)

                            Image(systemName: "plus.square.dashed")
                                .padding(8)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                                .padding(5)
                        }

                        if !fileName.isEmpty {
                            Text("File: \(fileName)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }

                    TextField("Enter Amount", text: $amounts)
                        .keyboardType(.numberPad)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                    TextEditor(text: $remarkText)
                        .frame(height: 100)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3))
                        )
                        .overlay(
                            Group {
                                if remarkText.isEmpty {
                                    Text("Remark ...")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                        .padding(.top, 12)
                                }
                            }, alignment: .topLeading
                        )
        
                    CustonButton(
                        title: "SAVE",
                        backgroundColor: (amounts.isEmpty || remarkText.isEmpty) ? .gray : .maroon
                    ) {
                        billingRequest()
                    }
                    .disabled(amounts.isEmpty || remarkText.isEmpty)

                    CustonButton(title: "Preview", backgroundColor: .maroon) {
                        navigate = true
                    }

                    NavigationLink(
                        destination: PreViewBillingDetailsView(
                            request: request,
                            selectedSno: $selectedSno
                        ),
                        isActive: $navigate,
                        label: { EmptyView() }
                    )
                    .hidden()
                }
            }
            .padding()
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        self.selectedImage = uiImage
                        self.fileName = newItem?.itemIdentifier ?? "Selected Image"
                    }
                }
            }
        }
    }
    func calculateTotalAmount() -> Double {
        guard let data = request.alldata else { return 0.0 }
        return data.compactMap { Double($0.amount ?? "0") }.reduce(0, +)
    }
    
    func billingRequest() {
        var dict = [String: Any]()
        dict["EmpCode"] = UserDefaultsManager.getEmpCode()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dict["date"] = dateFormatter.string(from: Date())
        dict["Amount"] = amounts
        dict["Tour_id"] = request.tourID
        dict["reason"] = remarkText
        
        var imagesData: [String: Data] = [:]

        if let selectedUIImage = selectedImage,
           let imageData = selectedUIImage.jpegData(compressionQuality: 0.8) {
            imagesData["image"] = imageData
        }
        
        ApiClient.shared.callHttpMethod(
            apiendpoint: Constant.tourBillingRequestIos,
            method: .post,
            param: dict,
            model: TourBillingRequestModel.self,
            isMultipart: true,
            images: imagesData
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    ToastManager.shared.show(message: model.message ?? "Successfully booked katha")
                    dismiss()
                case .failure(let error):
                    ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                    print("Error booking katha:", error)
                }
            }
        }
    }
    
}

