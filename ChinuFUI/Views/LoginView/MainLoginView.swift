//
//  MainLoginView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 08/07/25.
//

import SwiftUI

struct CompanyModel: Codable {
    let status: Bool
    let message: String
    let data: [Company]
}

struct Company: Codable, Identifiable {
    let id = UUID()
    let CompanyId: Int
    let CompanyName: String
}

struct MainLoginView: View {
    
    @State private var mobile: String = "9627945758"
    @State private var digit1: String = ""
    @State private var digit2: String = ""
    @State private var digit3: String = ""
    @State private var digit4: String = ""
    @State private var showingLoginScreen = false
    @State private var showValidationError: Bool = false
    @State private var navigateToForgetPin = false
    @State private var showForgetAlert = false
    @State private var companyList: [Company] = []
    @State private var selectedCompany: Company? = nil
    @State private var showDropdown = false
    
    enum PinField {
        case digit1, digit2, digit3, digit4
    }
    
    @FocusState private var focusedField: PinField?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Color.white.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    HStack {
                        Text("Employee")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("Portal")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.maroon)
                        
                    }
                    VStack(spacing: 4) {
                        Button {
                            withAnimation {
                                showDropdown.toggle()
                            }
                        } label: {
                            HStack {
                                Text(selectedCompany?.CompanyName ?? "Select Company")
                                    .foregroundColor(selectedCompany == nil ? .gray : .black)

                                Spacer()

                                Image(systemName: "chevron.down")
                                    .rotationEffect(.degrees(showDropdown ? 180 : 0))
                            }
                            .padding()
                            .frame(height: 50)
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 24)
                    }
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            TextField("Enter Your Mobile No", text: $mobile)
                                .keyboardType(.numberPad)
                                .font(.subheadline)
                                .padding(12)
                                .frame(height: 50)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                                .padding(.horizontal, 24)
                                .onChange(of: mobile) { newValue in
                                    mobile = String(newValue.prefix(10).filter { $0.isNumber })
                                    showValidationError = (mobile.count != 10 && !mobile.isEmpty)
                                }
                            
                            if showValidationError {
                                Text("Mobile number must be 10 digits.")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.horizontal, 24)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        HStack(spacing: 12) {
                            otpTextField(text: $digit1, next: .digit2, prev: nil, tag: .digit1)
                            otpTextField(text: $digit2, next: .digit3, prev: .digit1, tag: .digit2)
                            otpTextField(text: $digit3, next: .digit4, prev: .digit2, tag: .digit3)
                            otpTextField(text: $digit4, next: nil, prev: .digit3, tag: .digit4)
                        }
                        .padding(.horizontal, 24)
                        CustonButton(title: "Login", backgroundColor: .maroon) {
                            hideKeyboard()
                            LoginApi()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        
                        NavigationLink(
                            destination: MainHomeView(),
                            isActive: $showingLoginScreen
                        ) {
                            EmptyView()
                        }
                    }
                    Button(action: {
                        hideKeyboard()
                        if mobile.count != 10 {
                            ToastManager.shared.show(message: "Please enter a valid 10-digit mobile number")
                        } else {
                            showForgetAlert = true
                        }
                    }) {
                        Text("Forget Pin ?")
                            .font(.system(size: 22, weight: .semibold))
                            .padding(.top)
                            .padding(.trailing, 28)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .alert("Are you sure you want to reset your password?", isPresented: $showForgetAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Yes", role: .destructive) {
                            navigateToForgetPin = true
                        }
                    }
                    NavigationLink(
                        destination: ForgetPassword(number: mobile),
                        isActive: $navigateToForgetPin
                    ) {
                        EmptyView()
                    }
                    Spacer()
                }
                if showDropdown {
                    VStack {
                        Spacer()
                            .frame(height: 180)
                        
                        VStack(spacing: 0) {
                            ForEach(companyList) { item in
                                Button {
                                    selectedCompany = item
                                    showDropdown = false
                                    saveSelectedCompany(item.CompanyId)
                                } label: {
                                    HStack {
                                        Text(item.CompanyName)
                                            .foregroundColor(.black)

                                        Spacer()

                                        if selectedCompany?.CompanyId == item.CompanyId {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.maroon)
                                        }
                                    }
                                    .padding()
                                }

                                Divider()
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 8)
                        .padding(.horizontal, 24)

                        Spacer()
                    }
                    .background(Color.black.opacity(0.1)
                        .onTapGesture {
                            showDropdown = false
                        }
                    )
                    .ignoresSafeArea()
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
                showDropdown = false
            }
        }
        .onAppear() {
            fetchCompanyList()
        }
        .overlay(ToastView())
    }
    
    func saveSelectedCompany(_ companyId: Int) {
        UserDefaults.standard.set(companyId, forKey: "SelectedCompanyId")
    }
    
    func fetchCompanyList() {
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getCompany,
            method: .get,
            param: [:],
            model: CompanyModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.companyList = model.data
                case .failure:
                    self.companyList = [
                        Company(CompanyId: 1, CompanyName: "ChinuFilms"),
                        Company(CompanyId: 2, CompanyName: "TotalMultiMedia")
                    ]
                }
            }
        }
    }
    // MARK: - OTP TextField
    func otpTextField(text: Binding<String>, next: PinField?, prev: PinField?, tag: PinField) -> some View {
        TextField("", text: text)
            .keyboardType(.numberPad)
            .frame(width: 80, height: 75)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .font(.title2)
            .multilineTextAlignment(.center)
            .focused($focusedField, equals: tag)
            .onChange(of: text.wrappedValue) { newValue in
                if newValue.count > 1 {
                    text.wrappedValue = String(newValue.prefix(1))
                }
                if newValue.count == 1 {
                    focusedField = next
                } else if newValue.isEmpty {
                    focusedField = prev
                }
            }
    }
    
    // MARK: - API Call
    func LoginApi() {
        let pin = digit1 + digit2 + digit3 + digit4
        guard let selectedCompany = selectedCompany else {
            ToastManager.shared.show(message: "Please select company")
            return
        }
        guard pin.count == 4 else {
            ToastManager.shared.show(message: "Please enter a valid 4-digit PIN")
            return
        }
        let dict: [String: Any] = [
            "CntNo": mobile,
            "pin": pin,
            "Device-Id": UserDefaultsManager.deviceId,
            "User-Type": UserDefaultsManager.getDeviceType(),
            "Device-Model": UserDefaultsManager.getSavedDeviceModel(),
            "device_token": UserDefaultsManager.getFCMToken()
        ]
        print(dict)
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getlogin,
            method: .post,
            param: dict,
            model: LoginModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        if let userData = model.data {
                            UserDefaultsManager.saveUserData(from: userData)
                            UserDefaultsManager.setLoggedIn(true)
                            UserDefaultsManager.setName(userData.name ?? "")
                            UserDefaultsManager.setEmpCode(userData.empCode ?? "")
                            ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                            showingLoginScreen = true
                        }
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "MobileNo and Pin doesn't Matched")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
}
