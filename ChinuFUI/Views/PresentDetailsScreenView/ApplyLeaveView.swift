//
//  ApplyLeaveView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/04/25.
//

import SwiftUI

struct ApplyLeaveView: View {
    
    // MARK: - State Properties
    @State private var selectedLeaveType = ""
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var fromDayType = "Full Day"
    @State private var toDayType = "Full Day"
    @State private var remarks = ""
    @State private var name: String = UserDefaultsManager.getName()
    @State private var empCode: String = UserDefaultsManager.getEmpCode()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var showToast = false
    
    @State private var leaveTypes = ["Full Day", "First Half Day", "Second Half Day", "Off", "WFH"]
    
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Group {
                    Text("Employee")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(empCode) - \(name.uppercased())")
                        .font(.body)
                    
                    Text("Applied Date")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(formattedDate(Date()))
                        .font(.body)
                }
                Group {
                    Text("Select Leave Type")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Picker("Select Leave Type", selection: $selectedLeaveType) {
                        Text("Select Leave Type").tag("")
                        ForEach(leaveTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    .onChange(of: selectedLeaveType) { newValue in
                        switch newValue {
                        case "Full Day":
                            fromDayType = "Full Day"
                            toDayType = "Full Day"
                        case "First Half Day":
                            fromDayType = "First Half Day"
                            toDayType = "First Half Day"
                        case "Second Half Day":
                            fromDayType = "Second Half Day"
                            toDayType = "Second Half Day"
                        case "Off":
                            fromDayType = "Off"
                            toDayType = "Off"
                        case "WFH":
                            fromDayType = "WFH"
                            toDayType = "WFH"
                        default:
                            break
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
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
                            DatePicker("", selection: $fromDate, displayedComponents: .date)
                                .labelsHidden()
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
                    if !(selectedLeaveType == "First Half Day" || selectedLeaveType == "Second Half Day" || selectedLeaveType  == "Off") {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("To Date")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                DatePicker("", selection: $toDate, displayedComponents: .date)
                                    .labelsHidden()
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
        .overlay(showToast ? ToastView() : nil)
        .navigationTitle("LEAVE")
        .navigationBarTitleDisplayMode(.inline)
    }
    func handleSubmit() {
        if fromDayType == "Off" || toDayType == "Off" {
            offdayRequest()
        } else if fromDayType == "WFH" || toDayType == "WFH" {
            wfHRequest()
        } else if fromDayType == "Full Day" && toDayType == "Full Day" {
            fullDayLeaveRequest()
        } else {
            if fromDayType == "First Half Day" {
                selectedLeaveType = "first half"
            } else if fromDayType == "Second Half Day" {
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
            "leave_res": remarks
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.dayOffRequest,
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
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                            dismiss()
                        }
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
            model: SideBarApi.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        showToast = true
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                        print("Leave applied successfully.")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                            dismiss()
                        }
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
                        print("Leave applied successfully.")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                            dismiss()
                        }
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
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                            dismiss()
                        }
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

struct ApplyLeaveView_Previews: PreviewProvider {
    static var previews: some View {
        ApplyLeaveView()
    }
}
