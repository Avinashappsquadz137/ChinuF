//
//  BookingApprovalView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 15/05/25.
//
import SwiftUI

struct BookingApprovalView: View {
    
    @State private var selectedSegment = 0
    @State private var searchText = ""
    @State private var bookingRequests: [BookingHistory] = []
    @State private var selectedRequests: [String] = []
    @State private var remarkText = ""
  

    var filteredBooking: [BookingHistory] {
        let nonNilBooking = bookingRequests.filter { $0.katha_id != nil }

        if selectedSegment == 0 && !searchText.isEmpty {
            return nonNilBooking.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
        return nonNilBooking
    }

    
    var body: some View {
        VStack {
            Picker("Status", selection: $selectedSegment) {
                Text("Pending").tag(0)
                Text("Approved").tag(1)
                Text("History").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            if selectedSegment == 0  || selectedSegment == 1{
                HStack {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if selectedSegment == 0 {
                        Button(selectedRequests.count == filteredBooking.count ? "Unselect All" : "Select All") {
                            if selectedRequests.count == filteredBooking.count {
                                selectedRequests.removeAll()
                            } else {
                                selectedRequests = filteredBooking.compactMap { $0.katha_id.map { String($0) } }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredBooking, id: \.katha_id) { leave in
                        BookingCellView(
                            booking: leave,
                            showSelection: selectedSegment == 0,
                            isSelected: Binding(
                                get: {
                                    if let id = leave.katha_id {
                                        return selectedRequests.contains(id)
                                    }
                                    return false
                                },
                                set: { newValue in
                                    guard let id = leave.katha_id else { return }
                                    if newValue {
                                        selectedRequests.append(id)
                                    } else {
                                        selectedRequests.removeAll { $0 == id }
                                    }
                                }
                            )
                        )

                    }

                }
                .padding()
            }
            if selectedSegment == 0 && !selectedRequests.isEmpty {
                        VStack(spacing: 10) {
                            TextEditor(text: $remarkText)
                                .frame(height: 100)
                                .padding(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.systemGray4))
                                )
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    bulkUpdateBookingStatus("1")
                                }) {
                                    Text("Approve")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }

                                Button(action: {
                                    bulkUpdateBookingStatus("2")
                                }) {
                                    Text("Reject")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.horizontal)
                        }.padding()
                    }
            Spacer()
        }
        .onAppear {
            fetchLeaveData()
        }
        .onChange(of: selectedSegment) { _ in
            fetchLeaveData()
        }
    }

    func fetchLeaveData() {
        switch selectedSegment {
        case 0, 1, 2:
            kathaBookingDetail()
        default:
            print("Unknown segment selected.")
        }
    }

    func bulkUpdateBookingStatus(_ status: String) {
        let idsToUpdate = Array(selectedRequests)
        guard !idsToUpdate.isEmpty else { return }
        
        var dict: [String: Any] = [
            "EmpCode": "\(UserDefaultsManager.getEmpCode())",
            "katha_id": idsToUpdate,
            "status": status,
            "remark": remarkText
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.kathaApproval,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self 
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        bookingRequests.removeAll {
                            if let id = $0.katha_id {
                                return selectedRequests.contains(id)
                            }
                            return false
                        }
                        selectedRequests.removeAll()
                        remarkText = ""
                        ToastManager.shared.show(message: model.message ?? "Updated Successfully")
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Error occurred")
                    print("API Error: \(error)")
                }
            }
        }
    }

    
    func kathaBookingDetail() {
        
            ApiClient.shared.callmethodMultipart(
                apiendpoint: Constant.kathaBookingDetail,
                method: .post,
                param: [:],
                model: BookingHistoryModel.self
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        if model.status == true {
                            self.bookingRequests = model.data ?? []
                            ToastManager.shared.show(message: model.message ?? "Success")
                            selectedRequests.removeAll()
                        } else {
                            ToastManager.shared.show(message: model.message ?? "Something went wrong.")
                        }
                    case .failure(let error):
                        ToastManager.shared.show(message: "Error occurred")
                        print("API Error: \(error)")
                    }
                }
            }
        
    }

}


struct BookingCellView: View {
    let booking: BookingHistory
    var showSelection: Bool = false
    @Binding var isSelected: Bool

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(booking.name?.uppercased() ?? "").font(.caption2)
                Text(booking.venue ?? "-").font(.caption2)
                Text("\(booking.katha_from_Date ?? "-")").font(.caption2)
                Text("\(booking.channelName ?? "-")").font(.caption2)
            }
            Spacer()
            if showSelection {
                Button(action: {
                    isSelected.toggle()
                }) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .green : .gray)
                }
            }
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}
