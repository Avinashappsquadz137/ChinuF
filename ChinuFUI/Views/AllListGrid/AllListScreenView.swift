//
//  AllListScreenView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 26/04/25.
//

import SwiftUI

struct AllListView: View {
    @State private var reqType: [SideBar] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var searchText = ""
    var filteredReqType: [SideBar] {
        if searchText.isEmpty {
            return reqType
        } else {
            return reqType.filter { ($0.name ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }
    var body: some View {
        VStack {
            SearchBars(text: $searchText)
            ScrollView {
                LazyVGrid(columns: columns ,spacing: 8) {
                    ForEach(filteredReqType.indices, id: \.self) { index in
                        let item = filteredReqType[index]
                        NavigationLink(
                            destination: destinationView(for: item.id ?? 0)
                        ) {
                            CardView(item: item)
                                .padding(3)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            fetchSidebarAPI()
        }
    }
    
    func fetchSidebarAPI() {
        var dict = [String: Any]()
        dict["EmpCode"] = "\(UserDefaultsManager.getEmpCode())"
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.sidebarapi,
            method: .post,
            param: dict,
            model: SideBarApi.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if var data = model.data {
                        data = data.filter { $0.id != 4 }
                        self.reqType = data
                        let manualItem = SideBar(id: 100, name: "Profile")
                        self.reqType.insert(manualItem, at: 0)
                        let manualItem2 = SideBar(id: 101, name: "Calander")
                        self.reqType.insert(manualItem2, at: 1)
                    }
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for id: Int) -> some View {
        if id == 100 {
            UserProfileScreenView()
                .navigationTitle("User Profile")
        } else if id == 2 {
            ApplyLeaveView()
        }else if id == 25 {
            PunchHistoryView()
        }else if id == 101 {
            CalendarScreenView()
        } else if id == 8 {
            GuestRecordHistory()
        } else if id == 17 {
            MyReportsViews()
                .navigationTitle("My Reports")
        } else if id  == 18 {
            AllReportsViews()
                .navigationTitle("All Reports")
        } else if id == 7 {
            ReportsViews()
        } else if id == 22 {
            LeaveApprovalView()
                .navigationTitle("Leave Approval")
        }  else if id == 23 {
            BookingApprovalView()
                .navigationTitle("Booking Approval")
        } else if id == 1 {
            ApprovalView()
        }else if id == 14 {
            WebOpenerView(urlString: "https://app.sanskargroup.in/terms.html")
        }else if id ==  11 {
            HealthViewScreen()
                .navigationTitle("Health Policy Card")
        } else if id == 3 {
            Group {
                if UserDefaultsManager.getBookingRoleID() == "4" {
                    BookReceptionScreen()
                } else if UserDefaultsManager.getBookingRoleID() == "9" {
                    QCMetaViewScreen()
                } else {
                    BookingViewScreen()
                }
            }
            .navigationTitle("Booking View")
        }else if id == 5 {
            RequestViewScreen()
                .navigationTitle("Request View")
        }else if id == 6 {
            MainTourView()
                .navigationTitle("TOUR")
        }else if id  == 24 {
            SelfPunchView()
                .navigationTitle("Self Punch")
        }else {
            Text("Work In Progress")
        }
    }
}

// MARK: - Subview to simplify NavigationLink label

struct CardView: View {
    let item: SideBar
    
    var body: some View {
        HStack(spacing: 5) {
            Image(uiImage: imageForID(item.id ?? 0))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text(item.name ?? "")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .minimumScaleFactor(0.8)
            
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width / 2  - 30)
        .background(Color(.white))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 2)
    }
    
    private func imageForID(_ id: Int) -> UIImage {
        switch id {
        case 1: return UIImage(named: "approved") ?? defaultImage()
        case 2: return UIImage(named: "Leave") ?? defaultImage()
        case 3: return UIImage(named: "booking") ?? defaultImage()
        case 4: return UIImage(named: "Inventory") ?? defaultImage()
        case 5: return UIImage(named: "interview") ?? defaultImage()
        case 6: return UIImage(named: "Tour") ?? defaultImage()
        case 7: return UIImage(named: "Reports") ?? defaultImage()
        case 8: return UIImage(named: "Guest") ?? defaultImage()
        case 11: return UIImage(named: "healthcare") ?? defaultImage()
        case 14: return UIImage(named: "Privacy Policy") ?? defaultImage()
        case 17: return UIImage(named: "Reports") ?? defaultImage()
        case 18: return UIImage(named: "Reports") ?? defaultImage()
        case 24: return UIImage(named: "biometricAttendance") ?? defaultImage()
        case 25: return UIImage(named: "attendance") ?? defaultImage()
        case 23: return UIImage(named: "booking") ?? defaultImage()
        case 22: return UIImage(named: "Leave") ?? defaultImage()
        case 100: return UIImage(named: "Profile") ?? defaultImage()
        case 101:return UIImage(named: "Leave") ?? defaultImage()
        default: return defaultImage()
        }
    }
    
    private func defaultImage() -> UIImage {
        return UIImage(named: "default") ?? UIImage(systemName: "questionmark.square")!
    }
}
struct WebOpenerView: View {
    let urlString: String

    var body: some View {
        Text("Opening Web Page...")
            .onAppear {
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
    }
}
