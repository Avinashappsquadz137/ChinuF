//
//  MainHomeView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/04/25.
//


//import SwiftUI
//
//struct MainHomeView: View {
//    
//    @State private var selectedDate = Date()
//    @State private var selectedAttendance: EpmDetails? = nil
//    @State private var selectedDayOnly: String = ""
//    @State private var name: String = UserDefaultsManager.getName()
//    @State private var empCode: String = UserDefaultsManager.getEmpCode()
//    @State private var PImg: String = UserDefaultsManager.getProfileImage()
//    @State private var companyID: Int = 0
//    @StateObject private var calendarViewModel = MonthlyCalendarViewModel()
//    @StateObject private var homeMasterDetailVM = HomeMasterDetailViewModel()
//    @State private var navigateNotification = false
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                MainNavigationBar(
//                    logoName: companyID == 1 ? "chinuF_logo" : "Total_multi",
//                    projectName: companyID == 1 ? "CHINU FILMS" : "TOTAL MULTIMEDIA",
//                    onSearchTapped: {
//                        print("Search tapped")
//                    },
//                    onNotificationTapped: {
//                        navigateNotification = true
//                        print("Notification tapped")
//                    }
//                )
//                VStack(spacing: 16) {
//                    EmployeeCard(
//                        imageName: "\(PImg)",
//                        employeeName: name.uppercased(),
//                        employeeCode: empCode,
//                        employeeAttendance: "\(selectedAttendance?.inTime ?? "") - \(selectedAttendance?.outTime ?? "")",
//                        type: .none
//                    )
//                }
//                .padding(10)
//                AllListView()
//                Spacer()
//                NavigationLink(
//                    destination: NotificationHistoryListView()
//                        .environmentObject(NotificationHandler.shared),
//                    isActive: $navigateNotification
//                ) {
//                    EmptyView()
//                }
//                .hidden()
//            }
//        }
//        .onAppear {
//            companyID = UserDefaultsManager.getCompanyId()
//            print("companyID", companyID)
//            // homeMasterDetailVM.getMasterDetail()
//        }
//        .navigationBarBackButtonHidden(true)
//    }
//}
import SwiftUI

struct MainHomeView: View {
    
    @State private var selectedDate = Date()
    @State private var selectedAttendance: EpmDetails? = nil
    @State private var selectedDayOnly: String = ""
    @State private var name: String = UserDefaultsManager.getName()
    @State private var empCode: String = UserDefaultsManager.getEmpCode()
    @State private var PImg: String = UserDefaultsManager.getProfileImage()
    @StateObject private var calendarViewModel = MonthlyCalendarViewModel()
    @StateObject private var homeMasterDetailVM = HomeMasterDetailViewModel()
    @State private var navigateNotification = false
    @State private var navigateSearchScreen = false
    @State private var navigateQRScreen = false
    @State private var navigateToProfile = false
    @State private var notificationCount: Int = 0
    @State private var scannedText = ""
    @State private var showNotice = false
    @State private var remindLaterTime: Date? = nil
    
    @State private var showConfetti = false
    var isBirthday: Bool {
        guard let bday = homeMasterDetailVM.masterDetail?.BDay,
              !bday.isEmpty else {
            return false
        }
        return isTodayBirthday(bday)
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 0) {
                    MainNavigationBar(
                        logoName: "sanskar",
                        projectName: "SEP",
                        onSearchTapped: {
                            navigateSearchScreen = true
                        },
                        onNotificationTapped: {
                            navigateNotification = true
                            print("Notification tapped")
                            BadgeManager.update(count: notificationCount)
                        },
                        onQRTapped : {
                            navigateQRScreen = true
                        },
                        notificationCount: notificationCount
                    )
                    VStack(spacing: 16) {
                        if isBirthday {
                            BirthdayBannerView()
                        }
                        EmployeeCard(
                            imageName: "\(PImg)",
                            employeeName: name.uppercased(),
                            employeeCode: empCode,
                            employeeAttendance: {
                                let inTime = homeMasterDetailVM.masterDetail?.InTime ?? ""
                                let outTime = homeMasterDetailVM.masterDetail?.OutTime ?? ""
                                
                                if inTime.isEmpty {
                                    return Text("Absent")
                                        .foregroundColor(.red)
                                        .font(.callout)
                                } else {
                                    return Text("In - \(inTime)" + (outTime.isEmpty ? "" : "  Out - \(outTime)"))
                                        .foregroundColor(.primary)
                                        .font(.callout)
                                }
                            }(),
                            type: .none,
                            onProfileTapped: {
                                navigateToProfile = true
                            }, showEditButton: false,
                            onEditTapped: nil
                        )
                    }
                    .padding(10)
                    AllListView()
                    Spacer()
                    NavigationLink(
                        destination: NotificationHistoryListView()
                            .environmentObject(NotificationHandler.shared),
                        isActive: $navigateNotification
                    ) {
                        EmptyView()
                    }
                   
                    NavigationLink(destination: UserProfileScreenView(), isActive: $navigateToProfile) {
                        EmptyView()
                    }
                    .hidden()
                    
                }
            }
           
            
        }
        
        .onAppear {
            homeMasterDetailVM.getMasterDetail()
            if isBirthday && shouldShowConfettiToday() {
                showConfetti = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    showConfetti = false
                }
            }
        }
        .overlay {
            if showConfetti {
                ConfettiView()
                    .transition(.opacity)
            }
        }
        .onChange(of: homeMasterDetailVM.masterDetail) { newDetail in
            let count = newDetail?.notification_count ?? 0
            notificationCount = count
            BadgeManager.update(count: count)
            if let detail = newDetail, detail.notice_active == true {
                let savedRemindTime = UserDefaults.standard.object(forKey: "remindLaterTimes") as? Date
                if savedRemindTime == nil || savedRemindTime! <= Date() {
                    showNotice = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
