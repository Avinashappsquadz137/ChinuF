//
//  calenderHelper.swift
//  SanskarEP
//
//  Created by Surya on 22/07/24.
//

import Foundation
import UIKit


class calenderHelper
{
  
    
    func plusmonth(date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusmonth(date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func monthString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL"
        return dateFormatter.string(from: date)
    }
    
    func monthString1(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: date)
    }
    
    func YearString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: date)
    }
    
    func daysInMonth(date: Date) -> Int {
           let calendar = Calendar.current
           let range = calendar.range(of: .day, in: .month, for: date)
           return range?.count ?? 0
       }
    
    func dayOfMonth(date: Date) -> Int
    {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.day], from: date)
        return component.day!
    }
    
    func firstOfMonth(date: Date) -> Date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month], from: date)
            return calendar.date(from: components) ?? Date()
        }
    
    func weekDay(date: Date) -> Int {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.weekday], from: date)
            return components.weekday ?? 0
        }
}
