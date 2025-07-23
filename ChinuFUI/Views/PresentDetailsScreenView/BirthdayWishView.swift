//
//  BirthdayWishView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 29/04/25.
//

import SwiftUI

struct BirthdayWishView: View {
    let detail: Events
    @State private var messageText: String = ""
    @Environment(\.dismiss) private var dismiss
    let onWished: () -> Void
    let defaultMessages = [
        "Wishing you a day filled with love and cheer!",
        "Have a wonderful birthday!",
        "Happy Birthday! Stay blessed!"
    ]
    
    var body: some View {
        ScrollView{
        VStack(spacing: 15) {
            // Profile Image
            if let imageUrl = detail.pImg, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 150, height: 150)
                .clipShape(Rectangle())
                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                .shadow(radius: 4)
                
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
            }
            
            Text("Happy Birthday")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text("To our dear \(detail.name ?? "friend")")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Default Message Buttons
            VStack(alignment: .leading, spacing: 5) {
                Text("Select a message:")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                ForEach(defaultMessages, id: \.self) { msg in
                    Button(action: {
                        messageText = msg
                    }) {
                        Text(msg)
                            .font(.system(size: 16))
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            
            // TextField
            TextEditor(text: $messageText)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .frame(height: 100)
                .padding(.horizontal)
            
            // Send Button
            Button(action: {
                print("Message sent: \(messageText)")
                birthdayWishreply()
                
            }) {
                Text("Send")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            Spacer()
        }
        }
        .overlay(ToastView())
      
    }
    func birthdayWishreply() {
        var dict = [String: Any]()
        dict["EmpCode"] = detail.emp_Code
        dict["Message"] = messageText
        dict["Sent_by"] =  "\(UserDefaultsManager.getEmpCode())"
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.birthdayWishreply,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        ToastManager.shared.show(message: model.message ?? "Wished successfully")
                        messageText = ""
                        onWished()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Something went wrong")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
}
