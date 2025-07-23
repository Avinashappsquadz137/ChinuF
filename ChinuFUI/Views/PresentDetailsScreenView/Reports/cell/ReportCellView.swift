//
//  ReportCellView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 14/05/25.
// 
import SwiftUI

struct ReportCellView: View {
    let reqNo: Int
    let duration: String
    let dateRange: String
    let leaveStatus: String
    let leaveType: String
    let onCancelLeave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Req No:")
                    .font(.footnote)
                Text("\(reqNo)")
                    .font(.footnote)
            }

            HStack {
                Text("Duration:")
                    .font(.footnote)
                Text(duration)
                    .font(.footnote)
            }

            HStack {
                Text("Date:")
                    .font(.footnote)
                Text(dateRange)
                    .font(.footnote)
            }

            HStack {
                Text("Status:")
                    .font(.footnote)
                Text(leaveStatus)
                    .font(.footnote)
            }

            HStack {
                Text("Leave Type:")
                    .font(.footnote)
                Text(leaveType)
                    .font(.footnote)

                Spacer()

                Button(action: onCancelLeave) {
                    Text("Cancel Leave")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .foregroundColor(.white)
                        .background(Color.maroon)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
