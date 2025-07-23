//
//  ApprovalView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 15/05/25.
//

import SwiftUI

struct ApprovalView: View {
    
    // MARK: - State Properties
    @State private var selectedSegment = 0
    
    var body: some View {
        VStack {
            Picker("Select Approval Type", selection: $selectedSegment) {
                Text("Leave").tag(0)
                Text("Booking").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            if selectedSegment == 0 {
                LeaveApprovalView()
            } else {
                BookingApprovalView()
            }
        }
    }
}



