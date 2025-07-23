//
//  AddNewGuestView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 07/05/25.
//
import SwiftUI
import PhotosUI

struct AddNewGuestView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var guestName: String = ""
    @State private var guestAddress: String = ""
    @State private var reason: String = ""
    @State private var selectedDate = Date()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil


    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Group {
                        Text("Guest Name")
                            .font(.headline)
                        TextField("Enter Guest Name", text: $guestName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Address")
                            .font(.headline)
                        TextField("Enter Address", text: $guestAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Reason")
                            .font(.headline)
                        TextField("Enter Reason", text: $reason)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        DatePicker("Select Date & Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                            .font(.headline)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Photo")
                            .font(.headline)
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                                .cornerRadius(10)
                                .padding(.bottom, 5)
                        }
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Label("Select Photo", systemImage: "photo")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = uiImage
                                }
                            }
                        }
                    }
                    CustonButton(
                        title: "Submit",
                        backgroundColor: (guestName.isEmpty || guestAddress.isEmpty || reason.isEmpty || selectedImage == nil) ? .gray : .maroon
                    ) {
                        addNewGuestApi()
                    }
                    .disabled(guestName.isEmpty || guestAddress.isEmpty || reason.isEmpty || selectedImage == nil)
                }
                .padding()
            }
        }
        .overlay(ToastView())
    }
    //MARK: - Multi Part
    func addNewGuestApi() {
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        dict["Guest_Name"] = guestName
        dict["Address"] = guestAddress
        dict["Reason"] = reason
        dict["Date1"] = ISO8601DateFormatter().string(from: selectedDate)
        
        if let image = selectedImage?.resizeToWidth(250),
           let imageData = image.pngData() {
            
            ApiClient.shared.callHttpMethod(
                apiendpoint: Constant.applyNewGuest,
                method: .post,
                param: dict,
                model: GetSuccessMessage.self,
                isMultipart: true,
                images: ["image": imageData]
            ) { result in
                switch result {
                case .success(let model):
                    if model.status == true {
                        ToastManager.shared.show(message: model.message ?? "Successfully updated repair details")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            dismiss()
                        }
                    } else {
                        print("Request failed: \(model.message ?? "Unknown error")")
                    }
                case .failure(let error):
                    print("Error updating repair details:", error)
                }
            }
        }
    }
}

