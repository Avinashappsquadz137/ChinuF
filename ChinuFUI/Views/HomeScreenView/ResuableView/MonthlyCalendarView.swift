//
//  MonthlyCalendarView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 25/04/25.
//
import SwiftUI

struct CalendarDay: Identifiable, Hashable {
    let id = UUID()
    let date: Date?
    let status: AttendanceStatus?
}

enum AttendanceStatus {
    case present
    case absent
    case weekend
    case holiday
    case unknown
}

struct MonthlyCalendarView: View {
    @Binding var selectedDate: Date
    @Binding var selectedAttendance: EpmDetails?
    @Binding var selectedDayOnly: String
    
    @StateObject private var viewModel = MonthlyCalendarViewModel()
    
    private let calendar = Calendar.current

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(monthYearFormatter.string(from: selectedDate))
                    .font(.title2).bold()
                Spacer()
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)

            let weekdays = calendar.shortWeekdaySymbols
            HStack {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }
            }

            let days = generateCalendarDays()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                    //let isSelected = day.date != nil && calendar.isDate(day.date!, inSameDayAs: viewModel.selectedFullDate ?? Date.distantPast)
                    let isSelected = day.date != nil && calendar.isDate(day.date!, inSameDayAs: viewModel.selectedFullDate ?? Date())

                    let isToday = day.date != nil && calendar.isDateInToday(day.date!)
                    let dayText = day.date != nil ? dayFormatter.string(from: day.date!) : ""

                    Text(dayText)
                        .frame(maxWidth: .infinity, minHeight: 35)
                        .background(
                            index % 7 == 0
                            ? Color.orange
                            : isSelected
                            ? Color.blue
                            : isToday
                            ? Color.gray
                            : circleColor(for: day.status)
                        )
                        .foregroundColor(
                            index % 7 == 0 || isSelected || isToday ? .white : .primary
                        )
                        .clipShape(Circle())
                        .onTapGesture {
                            if let tappedDate = day.date {
                                var components = calendar.dateComponents([.year, .month], from: selectedDate)
                                components.day = calendar.component(.day, from: tappedDate)
                                if let correctDate = calendar.date(from: components) {
                                    let formattedDate = dateFormatter.string(from: correctDate)
                                    
                                    viewModel.selectedDay = calendar.component(.day, from: correctDate)
                                    viewModel.selectedFullDate = correctDate
                                    viewModel.updateAttendance(for: correctDate)
                                    selectedAttendance = viewModel.selectedAttendance
                                    selectedDayOnly = formattedDate
                                }
                            }

                        }
                }

            }
        }
        .onAppear {
            viewModel.getMonthlyCalendar(for: selectedDate)
        }
        .padding()
        .background(Color.pink.opacity(0.1))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        .padding(.horizontal)
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
            viewModel.getMonthlyCalendar(for: newDate)
        }
    }

    private func generateCalendarDays() -> [CalendarDay] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return []
        }
        guard let dayRange = calendar.range(of: .day, in: .month, for: selectedDate) else {
            return []
        }
        let offset = (firstWeekday - calendar.firstWeekday + 7) % 7
        var days: [CalendarDay] = Array(repeating: CalendarDay(date: nil, status: nil), count: offset)
        for day in dayRange {
            if let rawDate = calendar.date(bySetting: .day, value: day, of: selectedDate) {
                let date = calendar.startOfDay(for: rawDate)
                let status = viewModel.getStatus(for: date)
                days.append(CalendarDay(date: date, status: status))
            }
        }
        return days
    }

    private func circleColor(for status: AttendanceStatus?) -> Color {
        switch status {
        case .present: return .green
        case .absent: return .red
        case .weekend: return .orange
        case .holiday: return .yellow
        case .unknown, nil: return .clear
        }
    }

}

