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
    @State private var PImg: String = UserDefaultsManager.getProfileImage()
    @State private var name: String = UserDefaultsManager.getName().uppercased()
    @State private var empCode: String = UserDefaultsManager.getEmpCode()
    var imageName: String = "person.fill"
    var employeeName: String = "AVINASH GUPTA"
    var employeeCode: String = "SANS-00301"
    var employeeAttendance: String = "10:00 AM"
    let type: EmployeeCardType
    @State private var isImageFullScreen = false
    @State private var showAllListView = false
    @State private var showSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                if let imageUrl = URL(string: PImg), !PImg.isEmpty {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.green, lineWidth: 2))
                            .onTapGesture {
                                isImageFullScreen = true
                            }
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
                    .onTapGesture {
                        isImageFullScreen = true
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.green, lineWidth: 2))
                        .onTapGesture {
                            isImageFullScreen = true
                        }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(empCode)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    HStack {
                        switch type {
                        case .ellipsisShow:
                            HStack {
                                Text(employeeAttendance)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
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
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
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
        .fullScreenCover(isPresented: $isImageFullScreen) {
            FullScreenImageView(imageURL: PImg)
        }
    }
}
