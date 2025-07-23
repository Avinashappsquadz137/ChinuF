//
//  GuestRecordHistory.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 06/05/25.
//
import SwiftUI

struct GuestRecordHistory: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var guestHistory: [GuestHistory] = []
    @State private var isLoading = false
    @State private var showSheet = false
    @State private var showFilterSheet = false
    @State private var addNewGuestSheet = false
    @State private var selectedGuest: GuestHistory? = nil
    @State private var startDate: String = ""
    @State private var endDate: String = ""
    @State private var searchText: String = ""
    @State private var isImageFullScreen = false
    @State private var startDateRaw: Date = Date()
    @State private var endDateRaw: Date = Date()
    @State private var fullScreenImageURL: String? = nil

    var filteredGuestHistory: [GuestHistory] {
        if searchText.isEmpty {
            return guestHistory
        } else {
            return guestHistory.filter {
                ($0.name ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {                          
                CustomNavigationBar(
                    onFilter: { showFilterSheet.toggle()  },
                    onSearch: {  query in
                        self.searchText = query },
                    onAddListToggle: { addNewGuestSheet.toggle() },
                    isListMode: true
                )
                Spacer()
                if guestHistory.isEmpty {
                    EmptyStateView(imageName: "EmptyList", message: "No Notifications found")
                } else {
                    List(filteredGuestHistory, id: \.id) { guest in
                        HStack(alignment: .center, spacing: 12) {
                            if let imageUrl = guest.image, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.green, lineWidth: 2))
                                .onTapGesture {
                                    fullScreenImageURL = guest.image
                                    isImageFullScreen = true
                                }
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Name: \(guest.name ?? "")")
                                    .font(.system(size: 17, weight: .semibold))
                                Text("Date: \(guest.guest_date ?? "")")
                                    .font(.system(size: 14))
                                Text("Mobile: \(guest.mobile ?? "")")
                                    .font(.system(size: 14))
                                Text("Address: \(guest.address ?? "")")
                                    .font(.system(size: 14))
                                Text("Reason: \(guest.reason ?? "")")
                                    .font(.system(size: 14))
                                Text("In-Time: \(guest.in_time ?? "")")
                                    .font(.system(size: 14))
                                Text("Out-Time: \(guest.out_time ?? "")")
                                    .font(.system(size: 14))
                            }
                            Spacer()
                            
                            Image(systemName: "pencil")
                                .font(.title)
                                .foregroundColor(.black)
                                .onTapGesture {
                                    selectedGuest = guest
                                    showSheet.toggle()
                                }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .listStyle(PlainListStyle())
                    
                }
            }
        }
        .fullScreenCover(isPresented: $isImageFullScreen) {
            FullScreenImageView(imageURL: fullScreenImageURL)
        }
        .navigationTitle("Guest History")
        .onAppear {
            GuestHistoryApi()
        }
        .sheet(isPresented: $showSheet) {
            if let selectedGuest = selectedGuest {
                NavigationStack {
                    GeometryReader { geometry in
                        VStack {
                            EditGuestView(guest: selectedGuest)
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
            } else {
                Text("No guest selected") 
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Filter by Date")
                        .font(.headline)
                    
                    DatePicker("Start Date", selection: $startDateRaw, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.horizontal)
                    
                    DatePicker("End Date", selection: $endDateRaw, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.horizontal)
                    
                    CustonButton(
                        title: "Submit",
                        backgroundColor: .maroon
                    ) {
                        startDate = dateFormatter.string(from: startDateRaw)
                        endDate = dateFormatter.string(from: endDateRaw)
                        showFilterSheet = false
                        GuestHistoryApi()
                    }
                }
                .padding()
                .presentationDetents([.height(300)])
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showFilterSheet = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $addNewGuestSheet) {
            NavigationStack {
                GeometryReader { geometry in
                    VStack {
                        AddNewGuestView()
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action: {
                                        addNewGuestSheet.toggle()
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.black)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .navigationTitle("Add New Guest")
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
        .onChange(of: addNewGuestSheet) { newValue in
            if !newValue {
                GuestHistoryApi()
            }
        }
    }
    
    func GuestHistoryApi() {
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        if !startDate.isEmpty {
            dict["fromDate"] = startDate
        }
        
        if !endDate.isEmpty {
            dict["toDate"] = endDate
        }
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.guestRecordHistoryApi,
            method: .post,
            param: dict,
            model: GuestHistoryModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.guestHistory = data
                        ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                        print("Fetched items: \(data)")
                    } else {
                        print("No data received")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
}
