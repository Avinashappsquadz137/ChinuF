//
//  UserProfileScreenView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 26/04/25.
//

import SwiftUI
import Alamofire

struct UserProfileScreenView: View {
    @State private var showLogoutAlert: Bool = false
    @State private var name: String = UserDefaultsManager.getName()
    @State private var empCode: String = UserDefaultsManager.getEmpCode()
    @State private var PImg: String = UserDefaultsManager.getProfileImage()
    @State private var fieldValues: [String: String] = [:]
    @State private var isImageFullScreen = false
    
    let data: [String: String] = [
        "Available PL"         : UserDefaultsManager.getPlBalance(),
        "Joining Date"         : UserDefaultsManager.getJoinDate(),
        "Designation"          : UserDefaultsManager.getDesignation(),
        "Department"           : UserDefaultsManager.getDepartment(),
        "Address"              : UserDefaultsManager.getAddress(),
        "Reporting Authority"  : UserDefaultsManager.getReportTo(),
        "Pan Number"           : UserDefaultsManager.getPanNo(),
        "Aadhar Number"        : UserDefaultsManager.getAadharNo(),
        "Blood Group"          : UserDefaultsManager.getBloodGroup()
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                EmployeeCard(
                    onProfileTapped: {
                        isImageFullScreen = true
                    },
                    showEditButton: true,
                    onEditTapped: nil,
                    imageName: "\(PImg)",
                    employeeName: name.uppercased(),
                    employeeCode: empCode,
                    employeeAttendance: Text("")
                )
                .padding(.horizontal, 10)
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(data.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(key)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                TextField("Enter \(key)", text: Binding(
                                    get: { fieldValues[key] ?? value },
                                    set: { fieldValues[key] = $0 }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                CustonButton(title: "Logout", backgroundColor: .maroon) { 
                    showLogoutAlert = true
                }
                .padding(.horizontal, 10)
            }
            .overlay(ToastView())
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Are you sure?"),
                    message: Text("Do you really want to log out?"),
                    primaryButton: .destructive(Text("Log Out")) {
                        LogoutApi()
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("User Profile")
            ImageFullScreenView(imageURL: PImg, isPresented: $isImageFullScreen)
        }
       
    }
    // MARK: - Logout API
    func LogoutApi() {
        let dict: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode()
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getlogout,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        ToastManager.shared.show(message: model.message ?? "Logout Device Successfully")
                        UserDefaultsManager.removeUserData()
                        logout()
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    // MARK: - Logout Action
    func logout() {
        UserDefaultsManager.setLoggedIn(false)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) {
                window.rootViewController = UIHostingController(rootView: SelectCompanyView().environment(\.colorScheme, .light))
                window.makeKeyAndVisible()
            }
        }
    }
}

