//
//  RequestViewScreen.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 27/06/25.
//

import SwiftUI

struct RequestViewScreen: View {
    @State private var newBookings: [RequestBooking] = []
    @State private var searchText: String = ""
    @State private var navigate = false
    @State private var selectedBooking: RequestBooking?
    
    
    var filteredBookings: [RequestBooking] {
        if searchText.isEmpty {
            return newBookings
        } else {
            return newBookings.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
    
    var body: some View {
        VStack {
            if filteredBookings.isEmpty {
                EmptyStateView(imageName: "EmptyList", message: "No List found")
            } else {
                TextField("Search by Name...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredBookings, id: \.katha_booking_id) { newBookings in
                            NewBookingCellView(
                                config: NewBookingCellConfig(
                                    showAmount: false,
                                    showGST: false
                                ), onTap: {
                                    selectedBooking = newBookings
                                    navigate = true
                                }, name: newBookings.name, amount: newBookings.amount, gST: newBookings.gST, channelName: newBookings.channelName, venue: newBookings.venue, katha_date: newBookings.katha_date, katha_from_Date: newBookings.katha_from_Date, kathaTiming: newBookings.kathaTiming, slotTiming: newBookings.slotTiming, status: newBookings.status
                            )
                        }
                        NavigationLink(
                            destination: selectedBooking.map { AssignForPromationView(newBookings: $0) },
                            isActive: $navigate
                        ) {
                            EmptyView()
                        }.hidden()
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            RequestBookinglist()
        }
    }
    
    func RequestBookinglist() {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode()
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.requestBookingList,
            method: .post,
            param: params,
            model: RequestBookingModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.newBookings = model.data ?? []
                    ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
}
