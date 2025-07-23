//
//  ReportsViews.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 15/05/25.
//

import SwiftUI

enum ReportType: String, CaseIterable, Identifiable {
    case myReports = "My Reports"
    case allReports = "All Reports"
    
    var id: String { self.rawValue }
}

struct ReportsViews: View {
    @State private var selectedTab: ReportType = .myReports
    
    var body: some View {
        VStack {
            Picker("Select Report", selection: $selectedTab) {
                ForEach(ReportType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(10)
            switch selectedTab {
            case .myReports:
                MyReportsViews()
            case .allReports:
                AllReportsViews()
            }
        }
        .navigationTitle("Reports")
    }
}
