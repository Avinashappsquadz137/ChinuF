//
//  MainLoginView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 08/07/25.
//

import SwiftUI

struct MainLoginView: View {
    
    var company: Company?
    @State private var mobile: String = ""
    @State private var digit1: String = ""
    @State private var digit2: String = ""
    @State private var digit3: String = ""
    @State private var digit4: String = ""
    @State private var showingLoginScreen = false
    @State private var showValidationError: Bool = false
    @State private var navigateToForgetPin = false
    @State private var showForgetAlert = false
    
    enum PinField {
        case digit1, digit2, digit3, digit4
    }
    
    @FocusState private var focusedField: PinField?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.white.ignoresSafeArea()
               
              
                VStack {
                    //Spacer()
                    Image(company?.CompanyId == 1 ? "chinuF_logo" : "TTM_Icon")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 130)
                                .padding(.top, 16)
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
                
//                Image(company?.CompanyId == 1 ? "chinuF_logo" : "TTM_Icon")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 130)
//                    .padding(.top, 16)
//                    .padding(.trailing, 16)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            
            }
        }
        
        .overlay(ToastView())
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
