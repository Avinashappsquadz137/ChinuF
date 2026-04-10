//
//  EmployeeCard.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/04/25.
//
import SwiftUI

enum EmployeeCardType {
    case ellipsisShow
    case pencil
    case none
}

struct EmployeeCard: View {
    @StateObject private var homeMasterDetailVM = HomeMasterDetailViewModel()
    @State private var PImg: String = UserDefaultsManager.getProfileImage()
    @State private var name: String = UserDefaultsManager.getName().uppercased()
    @State private var empCode: String = UserDefaultsManager.getEmpCode()
    var imageName: String = "person.fill"
    var employeeName: String = "AVINASH GUPTA"
    var employeeCode: String = "SANS-00301"
   // var employeeAttendance: String = ""
    var employeeAttendance: Text

    let type: EmployeeCardType
    @State private var isImageFullScreen = false
    @State private var showAllListView = false
    @State private var showSheet = false
    let onProfileTapped: () -> Void
    let showEditButton: Bool
    let onEditTapped: (() -> Void)?

    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var selectedSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImageSourceActionSheet = false
    var isBirthday: Bool {
        guard let bday = homeMasterDetailVM.masterDetail?.BDay,
              !bday.isEmpty else {
            return false
        }
        return isTodayBirthday(bday)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                VStack(spacing: 2) {
                    ZStack(alignment: .bottomTrailing) {
                        if let imageUrl = URL(string: PImg), !PImg.isEmpty {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .overlay(
                                        Text(initials(from: name))
                                            .font(.system(size: 40))
                                            .bold()
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(1)
                                            .foregroundColor(.black)
                                            .padding(10)
                                    )
                                    .frame(width: 100, height: 100)
                            }
                            .frame(width: 100, height: 100)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                            .onTapGesture {
                                onProfileTapped()
                            }
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Text(initials(from: name))
                                        .font(.system(size: 40))
                                        .bold()
                                        .minimumScaleFactor(0.5)
                                        .lineLimit(1)
                                        .foregroundColor(.black)
                                        .padding(10)
                                )
                                .frame(width: 100, height: 100)
                                .onTapGesture {
                                    onProfileTapped()
                                }
                        }
                        // 🎂 Birthday Badge
                        if isBirthday {
                            BirthdayBadgeView()
                                .offset(x: 30, y: 15)
                        }
                    }
                    .frame(width: 100, height: 100)
                    if showEditButton {
                        Button(action: {
                            //onEditTapped?()
                            showImageSourceActionSheet = true
                        }) {
                            Text("Edit")
                                .foregroundColor(.blue)
                                .font(.subheadline)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(empCode)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    employeeAttendance
                        .font(.footnote)
                        .foregroundColor(.primary)
                    HStack {
                        switch type {
                        case .ellipsisShow:
                            HStack {
                                Spacer()
                                Image(systemName: "ellipsis.circle")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .onTapGesture {
                                        showSheet.toggle()
                                    }
                            }
                            
                        case .pencil:
                            HStack {
                                Spacer()
                                Image(systemName: "pencil")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                            
                        case .none:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        .sheet(isPresented: $showSheet) {
            NavigationStack {
                GeometryReader { geometry in
                    VStack {
                        AllListView()
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action: {
                                        showSheet.toggle()
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.black)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .presentationDetents([
                                .height(UIScreen.main.bounds.height * 0.65),
                                .large
                            ])
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.clear)
                    .cornerRadius(15)
                }
            }
        }
        .confirmationDialog("Choose Image Source", isPresented: $showImageSourceActionSheet, titleVisibility: .visible) {
            Button("Camera") {
                selectedSourceType = .camera
                isImagePickerPresented = true
            }
            Button("Gallery") {
                selectedSourceType = .photoLibrary
                isImagePickerPresented = true
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $isImagePickerPresented, onDismiss: loadImage) {
            ImagePicker(sourceType: selectedSourceType, selectedImage: $selectedImage)
        }

        .fullScreenCover(isPresented: $isImageFullScreen) {
            FullScreenImageView(imageURL: PImg)
        }
        .onAppear {
            homeMasterDetailVM.getMasterDetail()
        }
    }

    func loadImage() {
           guard let selectedImage = selectedImage else { return }
           uploadProfileImage(image: selectedImage)
       }

        func uploadProfileImage(image: UIImage) {
            var dict = [String: Any]()
            dict["EmpCode"] = empCode
            var imagesData: [String: Data] = [:]
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                imagesData["image"] = imageData
            }
            
            ApiClient.shared.callHttpMethod(
                apiendpoint: Constant.changeProfile,
                method: .post,
                param: dict,
                model: UpdateProfileResponse.self,
                isMultipart: true,
                images: imagesData,
                baseUrl: Constant.EP_BASEURL
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            ToastManager.shared.show(message: "📤 Waiting for Approval By HR")
                        }
                    case .failure(let error):
                        ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                        print("Error booking katha:", error)
                    }
                }
            }
        }
}
