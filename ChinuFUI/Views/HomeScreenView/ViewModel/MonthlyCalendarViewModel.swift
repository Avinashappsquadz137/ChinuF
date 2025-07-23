//
//  MonthlyCalendarViewModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 25/04/25.
//

import Foundation
import SwiftUI

class MonthlyCalendarViewModel: ObservableObject {
    @Published var epmDetails: [EpmDetails] = []
    @Published var selectedDay: Int?
    @Published var selectedFullDate: Date?
    @Published var selectedAttendance: EpmDetails?
    
    let calendar = Calendar.current
    
    func getMonthlyCalendar(for date: Date) {
        let currentMonth = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: date)
        
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        dict["month"] = "\(currentMonth)"
        dict["year"] = "\(currentYear)"
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.monthWiseDetailApi,
            method: .post,
            param: dict,
            model: MonthWiseEmpDetail.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if let data = model.data {
                        self.epmDetails = data
                        self.selectedDay = self.calendar.component(.day, from: date)
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
    
    func updateAttendance(for date: Date) {
        let day = calendar.component(.day, from: date)
        if let attendance = epmDetails.first(where: {
            calendar.component(.day, from: date) == $0.date
        }) {
            self.selectedAttendance = attendance
            print("In: \(attendance.inTime ?? "N/A")")
            print("Out: \(attendance.outTime ?? "N/A")")
        }
    }
    
    func getStatus(for date: Date) -> AttendanceStatus {
        let day = calendar.component(.day, from: date)
        
        if let entry = epmDetails.first(where: { $0.date == day }) {
            switch entry.status {
            case -1:
                return .weekend
            case 3:
                return .holiday
            case 2:
                return .absent
            case 0:
                return .present
            default:
                return .unknown
            }
        }
        return .weekend
    }
}
