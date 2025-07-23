//
//  BookingApproveSchedule.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/05/25.
//
import SwiftUI

struct BookingApproveSchedule: View {
    let booking: NewBooking
    @State var isSelected: Bool = false
    @State var showSelection: Bool = false
    @State private var suggestedFromDateTime: String = ""
    @State private var suggestedToDateTime: String = ""
    @State private var remarkText: String = ""
    @State private var suggestedFromDate = Date()
    @State private var suggestedToDate = Date()
    @State private var showRemarkAlert = false

    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 5) {
                Text("\(booking.name ?? "N/A")")
                    .fontWeight(.semibold)
                HStack {
                    Text("Amount: \(booking.amount ?? "N/A")")
                        .font(.caption2)
                    Spacer()
                    Text("GST: \(booking.gST ?? "N/A")")
                        .font(.caption2)
                }
                Text("Channel: \(booking.channelName ?? "N/A")").font(.caption2)
                Text("Date: \(booking.katha_date ?? booking.katha_from_Date ?? "N/A")").font(.caption2)
                Text("Time: \(booking.kathaTiming ?? booking.slotTiming ?? "N/A")").font(.caption2)
                Text("Venue: \(booking.venue ?? "N/A")").font(.caption2)
                HStack {
                    Button(action: {
                        self.isSelected.toggle()
                    }) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isSelected ? .green : .gray)
                    }
                    Text("Do you want to suggest any Other Date/Time ?").font(.footnote)
                    
                }
                if isSelected {
                    Text("Suggest Date and Time")
                    
                    DatePicker(
                        "From",
                        selection: $suggestedFromDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)

                    DatePicker(
                        "To ",
                        selection: $suggestedToDate,
                        in: suggestedFromDate...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                }
                
                Text("Remarks")
                TextEditor(text: $remarkText)
                    .frame(height: 100)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4))
                    )
                if isSelected {
                    Button(action: {
                        suggestionBooking()
                    }) {
                        Text("Suggest")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(remarkText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.green) 
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(remarkText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                } else {
                    HStack(spacing: 20) {
                        Button(action: {
                            approveRejectBooking(status: "2")
                        }) {
                            Text("Approve")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            approveRejectBooking(status: "1")
                        }) {
                            Text("Reject")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }.padding(.horizontal)
                }
                
            }
            .alert(isPresented: $showRemarkAlert) {
                Alert(
                    title: Text("Validation"),
                    message: Text("Please enter remarks before suggesting."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .overlay(ToastView())
            .padding()
            .navigationTitle("BookingApprove/Suggest")
        }
    }
    
    func approveRejectBooking(status : String) {
        var dict = Dictionary<String, Any>()
        dict["katha_id"] = "\(booking.katha_id ?? 0)"
        dict["EmpCode"] = UserDefaultsManager.getEmpCode()
        dict["status"] = status
        dict["salesEmpCode"] = booking.salesEmpCode
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.kathaApprovalApi,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    ToastManager.shared.show(message: model.message ?? "Success")
                case .failure(let error):
                    ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                    print("API Error: \(error)")
                }
            }
        }
    }
    func suggestionBooking() {
        if remarkText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                showRemarkAlert = true
                return
            }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let suggestionDateStr = dateFormatter.string(from: suggestedFromDate)
        let suggestionEndDateStr = dateFormatter.string(from: suggestedToDate)
        let suggestionStartTimeStr = timeFormatter.string(from: suggestedFromDate)
        let suggestionEndTimeStr = timeFormatter.string(from: suggestedToDate)
        
        var dict = Dictionary<String, Any>()
        dict["katha_id"] = "\(booking.katha_id ?? 0)"
        dict["EmpCode"] = UserDefaultsManager.getEmpCode()
        dict["status"]   = "4"
        dict["suggestion_date"] = suggestionDateStr
        dict["suggestion_end_date"] = suggestionEndDateStr
        dict["suggestion_time"] = suggestionStartTimeStr
        dict["suggestion_end_time"] = suggestionEndTimeStr
        dict["Remarks"] = remarkText
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.kathaApprovalApi,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    ToastManager.shared.show(message: model.message ?? "Success")
                case .failure(let error):
                    ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                    print("API Error: \(error)")
                }
            }
        }
    }
}
