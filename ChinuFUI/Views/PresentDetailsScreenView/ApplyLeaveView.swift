//
//  ApplyLeaveView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/04/25.
//

import SwiftUI

struct ApplyLeaveView: View {
    
    // MARK: - State Properties
    @State private var selectedLeaveType = "Full"
    @State private var fromDate = Calendar.current.startOfDay(for: Date())
    @State private var toDate = Calendar.current.startOfDay(for: Date())
    @State private var fromDayType = "Full"
    @State private var toDayType = "Full"
    @State private var remarks = ""
    @State private var name: String = UserDefaultsManager.getName()
    @State private var empCode: String = UserDefaultsManager.getEmpCode()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var showToast = false
    @State private var leaveTypes = ["Full", "Half","Comp off", "WFH"]
    @State private var halfTypes = ["First Half", "Second Half"]
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Group {
                    Text("Select Leave Type")
                        .font(.caption)
                        .foregroundColor(.gray)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(leaveTypes, id: \.self) { type in
                                Button(action: {
                                    selectedLeaveType = type
                                    switch type {
                                    case "Full":
                                        fromDayType = "Full"
                                        toDayType = "Full"
                                    case "Comp off":
                                        fromDayType = "Comp Off"
                                        toDayType = "Comp Off"
                                    case "WFH":
                                        fromDayType = "WFH"
                                        toDayType = "WFH"
                                    case "Half":
                                        fromDayType = "First Half"
                                        toDayType = "First Half"
                                    default:
                                        break
                                    }
                                }) {
                                    Text(type)
                                        .font(.subheadline)
                                        .foregroundColor(selectedLeaveType == type ? .white : .blue)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedLeaveType == type ? Color.blue : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.blue, lineWidth: 1)
                                        )
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    if selectedLeaveType == "Half" {
                        Text("Select Half Day Type")
                            .font(.caption)
                            .foregroundColor(.gray)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(halfTypes, id: \.self) { half in
                                    Button(action: {
                                        fromDayType = half
                                        toDayType = half
                                    }) {
                                        Text(half)
                                            .font(.subheadline)
                                            .foregroundColor(fromDayType == half ? .white : .blue)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(fromDayType == half ? Color.blue : Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.blue, lineWidth: 1)
                                            )
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }

                Group {
                    Text("Leave Balance")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(UserDefaultsManager.getPlBalance())")
                        .font(.body)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("From Date")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            DatePicker(
                                "",
                                selection: $fromDate,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .onChange(of: fromDate) { newValue in
                                fromDate = Calendar.current.startOfDay(for: newValue)
                                
                                if toDate < fromDate {
                                    toDate = fromDate
                                }
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Select Day Type")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(fromDayType)
                                .font(.body)
                                .padding(10)
                                .frame(alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }
                    if selectedLeaveType != "Half" {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("To Date")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                DatePicker(
                                    "",
                                    selection: $toDate,
                                    in: fromDate...,
                                    displayedComponents: .date
                                )
                                .labelsHidden()
                                .onChange(of: toDate) { newValue in
                                    toDate = Calendar.current.startOfDay(for: newValue)
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Select Day Type")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(toDayType)
                                    .font(.body)
                                    .padding(10)
                                    .frame( alignment: .leading)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                
                            }
                        }
                    }
                }
                Group {
                    Text("Remarks")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextEditor(text: $remarks)
                        .frame(height: 100)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray4))
                        )
                }
                CustonButton(title: "SUBMIT", backgroundColor: .maroon) {
                    if !remarks.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        handleSubmit()
                    } else {
                        ToastManager.shared.show(message: "Remarks should not be empty")
                    }
                }
            }
            .padding()
            
        }
        .overlay(ToastView())
        .navigationTitle("LEAVE")
        .navigationBarTitleDisplayMode(.inline)
    }
    func handleSubmit() {
        if fromDayType == "Comp Off" || toDayType == "Comp Off" {
            offdayRequest()
        } else if fromDayType == "WFH" || toDayType == "WFH" {
            wfHRequest()
        } else if fromDayType == "Full" && toDayType == "Full" {
            fullDayLeaveRequest()
        } else {
            if fromDayType == "First Half" {
                selectedLeaveType = "first half"
            } else if fromDayType == "Second Half" {
                selectedLeaveType = "second half"
            } else {
                selectedLeaveType = "half"
            }
            HalfDayLeaveRequest()
        }
    }
    
    func offdayRequest() {
        let dict: [String: Any] = [
            "EmpCode": empCode,
            "from_date": formattedDate(fromDate),
            "to_date": formattedDate(toDate),
            "leave_res": remarks
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.dayOffRequest,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        showToast = true
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                            dismiss()
                        }
                    } else {
                        showToast = true
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                        }
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    func wfHRequest() {
        
        let dict: [String: Any] = [
            "EmpCode": empCode,
            "from_date": formattedDate(fromDate),
            "to_date": formattedDate(toDate),
            "leave_res": remarks
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.wfhomeRequest,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        showToast = true
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                            dismiss()
                        }
                    } else {
                        showToast = true
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                        }
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    func fullDayLeaveRequest() {
        let dict: [String: Any] = [
            "EmpCode": empCode,
            "leave_type": "full",
            "from_date": formattedDate(fromDate),
            "to_date": formattedDate(toDate),
            "day_type": "full",
            "leave_res": remarks
        ]
        
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.leaveRequest,
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showToast = false
                            dismiss()
                        }
                    } else {
                        showToast = true
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                        }
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func HalfDayLeaveRequest() {
        let dict: [String: Any] = [
            "EmpCode": empCode,
            "leave_type": "half",
            "from_date": formattedDate(fromDate),
            "to_date": formattedDate(toDate),
            "day_type": selectedLeaveType,
            "leave_res": remarks
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.leaveRequest,
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
                        print("Leave applied successfully.")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showToast = false
                            dismiss()
                        }
                    } else {
                        showToast = true
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                        }
                    }
                    
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
}

