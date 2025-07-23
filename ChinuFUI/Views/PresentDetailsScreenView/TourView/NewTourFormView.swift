//
//  NewTourFormView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/06/25.
//

import SwiftUI

struct NewTourFormView: View {
    @State private var fromDate: String = ""
    @State private var toDate: String = ""
    @State private var location: String = ""
    @State private var requirement: String = ""
    @State private var remark: String = ""
    
    @State private var showFromDatePicker = false
    @State private var showToDatePicker = false
    @State private var selectedFromDate = Date()
    @State private var selectedToDate = Date()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 15) {
                        
                        dateField(title: "From Date", text: $fromDate, showPicker: $showFromDatePicker, isFromDate: true)
                        dateField(title: "To Date", text: $toDate, showPicker: $showToDatePicker, isFromDate: false)
                        
                        customTextField(title: "Location", text: $location)
                        customTextField(title: "Requirement", text: $requirement)
                        
                        // Remarks
                        TextEditor(text: $remark)
                            .frame(height: 100)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3))
                            )
                            .overlay(
                                Group {
                                    if remark.isEmpty {
                                        Text("Remark ...")
                                            .foregroundColor(.gray)
                                            .padding(.leading, 16)
                                            .padding(.top, 12)
                                    }
                                }, alignment: .topLeading
                            )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    CustonButton(title: "Submit", backgroundColor: .maroon) {
                        tourFormData()
                    } .padding(.horizontal)
                    Spacer()
                }
                
                .sheet(isPresented: $showFromDatePicker) {
                    VStack {
                        DatePicker("Select From Date", selection: $selectedFromDate, displayedComponents: [.date])
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                        Button("Done") {
                            fromDate = formattedDate(selectedFromDate)//dateFormatter.string(from: selectedFromDate)
                            showFromDatePicker = false
                        }
                        .padding()
                    }
                }
                .sheet(isPresented: $showToDatePicker) {
                    VStack {
                        DatePicker("Select To Date", selection: $selectedToDate, in: selectedFromDate..., displayedComponents: [.date])
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                        Button("Done") {
                            toDate = formattedDate(selectedToDate) //dateFormatter.string(from: selectedToDate)
                            showToDatePicker = false
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Tour Form")
    }

    // MARK: - Custom TextField
    
    func customTextField(title: String, text: Binding<String>) -> some View {
        TextField(title, text: text)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3))
            )
    }
    
    // MARK: - Date Field
    
    func dateField(title: String, text: Binding<String>, showPicker: Binding<Bool>, isFromDate: Bool) -> some View {
        HStack {
            TextField(title, text: text)
                .disabled(true)
                .padding(.leading)
            Spacer()
            Button(action: {
                showPicker.wrappedValue = true
            }) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 12)
                    .foregroundColor(.red)
            }
        }
        .frame(height: 50)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3))
        )
    }
    
    // MARK: - API Call
    
    func tourFormData() {
        let params: [String: Any] = [
            "EmpCode": "\(UserDefaultsManager.getEmpCode())",
            "Date1": fromDate,
            "Date2": toDate,
            "Requirement": requirement,
            "Remarks": remark,
            "Location": location
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.tourFormApi,
            method: .post,
            param: params,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    ToastManager.shared.show(message: model.message ?? "Successfully updated guest")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        dismiss()
                    }
                    print("Fetched items: \(model)")
                case .failure(let error):
                    ToastManager.shared.show(message: "Submission failed")
                    print("API Error: \(error)")
                }
            }
        }
    }
}
