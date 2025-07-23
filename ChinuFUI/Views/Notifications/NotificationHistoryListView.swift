//
//  NotificationHistoryListView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 01/07/25.
//

import SwiftUI

struct NotificationHistoryListView: View {
    @EnvironmentObject var notificationHandler: NotificationHandler
    @State private var notifications: [PushHistory] = []
    @State private var searchText = ""
    @State private var selectedItem: PushHistory?
    @State private var showGuestPopup = false
    @State private var showDeleteAllAlert = false

    var filteredNotifications: [PushHistory] {
        searchText.isEmpty
        ? notifications
        : notifications.filter {
            $0.notification_title?.localizedCaseInsensitiveContains(searchText) == true ||
            $0.notification_content?.localizedCaseInsensitiveContains(searchText) == true
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                SearchBars(text: $searchText)
                if filteredNotifications.isEmpty {
                    EmptyStateView(imageName: "EmptyList", message: "No Notifications found")
                } else {
                List(filteredNotifications, id: \.id) { item in
                    NotificationRowView(item: item)
                        .onTapGesture {
                            if item.notification_type == "8" || item.notification_type == "9" {
                                selectedItem = item
                                showGuestPopup = true
                            } else if item.notification_type == "14"{
                                
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                deleteNotification(item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                approveNotification(item)
                            } label: {
                                Label("Approve", systemImage: "checkmark")
                            }
                            .tint(.blue)
                        }
                }
                .listStyle(.plain)
            }
        }
            
            // Guest Popup Overlay
            if showGuestPopup, let item = selectedItem {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                GuestArrivalAlert(
                    img : item.notification_thumbnail ?? "",
                    guestName: item.notification_content ?? "Guest",
                    onAccept: { location in
                        showGuestPopup = false
                    },
                    onReject: {_ in
                        showGuestPopup = false
                    },
                    onClose: {
                        showGuestPopup = false
                    },
                    reqID: item.req_id ?? 0
                )
                .padding()
                .zIndex(1)
                .transition(.scale)
            }
            
            if notificationHandler.showGuestPopup, let item = notificationHandler.selectedPushData {
                GuestArrivalAlert(
                    img : item.notification_thumbnail ?? "",
                    guestName: item.notification_content ?? "Guest",
                    onAccept: { location in
                        notificationHandler.showGuestPopup = false
                    },
                    onReject: {_ in
                        notificationHandler.showGuestPopup = false
                    },
                    onClose: {
                        notificationHandler.showGuestPopup = false
                    },
                    reqID: item.req_id ?? 0
                )
                .padding()
                .zIndex(1)
                .transition(.scale)
            }
        }
        .animation(.easeInOut, value: showGuestPopup)
        .navigationTitle("Notification History")
        .onAppear {
            pushHistoryAPI()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showDeleteAllAlert = true
                }) {
                    Image(systemName: "trash.circle")
                        .font(.title2)
                }
            }
        }
        .alert(isPresented: $showDeleteAllAlert) {
            Alert(
                title: Text("Delete All Notifications"),
                message: Text("Are you sure you want to delete all notifications?"),
                primaryButton: .destructive(Text("Delete")) {
                    notifications.removeAll()
                    removePushHistoryAPI()
                },
                secondaryButton: .cancel()
            )
        }

    }
    func deleteNotification(_ item: PushHistory) {
        notifications.removeAll { $0.id == item.id }
        if selectedItem?.notification_type == "9" {
            empGuestActionAPI(id: "\(selectedItem?.req_id ?? 0)",status: "2",reason: "Not Available")
        }
    }
    
    func approveNotification(_ item: PushHistory) {
        if let index = notifications.firstIndex(where: { $0.id == item.id }) {
            notifications[index].status = true
        }
        if selectedItem?.notification_type == "9" {
            empGuestActionAPI(id: "\(selectedItem?.req_id ?? 0)" ,status: "1",selectid: "1")
        }
    }
    
    func pushHistoryAPI () {
        var dict = [String: Any]()
        dict["EmpCode"] = UserDefaultsManager.getEmpCode()
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.pushHistoryList,
            method: .post,
            param: dict,
            model: NotificationPushHistory.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.notifications = model.data ?? []
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    func removePushHistoryAPI() {
        var dict = [String: Any]()
        dict["EmpCode"] = UserDefaultsManager.getEmpCode()
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.removePushHistory,
            method: .post,
            param: dict,
            model: NotificationPushHistory.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.notifications = model.data ?? []
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    func empGuestActionAPI(id: String,status: String,selectid: String? = nil,reason: String? = nil) {
        var dict = [String: Any]()
        dict["id"] = id
        dict["status"] = status
        dict["floor"] = selectid
        dict["reason"] = reason

        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.empGuestAction,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    ToastManager.shared.show(message: model.message ?? "Thank You")
                case .failure(let error):
                    ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                    print("API Error: \(error)")
                }
            }
        }
    }
}


