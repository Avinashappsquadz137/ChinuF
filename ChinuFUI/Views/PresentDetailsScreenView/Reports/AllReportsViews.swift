//
//  MyReportsViews.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 14/05/25.
//

import SwiftUI

struct MyReportsViews: View {
    
    @State private var reports: [MyReportsList] = []
    @State private var selectedReqNo: Int?
    @State private var showCancelAlert = false
    @State private var selectedLeaveType: String = ""
    @State private var reason: String = ""
    @State private var showReasonSheet = false
    
    var body: some View {
        VStack {
            if reports.isEmpty {
                EmptyStateView(imageName: "EmptyList", message: "No reports found")
            }else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(reports, id: \.sno) { report in
                            ReportCellView(
                                reqNo: report.sno ?? 0,
                                duration: getDuration(from: report.date1, to: report.date2),
                                dateRange: "\(report.date1 ?? "") to \(report.date2 ?? "")",
                                leaveStatus: report.status ?? "",
                                leaveType: report.leave_type ?? "",
                                onCancelLeave: {
                                    selectedReqNo = report.sno
                                    selectedLeaveType = report.leave_type ?? ""
                                    showReasonSheet = true
                                }
                                
                            )}
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            getMyReportsList()
        }
        .sheet(isPresented: $showReasonSheet) {
            NavigationView {
                VStack(spacing: 20) {
                    Group {
                        Text("Remarks")
                            .font(.subheadline)
                        
                        TextEditor(text: $reason)
                            .frame(height: 100)
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4))
                            )
                    }
                    HStack {
                        Button("Submit") {
                            if let reqNo = selectedReqNo {
                                cancelLeave(reqNo: reqNo, leaveType: selectedLeaveType, reason: reason)
                                showReasonSheet = false
                                reason = ""
                            }
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.maroon)
                        .cornerRadius(10)
                        
                        Button("Cancel") {
                            showReasonSheet = false
                            reason = ""
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }

                    Spacer()
                }
                .padding()
                .navigationTitle("Cancel Leave")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showReasonSheet = false
                            reason = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .presentationDetents([
                .height(UIScreen.main.bounds.height * 0.45),
                .large
            ])
        }
    }

    private func getDuration(from start: String?, to end: String?) -> String {
        guard let start = start, let end = end else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        if let startDate = formatter.date(from: start),
           let endDate = formatter.date(from: end) {
            let diff = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
            return "\(diff.day ?? 0 + 1) Days"
        }
        return "N/A"
    }

    private func getMyReportsList() {
        let dict: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode()
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getMyReportsListApi,
            method: .post,
            param: dict,
            model: GetMyReportsList.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        self.reports = model.data ?? []
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    private func cancelLeave(reqNo: Int, leaveType: String, reason: String) {
        let params: [String: Any] = [
            "RequestId": reqNo,
            "EmpCode": UserDefaultsManager.getEmpCode(),
            "leave_type": leaveType,
            "reason": reason
        ]

        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.myLeaveCancel,
            method: .post,
            param: params,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status == true {
                        ToastManager.shared.show(message: response.message ?? "Leave cancelled")
                        getMyReportsList()
                    } else {
                        ToastManager.shared.show(message: response.message ?? "Could not cancel")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Network error")
                    print("Cancel API Error: \(error)")
                }
            }
        }
    }

}



