//
//  PunchHistoryView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 01/05/25.
//

import SwiftUI

struct PunchHistoryView: View {
    
    @State private var attendanceData: [Attendance] = []
    @State private var startDate: Date = {
        let calendar = Calendar.current
        let now = Date()
        return calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
    }()
    @State private var endDate: Date = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Select Period Header
            HStack {
                Text("Select Period")
                    .font(.headline)
                
                Spacer()
                Menu {
                    Button("7 Days") { applyFilter(days: 7) }
                    Button("15 Days") { applyFilter(days: 15) }
                    Button("1 Month") { applyFilter(months: 1) }
                    Button("3 Months") { applyFilter(months: 3) }
                    Button("6 Months") { applyFilter(months: 6) }
                    Button("Custom") {
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            // Date Pickers
            HStack(spacing: 12) {
                DatePicker("", selection: $startDate, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke())
                
                DatePicker("", selection: $endDate, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke())
            }
            .padding(.horizontal)
            VStack{
                Button(action: {
                    punchHistoryAPI()
                }) {
                    Text("Search")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            // Table Header
            HStack(spacing: 5) {
                Text("Date")
                    .bold()
                    .frame(width: 50, alignment: .center)
                Text("In")
                    .bold()
                    .frame(width: 80, alignment: .center)
                Text("Out")
                    .bold()
                    .frame(width: 90, alignment: .center)
                Text("Location")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .background(Color.gray.opacity(0.8))
            .foregroundColor(.white)

            // Table Rows
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(attendanceData, id: \.date) { record in
                        HStack(spacing: 5) {
                            Text("\(record.date ?? 0)")
                                .frame(width: 50, alignment: .center)
                            Text(record.inTime ?? "-")
                                .frame(width: 70, alignment: .center)
                            Text(record.outTime ?? "-")
                                .frame(width: 70, alignment: .center)
                            Text("\(record.locationIn ?? "-"), \(record.locationOut ?? "-")")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(.horizontal)
                        Divider()
                    }
                }
            }
        }
        .padding(.top)
        .onAppear {
            punchHistoryAPI(isInitial: true)
        }
    }
    
    func applyFilter(days: Int? = nil, months: Int? = nil) {
        let calendar = Calendar.current
        let now = Date()
        var fromDate: Date?

        if let days = days {
            fromDate = calendar.date(byAdding: .day, value: -days + 1, to: now)
        } else if let months = months {
            fromDate = calendar.date(byAdding: .month, value: -months, to: now)
        }

        if let fromDate = fromDate {
            startDate = calendar.startOfDay(for: fromDate)
            endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now) ?? now
            punchHistoryAPI()
        }
    }
    func punchHistoryAPI(isInitial: Bool = false) {
        var dict = [String: Any]()
        let empCode = UserDefaultsManager.getEmpCode()
        dict["EmpCode"] = empCode
        
        let calendar = Calendar.current
        if isInitial {
            let currentYear = calendar.component(.year, from: Date())
            let currentMonth = calendar.component(.month, from: Date())
            dict["month"] = String(format: "%02d", currentMonth)
            dict["year"] = "\(currentYear)"
        } else {
            let startOfDay = calendar.startOfDay(for: startDate)
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate
            
            if startDate <= endDate {
                dict["from_date"] = String(Int(startOfDay.timeIntervalSince1970 * 1000))
                dict["to_date"] = String(Int(endOfDay.timeIntervalSince1970 * 1000))
                dict["month"] = "-1"
                dict["year"] = "\(calendar.component(.year, from: startDate))"
            } else {
                let currentYear = calendar.component(.year, from: Date())
                let currentMonth = calendar.component(.month, from: Date())
                dict["month"] = String(format: "%02d", currentMonth)
                dict["year"] = "\(currentYear)"
            }
        }
        
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getMonthWiseEmpDetail,
            method: .post,
            param: dict,
            model: PunchHistoryModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        attendanceData = data
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
