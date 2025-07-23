//
//  BookReceptionScreen.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 17/07/25.
//
import SwiftUI

struct BookReceptionScreen: View {
    @State private var bookings: [BookReception] = []
    @State private var searchQuery: String = ""
    @State private var isShowingEnquiryForm = false
    
    var filteredBookings: [BookReception] {
        if searchQuery.isEmpty {
            return bookings
        } else {
            return bookings.filter {
                ($0.caller_name ?? "").localizedCaseInsensitiveContains(searchQuery) ||
                ($0.caller_mobile ?? "").contains(searchQuery) ||
                ($0.location ?? "").localizedCaseInsensitiveContains(searchQuery) ||
                ($0.sales_person_name ?? "").localizedCaseInsensitiveContains(searchQuery) ||
                ($0.remarks ?? "").localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                onSearch: { query in
                    self.searchQuery = query
                },
                onAddListToggle: {  self.isShowingEnquiryForm = true },
                isListMode: false
            )
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredBookings, id: \.booking_id) { booking in
                        BookingCardView(booking: booking)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            getApproveKathalist()
        }
        .sheet(isPresented: $isShowingEnquiryForm) {
            EnquiryFormView()
        }
    }
    
    func getApproveKathalist() {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode(),
            "category_id": "2"
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getApproveKathalist,
            method: .post,
            param: params,
            model: BookReceptionModel.self
        ) { result in
            switch result {
            case .success(let model):
                self.bookings = model.data ?? []
                ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
            case .failure(let error):
                ToastManager.shared.show(message: "Enter Correct ID")
                print("API Error: \(error)")
            }
        }
    }
}

struct BookingCardView: View {
    let booking: BookReception
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Name").fontWeight(.bold)
                Text(booking.caller_name ?? "")
            }
            HStack {
                Text("Contact No").fontWeight(.bold)
                Image(systemName: "phone.fill").foregroundColor(.green)
                Text(booking.caller_mobile ?? "")
            }
            HStack {
                Text("City").fontWeight(.bold)
                Text(booking.location ?? "")
            }
            HStack {
                Text("Assign").fontWeight(.bold)
                Text(booking.sales_person_name ?? "")
            }
            HStack {
                Text("Remarks").fontWeight(.bold)
                Text(booking.remarks ?? "")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onTapGesture {
            makePhoneCall()
        }
    }
    private func makePhoneCall() {
        guard let phoneNumber = booking.caller_mobile,
              let url = URL(string: "tel://\(phoneNumber)"),
              UIApplication.shared.canOpenURL(url) else {
            print("Invalid phone number or device doesn't support calling.")
            return
        }
        UIApplication.shared.open(url)
    }
}
