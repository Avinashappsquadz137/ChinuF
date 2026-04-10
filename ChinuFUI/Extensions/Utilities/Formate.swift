//
//  Formate.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 25/04/25.
//
import Foundation
import UIKit
import SwiftUI

var dayFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    return formatter
}

var monthYearFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.timeZone = TimeZone.current 
    return formatter
}()

 func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MMM-yyyy"
    return formatter.string(from: date)
}
extension Date {
    func toLocalTime() -> Date {
        let timeZone = TimeZone.current
        let seconds = TimeInterval(timeZone.secondsFromGMT(for: self))
        return addingTimeInterval(seconds)
    }
}
// MARK: - Dismiss Keyboard
func hideKeyboard() {
   UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                   to: nil, from: nil, for: nil)
}
extension UIImage {
    func resizeToWidth(_ width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        let height = self.size.height * scale
        let newSize = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
func isTodayBirthday(_ dateString: String) -> Bool {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    guard let birthDate = formatter.date(from: dateString) else {
        return false
    }
    let calendar = Calendar.current
    let today = Date()
    let birthComponents = calendar.dateComponents([.day, .month], from: birthDate)
    let todayComponents = calendar.dateComponents([.day, .month], from: today)
    return birthComponents.day == todayComponents.day &&
           birthComponents.month == todayComponents.month
}
func shouldShowConfettiToday() -> Bool {
    let key = "confetti_shown_date"
    let today = Date().formatted(date: .abbreviated, time: .omitted)
    
    let lastShown = UserDefaults.standard.string(forKey: key)
    
    if lastShown == today {
        return false // already shown today
    } else {
        UserDefaults.standard.set(today, forKey: key)
        return true
    }
}
func initials(from name: String?) -> String {
    guard let name = name else { return "" }
    let parts = name.split(separator: " ")
    let first = parts.first?.first.map { String($0) } ?? ""
    let last = parts.dropFirst().first?.first.map { String($0) } ?? ""
    return (first + last).uppercased()
}
extension Color {
    static var maroon: Color {
        let companyId = UserDefaults.standard.integer(forKey: "SelectedCompanyId")
        if companyId == 1 {
            return Color(red: 179 / 255, green: 39 / 255, blue: 32 / 255)
        } else {
            return Color(red: 0 / 255, green: 72 / 255, blue: 255 / 255)
        }
    }
}
