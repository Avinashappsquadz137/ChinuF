//
//  PreViewBillingDetailsView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 01/07/25.
//

import SwiftUI

struct PreViewBillingDetailsView: View {
    let request: BillingList
    @State private var tourRequests: [BillingList] = []
    @Binding var selectedSno: Int?
    @Environment(\.dismiss) private var dismiss
    @State private var showEditAlert = false
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        VStack {
            ScrollView {
                if let firstBillingList = tourRequests.first,
                   let details = firstBillingList.alldata {
                    VStack(spacing: 12) {
                        ForEach(details.indices, id: \.self) { index in
                            let detail = details[index]
                            BillingDetailCard(
                                sno: (index + 1),
                                amount: detail.amount ?? "0",
                                imageName: detail.billing_thumbnail,
                                onDelete: {
                                    selectedSno = detail.sno
                                    showDeleteConfirmation = true
                                }
                            )
                        }
                    }
                    .padding()
                } else {
                    Text("No billing details available.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            CustonButton(title: "Submit", backgroundColor: .maroon) {
                submitTourBill(tourID: "\(request.tourID ?? "")")
            }
            .padding()
        }
        .onAppear() {
            tourBillingApprovalList()
        }
        .alert("Are you sure you want to delete this entry?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                print("Deleted entry \(selectedSno ?? -1)")
                if let sno = selectedSno,
                   let details = tourRequests.first?.alldata,
                   let detail = details.first(where: { $0.sno == sno }) {
                    deleteBillRequest(serionNO: detail.sno ?? 0, tourID: detail.tour_id ?? "")
                }
                
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    func tourBillingApprovalList() {
        let params: [String: Any] = [
            "Emp_Code": "\(UserDefaultsManager.getEmpCode())",
            "type": "0",
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getTourBillingApprovalList,
            method: .post,
            param: params,
            model: TourBillingListModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.tourRequests = model.data ?? []
                    ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                case .failure(let error):
                    ToastManager.shared.show(message: "Failed to fetch tour list.")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func deleteBillRequest(serionNO : Int , tourID : String) {
        let dict: [String: Any] = [
            "sno": "\(serionNO)",
            "Tour_Id": tourID
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.deleteBillingRequest,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                        print("Leave applied successfully.")
                        self.tourBillingApprovalList()
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")
                        print("API responded with failure: \(model)")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func submitTourBill(tourID : String) {
        let dict: [String: Any] = [
            "EmpCode": "\(UserDefaultsManager.getEmpCode())",
            "Tour_Id": tourID
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.submitTourBillRequest,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                        dismiss()
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")
                        print("API responded with failure: \(model)")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
}


struct BillingDetailCard: View {
    let sno: Int
    let amount: String
    let imageName: String?
    var onDelete: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("SNO.")
                    .fontWeight(.bold)
                Spacer()
                Text("Image")
                    .fontWeight(.bold)
                Spacer()
                Text("Amount")
                    .fontWeight(.bold)
            }
            HStack {
                Text("\(sno)")
                Spacer()
                
                if let imageName = imageName, !imageName.isEmpty,
                   let url = URL(string: "https://sap.sanskargroup.in/uploads/tour/\(imageName)") {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .frame(width: 40, height: 40)
                                .cornerRadius(6)
                        case .failure(_):
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        default:
                            ProgressView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Text("₹ \(String(format: "%.2f", Double(amount) ?? 0.0))")
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
            }
            HStack {
                Spacer()
                Button(action: onDelete) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .foregroundColor(.red)
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}
