//
//  MyReportsViews.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 14/05/25.
//EmployeeReportsModel
import SwiftUI

struct AllReportsViews: View {
    
    // MARK: - State Properties
    @State private var employees: [EmployeeReports] = []
    @State private var searchText: String = ""
    
    // MARK: - Filtered List
    private var filteredEmployees: [EmployeeReports] {
        if searchText.isEmpty {
            return employees
        } else {
            return employees.filter {
                ($0.name ?? "").localizedCaseInsensitiveContains(searchText) ||
                ($0.empCode ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    var body: some View {
        VStack {
            if filteredEmployees.isEmpty {
                EmptyStateView(imageName: "EmptyList", message: "No Reports found")
            } else {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search by Name or ID", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .overlay(
                            HStack {
                                Spacer()
                                if !searchText.isEmpty {
                                    Button(action: {
                                        searchText = ""
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 8)
                                }
                            }
                        )
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredEmployees.indices, id: \.self) { index in
                            let employee = employees[index]
                            EmployeeCellView(
                                name: employee.name ?? "N/A",
                                empCode: employee.empCode ?? "N/A",
                                department: employee.dept ?? "N/A",
                                imageUrl: employee.empImage ?? ""
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            employeeLeaveApi()
        }
    }
    //AttendanceGridView(detail: detail)
    private func employeeLeaveApi() {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode(),
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.employeeLeaveListApi,
            method: .post,
            param: params,
            model: EmployeeReportsModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status == true {
                        self.employees = response.data ?? []
                    }
                    ToastManager.shared.show(message: response.message ?? "Response received")
                case .failure(let error):
                    ToastManager.shared.show(message: "Network error")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
}

