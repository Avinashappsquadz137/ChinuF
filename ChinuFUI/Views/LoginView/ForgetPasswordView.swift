//
//  ForgetPasswordView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 08/07/25.
//

import SwiftUI

struct ForgetPassword: View {
    var number : String = ""
    
    @State private var digit1: String = ""
    @State private var digit2: String = ""
    @State private var digit3: String = ""
    @State private var digit4: String = ""
    @State private var showSetPinPopup = false
    
    enum PinField {
        case digit1, digit2, digit3, digit4
    }
    
    @FocusState private var focusedField: PinField?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Spacer()
                        Image("ChinuFLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 130)
                            .padding(.top, 10)
                            .padding(.trailing, 16)
                    }
                    Text("Enter Your OTP")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 8)
                    Spacer().frame(height: 20)
                    HStack(spacing: 12) {
                        otpTextField(text: $digit1, next: .digit2, prev: nil, tag: .digit1)
                        otpTextField(text: $digit2, next: .digit3, prev: .digit1, tag: .digit2)
                        otpTextField(text: $digit3, next: .digit4, prev: .digit2, tag: .digit3)
                        otpTextField(text: $digit4, next: nil, prev: .digit3, tag: .digit4)
                    }
                    .padding(.horizontal, 24)
                    Button(action: {
                        hideKeyboard()
                        let enteredOTP = digit1 + digit2 + digit3 + digit4
                        verifyOTPApi(number: number, otp: enteredOTP)
                    }) {
                        Text("Verify OTP")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.maroon)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    HStack {
                        Text("Didn't receive the code?")
                            .foregroundColor(.black)
                            .bold()
                        
                        Button(action: {
                            sendOptApi(number: number)
                        }) {
                            Text("Resend")
                                .foregroundColor(.red)
                                .bold()
                        }
                    }
                    .padding(.top, 12)
                    
                    Spacer()
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .overlay(
                Group {
                    if showSetPinPopup {
                        
                        SetNewPinAlert(isPresented: $showSetPinPopup, onSubmit: { newPin in
                            setNewPinApi(number: number, pin: newPin)
                        })
                    }
                }
            )
        }
        .onAppear() {
            sendOptApi(number: number)
        }
    }
    
    // MARK: - OTP Field View
    func otpTextField(text: Binding<String>, next: PinField?, prev: PinField?, tag: PinField) -> some View {
        TextField("", text: text)
            .keyboardType(.numberPad)
            .frame(width: 70, height: 65)
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
    func MainLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) {
                window.rootViewController = UIHostingController(rootView: MainLoginView().environment(\.colorScheme, .light))
                window.makeKeyAndVisible()
            }
        }
    }
    func setNewPinApi(number: String ,pin : String) {
        let dict: [String: Any] = [
            "EmpCode" : UserDefaultsManager.getEmpCode(),
            "CntNo": number,
            "pin": pin
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.setNewPin,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        ToastManager.shared.show(message: model.message ?? "Set Password Successfully")
                        MainLogin()
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Set Password Issue")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Technology Issue")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func verifyOTPApi(number: String ,otp : String) {
        let dict: [String: Any] = [
            "CntNo": number,
            "otp": otp
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.verifyOTP,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        ToastManager.shared.show(message: model.message ?? "Verified Successfully")
                        digit1 = ""
                        digit2 = ""
                        digit3 = ""
                        digit4 = ""
                        showSetPinPopup = true
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Verification failed")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "OTP doesn't Matched")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func sendOptApi(number: String) {
        let dict: [String: Any] = [
            "CntNo": number,
            "Device-Id": UserDefaultsManager.deviceId,
            "User-Type": UserDefaultsManager.getDeviceType(),
            "Device-Model": UserDefaultsManager.getSavedDeviceModel(),
            "device_token": UserDefaultsManager.getFCMToken()
        ]
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
                        ToastManager.shared.show(message: model.message ?? "Verified Successfully")
                        if let userData = model.data {
                            UserDefaultsManager.setName(userData.name ?? "")
                            UserDefaultsManager.setEmailID(userData.emailID ?? "")
                            UserDefaultsManager.setContactNo(userData.cntNo ?? "")
                            UserDefaultsManager.setEmpCode(userData.empCode ?? "")
                        }
                        
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Verification failed")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "MobileNo and Pin doesn't Matched")
                    print("API Error: \(error)")
                }
            }
        }
    }
}

struct SetNewPinAlert: View {
    @Binding var isPresented: Bool
    @State private var digit1 = ""
    @State private var digit2 = ""
    @State private var digit3 = ""
    @State private var digit4 = ""
    
    @FocusState private var focusedField: PinField?
    var onSubmit: (String) -> Void
    
    enum PinField {
        case digit1, digit2, digit3, digit4
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Please Enter Four Digit Password")
                .font(.headline)
                .padding(.top)
            
            HStack(spacing: 10) {
                otpTextField(text: $digit1, next: .digit2, prev: nil, tag: .digit1)
                otpTextField(text: $digit2, next: .digit3, prev: .digit1, tag: .digit2)
                otpTextField(text: $digit3, next: .digit4, prev: .digit2, tag: .digit3)
                otpTextField(text: $digit4, next: nil, prev: .digit3, tag: .digit4)
            }
            CustonButton(title: "Submit", backgroundColor: .maroon) {
                let newPin = digit1 + digit2 + digit3 + digit4
                if newPin.count == 4 {
                    isPresented = false
                    onSubmit(newPin)
                } else {
                    ToastManager.shared.show(message: "Enter Password")
                }
            }
            
        }
        .padding()
        .background(Color.gray)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
    
    // MARK: - OTP Field View
   public func otpTextField(text: Binding<String>, next: PinField?, prev: PinField?, tag: PinField) -> some View {
        TextField("", text: text)
            .keyboardType(.numberPad)
            .frame(width: 70, height: 65)
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
}
