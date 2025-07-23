//
//  LeaveDetailView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 29/04/25.
//
import SwiftUI

struct LeaveDetailView: View {
    let detail: Events
    @Environment(\.dismiss) private var dismiss
    @State private var isImageFullScreen = false
    @State private var showRejectRemarkSheet = false
    @State private var rejectRemarkText = ""
    @State private var showToast = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                profileImageView
                    .frame(width: 60, height: 60)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.green, lineWidth: 2)
                    ) .onTapGesture {
                        isImageFullScreen = true
                    }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("EMP Code: \(detail.emp_Code ?? "Unknown")")
                        .font(.headline)
                    Text("Dept: \(detail.dept ?? "No Dept")")
                    Text("Leave Type: \(detail.leave_type ?? "No Leave Type")")
                    Text("From: \(detail.from_date ?? "N/A") To: \(detail.to_date ?? "N/A")")
                }
                
            }
            Text("Reason for Leave: \(detail.reason ?? "Leave")")
            AttendanceGridView(detail: detail)
            HStack( spacing: 16 ) {
                CustonButton(title: "Accept", backgroundColor: .green ,width: 100) {
                    print("Accept button tapped!")
                    if let reqID = detail.iD {
                        getGrant([reqID], "granted")
                    }
                }
                CustonButton(title: "Reject", backgroundColor: .red ,width: 100) {
                    print("Reject button tapped!")
                    showRejectRemarkSheet = true
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 10)
            Spacer()
        }
        .fullScreenCover(isPresented: $isImageFullScreen) {
            FullScreenImageView(imageURL: detail.pImg)
        }
        .sheet(isPresented: $showRejectRemarkSheet) {
            NavigationView {
                VStack(spacing: 20) {
                    Text("Please enter rejection reason")
                        .font(.headline)
                    
                    TextEditor(text: $rejectRemarkText)
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    HStack {
                        Button("Cancel") {
                            showRejectRemarkSheet = false
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button("Submit") {
                            if let reqID = detail.iD {
                                getGrant([reqID], "declined", reason: rejectRemarkText)
                            }
                            showRejectRemarkSheet = false
                        }
                        .disabled(rejectRemarkText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .navigationTitle("Reject Leave")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .overlay(showToast ? ToastView() : nil)
        .padding()
        .navigationTitle(detail.name ?? "Leave Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var profileImageView: some View {
        Group {
            if let urlString = detail.pImg, urlString.starts(with: "http"),
               let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else if let imageName = detail.pImg, UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
    func getGrant(_ id: [String], _ reply: String, reason: String? = nil) {
        var dict = [String: Any]()
        dict["req_id"] = id
        dict["reply"] = reply
        if let reason = reason {
            dict["reason"] = reason
        }
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.hodLeaveUpdate,
            method: .post,
            param: dict,
            model: SideBarApi.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        showToast = true
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                        print("Approved successfully.")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                            dismiss()
                        }
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")
                        print("API responded with failure: \(model)")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "\(error.localizedDescription)")
                    print("API Error: \(error)")
                }
            }
        }
    }
}
