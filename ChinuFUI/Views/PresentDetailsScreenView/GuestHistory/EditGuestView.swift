//
//  EditGuestView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 07/05/25.
//

import SwiftUI

struct EditGuestView: View {
    var guest: GuestHistory
    
    @Environment(\.dismiss) private var dismiss
    
    // Editable fields
    @State private var name: String = ""
    @State private var mobile: String = ""
    @State private var reason: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedImage: UIImage? = nil
    @State private var isImageFullScreen = false
    var selectedId: String? {
        return guest.id
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                // MARK: Guest Image
                if let imageUrl = guest.image, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
                    .onTapGesture {
                        isImageFullScreen = true
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                }
                
                // MARK: Editable Name Field
                TextField("Guest Name", text: $name)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                // MARK: Date Picker
                DatePicker("Select Date & Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                // MARK: Mobile TextField
                TextField("Mobile Number", text: $mobile)
                    .keyboardType(.phonePad)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                // MARK: Reason TextEditor
                VStack(alignment: .leading) {
                    Text("Reason")
                        .font(.headline)
                    TextEditor(text: $reason)
                        .frame(height: 100)
                        .padding(4)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4)))
                }
                
                // MARK: Submit Button
                CustonButton(title: "Submit", backgroundColor: .maroon) {
                    editGuestRequest()
                }
            }
            .padding()
        }
        .onAppear {
            name = guest.name ?? ""
            reason = guest.reason ?? ""
            if let imageUrlString = guest.image,
               let url = URL(string: imageUrlString) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let uiImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.selectedImage = uiImage
                        }
                    }
                }.resume()
            }
        }
        .fullScreenCover(isPresented: $isImageFullScreen) {
            FullScreenImageView(imageURL: guest.image)
        }

        .navigationTitle("Edit Guest")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: Edit Guest Request Function
    func editGuestRequest() {
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        dict["Guest_Name"] = name
        dict["id"] = selectedId ?? ""
        dict["WhomtoMeet"] = "\(UserDefaultsManager.getName())"
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
                        ToastManager.shared.show(message: model.message ?? "Successfully updated guest")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            dismiss()
                        }
                    } else {
                        print("Request failed: \(model.message ?? "Unknown error")")
                    }
                case .failure(let error):
                    print("Error updating guest:", error)
                }
            }
        }
    }
}
