//
//  ClientDetailFormView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 12/07/25.
//
import SwiftUI

struct ClientDetailFormView: View {
    let booking: NewBooking
    @Environment(\.dismiss) private var dismiss
    @State private var clientName = ""
    @State private var panNumber = ""
    @State private var gstNumber = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Text("Booking Details")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    InfoRow(label: "Name", value: booking.name)
                    InfoRow(label: "Date", value: "\(booking.katha_date ?? "N/A") to \(booking.katha_from_Date ?? "N/A")")
                    InfoRow(label: "Venue", value: booking.venue)
                    InfoRow(label: "Time", value: booking.kathaTiming)
                }
                
                Divider().padding(.vertical, 8)
                
                Group {
                    Text("Client Information")
                        .font(.headline)
                    
                    FormField(title: "Name of Client", text: $clientName)
                    FormField(title: "PAN No", text: $panNumber)
                    FormField(title: "GST No", text: $gstNumber)
                }
                
                Spacer(minLength: 24)
                
                CustonButton(title: "Submit", backgroundColor: .maroon) {
                    if !clientName.isEmpty {
                        clientdetailAPI()
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Client Details Form")
        .navigationBarTitleDisplayMode(.inline)
    }

    func clientdetailAPI() {
        var dict: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode(),
            "katha_id": booking.katha_id ?? "",
            "client_ID": "0",
            "name": "\(clientName)",
            "gst_no": "\(gstNumber)",
            "pancard": "\(panNumber)",
        ]
       
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.clientdetailApi,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    print(model.data)
                    ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        dismiss()
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String?
    
    var body: some View {
        HStack {
            Text("\(label):")
                .font(.caption)
                .foregroundColor(.gray)
                .bold()
            Spacer()
            Text(value ?? "N/A")
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            TextField("Enter \(title)", text: $text)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
}
