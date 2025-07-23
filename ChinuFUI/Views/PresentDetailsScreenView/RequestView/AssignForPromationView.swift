//
//  AssignForPromationView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 27/06/25.
//

import SwiftUI

struct AssignForPromationView: View {
    let newBookings: RequestBooking?
    @State private var bookingPromo: [BookingPromo] = []
    @State private var remarkText = ""
    @State private var selectedPromoIds: Set<Int> = []
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                bookingHeaderView
                Divider()
                promoListView
                Divider()
                remarkSectionView
                Spacer()
            }
            .overlay(ToastView())
        }
        .onAppear { getDataPromoAssignlist() }
        .navigationTitle("Assign For Promotion")
    }
    var bookingHeaderView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(newBookings?.name?.uppercased() ?? "N/A")")
                .font(.title3).fontWeight(.semibold)
            Text("Channel: \(newBookings?.channelName ?? "N/A")").font(.caption)
            Text("Venue: \(newBookings?.venue ?? "N/A")").font(.caption)
            Text("Date: \(newBookings?.katha_date ?? newBookings?.katha_from_Date ?? "N/A")").font(.caption)
            Text("Time: \(newBookings?.kathaTiming ?? newBookings?.slotTiming ?? "N/A")").font(.caption)
        }
        .padding(10)
    }
    var promoListView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select Promo Type")
                .font(.headline)
                .padding(.horizontal)

            ForEach(bookingPromo, id: \.id) { promo in
                HStack {
                    Button(action: {
                        toggleSelection(for: promo.id)
                    }) {
                        Image(systemName: selectedPromoIds.contains(promo.id ?? -1) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(selectedPromoIds.contains(promo.id ?? -1) ? .green : .gray)
                    }

                    Text(promo.type_name ?? "N/A")
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
            }
        }
    }
    private func toggleSelection(for id: Int?) {
        guard let id = id else { return }
        if selectedPromoIds.contains(id) {
            selectedPromoIds.remove(id)
        } else {
            selectedPromoIds.insert(id)
        }
    }


    var remarkSectionView: some View {
        VStack(alignment: .leading) {
            Text("Remarks")
                .font(.headline)
            
            TextEditor(text: $remarkText)
                .frame(height: 100)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4))
                )
            
            CustonButton(title: "Submit", backgroundColor: .maroon) {
                bookingPromoType()
            }
        }
        
        .padding()
    }
    
    
    func getDataPromoAssignlist() {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode()
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getDataPromoAssign,
            method: .post,
            param: params,
            model: BookingPromoModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    bookingPromo = model.data ?? []
                    ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func bookingPromoType() {
        let promoTypeString = selectedPromoIds.map { String($0) }.joined(separator: ",")
        
        guard !promoTypeString.isEmpty,
              let kathaId = newBookings?.katha_booking_id else {
            ToastManager.shared.show(message: "Please select a promo type.")
            return
        }
        
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode(),
            "assign_to": "",
            "promo_type": promoTypeString,
            "katha_id": kathaId,
            "remarks" : remarkText
        ]
        
//        ApiClient.shared.callmethodMultipart(
//            apiendpoint: Constant.bookingPromoType,
//            method: .post,
//            param: params,
//            model: BookingPromoModel.self
//        ) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let model):
//                    ToastManager.shared.show(message: model.message ?? "Submitted Successfully")
//                    dismiss()
//                case .failure(let error):
//                    ToastManager.shared.show(message: "Submission Failed")
//                    print("API Error: \(error)")
//                }
//            }
//        }
    }
}
