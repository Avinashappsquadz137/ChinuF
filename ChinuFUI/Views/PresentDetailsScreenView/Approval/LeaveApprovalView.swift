//
//  LeaveApprovalView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 15/05/25.
//
import SwiftUI

struct LeaveApprovalView: View {
    @State private var selectedSegment = 0
    @State private var searchText = ""
    @State private var leaveRequests: [LeaveHistory] = []
    @State private var selectedRequests: [String] = []
    @State private var remarkText = ""

    
    var filteredLeaves: [LeaveHistory] {
        let nonNilLeaves = leaveRequests.filter { $0.application_No != nil }

        if selectedSegment == 0 && !searchText.isEmpty {
            return nonNilLeaves.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }

        return nonNilLeaves
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
            if selectedSegment == 0 {
                HStack {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(selectedRequests.count == filteredLeaves.count ? "Unselect All" : "Select All") {
                        if selectedRequests.count == filteredLeaves.count {
                            selectedRequests.removeAll()
                        } else {
                            selectedRequests = filteredLeaves.compactMap { $0.application_No.map { String($0) } }
                        }
                    }
                }
                .padding(.horizontal)
            }
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredLeaves, id: \.application_No) { leave in
                        LeaveCellView(
                            leave: leave,
                            showSelection: selectedSegment == 0,
                            isSelected: Binding(
                                get: {
                                    if let id = leave.application_No {
                                        return selectedRequests.contains(String(id))
                                    }
                                    return false
                                },
                                set: { newValue in
                                    guard let id = leave.application_No else { return }
                                    let strId = String(id)
                                    if newValue {
                                        if !selectedRequests.contains(strId) {
                                            selectedRequests.append(strId)
                                        }
                                    } else {
                                        selectedRequests.removeAll { $0 == strId }
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
                                    hodLeaveUpdate(reply: "approved")
                                }) {
                                    Text("Approve")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }

                                Button(action: {
                                    hodLeaveUpdate(reply: "declined")
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
        case 0:
            approveList(type: "\(selectedSegment)")
            break
        case 1:
            approveList(type: "\(selectedSegment)")
            break
        case 2:
            approveList(type: "\(selectedSegment)")
            break
        default:
            break
        }
    }
    
    func approveList(type: String) {
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        dict["type"] = type
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.approveListHistory,
            method: .post,
            param: dict,
            model: LeaveHistoryModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        if let leaves = model.data {
                            self.leaveRequests = leaves
                        }
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                    } else {
                        self.leaveRequests = []
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func hodLeaveUpdate(reply: String) {
        for id in selectedRequests {
            var dict = [String: Any]()
            dict["req_id"] = id
            dict["reply"] = reply
            dict["reason"] = remarkText

            ApiClient.shared.callmethodMultipart(
                apiendpoint: Constant.hodLeaveUpdate,
                method: .post,
                param: dict,
                model: GetSuccessMessage.self
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        if model.status == true {
                            ToastManager.shared.show(message: model.message ?? "Success")
                            remarkText = ""
                            selectedRequests.removeAll()
                            fetchLeaveData()
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

}


struct LeaveCellView: View {
    let leave: LeaveHistory
    var showSelection: Bool = false
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            
            if let imageUrl = leave.imageURL, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(leave.name?.uppercased() ?? "").font(.headline)
                Text("\(leave.department ?? "-")").font(.caption2)
                Text("\(leave.leave_From ?? "-") To \(leave.leave_to ?? "-")").font(.caption2)
                Text("\(leave.type ?? "-")").font(.caption2)
                Text("\(leave.lReason ?? "-")").font(.caption2)
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
