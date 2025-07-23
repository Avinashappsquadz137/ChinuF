//
//  EnquiryFormView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 17/07/25.
//
import SwiftUI

struct EnquiryFormView: View {
  
    @Environment(\.dismiss) private var dismiss
    @State private var assignList: [AssignBookingDetail] = []
    @State private var selectedAssign: AssignBookingDetail? = nil
    @State private var showAssignList = false

    @State private var name = ""
    @State private var mobileNo = ""
    @State private var city = ""
    @State private var remarks = ""

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Text("For Enquiry")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                Group {
                    customTextField("Name", text: $name)
                    customTextField("Mobile No", text: $mobileNo, keyboard: .numberPad)
                    customTextField("City", text: $city)
                    customTextField("Remarks", text: $remarks)
                    Button {
                        if !assignList.isEmpty {
                            withAnimation {
                                showAssignList.toggle()
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedAssign?.name ?? "Assign To")
                                .foregroundColor(selectedAssign == nil ? .gray : .black)
                            Spacer()
                            Image(systemName: showAssignList ? "chevron.up" : "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                }
                CustonButton(title: "Submit", backgroundColor: .maroon) {
                    if name.isEmpty || mobileNo.isEmpty || city.isEmpty || remarks.isEmpty || selectedAssign == nil {
                        ToastManager.shared.show(message: "Please Fill All Fields Before Submitting.")
                    } else {
                        receptionEnquiryApi()
                    }
                }
                Spacer()
            }
            .padding()
            if showAssignList {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(assignList, id: \.id) { employee in
                            Text(employee.name ?? "")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .onTapGesture {
                                    selectedAssign = employee
                                    showAssignList = false
                                }
                                .border(Color.gray.opacity(0.2), width: 0.5)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                .frame(maxHeight: 250)
            }
                
        }
        .overlay(ToastView())
        .onAppear {
            selectAssignBookingAPI()
        }
        .background(Color(.systemGroupedBackground))
    }

    func customTextField(_ placeholder: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        TextField(placeholder, text: text)
            .keyboardType(keyboard)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }

    func receptionEnquiryApi() {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode(),
            "sales_person": selectedAssign?.id ?? "",
            "caller_name": name,
            "Remarks": remarks,
            "Location": city,
            "caller_mobile": mobileNo
        ]
        print(params)
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.bookingLeadAPI,
            method: .post,
            param: params,
            model: GetSuccessMessage.self
        ) { result in
            switch result {
            case .success(let model):
                ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                dismiss()
            case .failure(let error):
                ToastManager.shared.show(message: "Enter Correct ID")
                print("API Error: \(error)")
            }
        }
    }

    func selectAssignBookingAPI() {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode()
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.assignBookingDetail,
            method: .post,
            param: params,
            model: AssignBookingDetailModel.self
        ) { result in
            switch result {
            case .success(let model):
                assignList = model.data ?? []
                ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
            case .failure(let error):
                ToastManager.shared.show(message: "Enter Correct ID")
                print("API Error: \(error)")
            }
        }
    }
}