struct NotificationRowView: View {
    let item: PushHistory
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let imageURL = item.notification_thumbnail,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.notification_title ?? "No Title")
                    .font(.headline)
                
                Text(item.notification_content ?? "No Description")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            if item.status == true {
                Circle()
                    .fill(Color.green)
                    .frame(width: 12, height: 12)
                    .padding(.top, 6)
            } else {
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .padding(.top, 6)
            }
            
            
        }
        .padding(.vertical, 8)
    }
}

struct GuestArrivalAlert: View {
    var img: String
    var guestName: String
    var onAccept: (String) -> Void
    var onReject: (String) -> Void
    var onClose: () -> Void
    var reqID: Int
    @State private var locationText = ""
    @State private var selectedFloor = ""
    @State private var rejectionReason = ""
    
    @State private var showFloorSheet = false
    @State private var showReasonSheet = false
    @State private var hiderejectBtn = false
    
    
    @State private var floors: [Datum] = []
    @State private var selectedFloorId: String = ""
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    onClose()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                }
            }
            .padding(.trailing)
            
            VStack(spacing: 16) {
                if let url = URL(string: img) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill.badge.plus")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                }
                Text("\(guestName) has arrived")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                if showReasonSheet == true {
                    HStack(alignment: .center, spacing: 5){
                        TextField("Enter Reason", text: $locationText)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        Button(action: {
                            empGuestActionAPI(id: String(reqID), status: "2", reason: "\(locationText)")
                           
                        }) {
                            Image(systemName: "paperplane.circle")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .foregroundColor(.blue)
                                .background(Color.white)
                        }
                    }
                }
                HStack(spacing: 20 ) {
                    if showReasonSheet == true {
                        Button("Cancel") {
                            onClose()
                        }
                        .filledButtonStyle(backgroundColor: .gray)
                    } else {
                        Button("Accept") {
                            showFloorSheet = true
                            
                        }
                        .filledButtonStyle(backgroundColor: .green)
                    }
                    if hiderejectBtn == false {
                        Button("Reject") {
                            showReasonSheet = true
                            hiderejectBtn = true
                        }
                        .filledButtonStyle(backgroundColor: .red)
                    }
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
        .confirmationDialog("Select Floor", isPresented: $showFloorSheet) {
            ForEach(floors, id: \.id) { floor in
                Button(floor.name) {
                    selectedFloorId = floor.id
                    onAccept("\(locationText) - Floor ID: \(floor.id)")
                    empGuestActionAPI(id: String(reqID), status: "1", selectid: "\(floor.id)")
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .overlay(ToastView())
        .onAppear {
            guestFloorAPI()
        }
    }

    func guestFloorAPI () {
        var dict = [String: Any]()
        dict["EmpCode"] = UserDefaultsManager.getEmpCode()
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.guestFloor,
            method: .post,
            param: dict,
            model: GetFloorList.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.floors = model.data
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    func empGuestActionAPI(id: String,status: String,selectid: String? = nil,reason: String? = nil) {
        var dict = [String: Any]()
        dict["id"] = id
        dict["status"] = status
        dict["floor"] = selectid
        dict["reason"] = reason

        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.empGuestAction,
            method: .post,
            param: dict,
            model: GetSuccessMessage.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    onClose()
                    ToastManager.shared.show(message: model.message ?? "Thank You")
                case .failure(let error):
                    ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                    print("API Error: \(error)")
                }
            }
        }
    }
}

