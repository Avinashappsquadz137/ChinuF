//
//  BookingViewScreen.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 28/05/25.
//
//roleID == 1  tyagi ji , permission 1
//roleID == 2 vipil ji , permission 2
//roleID == 3 sales , permission 3
//roleID == 4 reception, permission 4
//roleID == 5 HOD  , permission 5
//roleID == 6 employees
//roleID == 7 qc employee
//roleID == 8 Qc hod
//roleID == 9 Qc team by channel
//roleID == 10 Library
import SwiftUI

struct BookingViewScreen: View {
    @StateObject private var viewModel = BookingViewModel()
    
    @State private var navigateToAddKatha = false
    @State private var navigateApprove = false
    @State private var navigateClientDetails = false
    @State private var selectedBooking: NewBooking?
    @State private var showAssignSheet = false

    let allowedRoles: Set<Int> = [1, 2, 3]
    let roleID = Int(UserDefaultsManager.getBookingRoleID()) ?? 1
    var body: some View {
        ZStack {
            VStack {
                CustomNavigationBar(
                    onFilter: {
                        if viewModel.dateKeyOptions.isEmpty {
                            viewModel.getDateKeyModel()
                        }
                        viewModel.showDropdown.toggle()
                    },
                    onSearch: { query in viewModel.searchText = query },
                    onAddListToggle: allowedRoles.contains(roleID) ? { navigateToAddKatha = true } : {},
                    isListMode: false,
                    showFilter: !viewModel.showOnlyApproved
                )
                
                if viewModel.showCustomDatePicker {
                    VStack(spacing: 16) {
                        DatePicker("Start Date", selection: $viewModel.selectDateStart, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                        DatePicker("End Date", selection: $viewModel.selectDateEnd, displayedComponents: [.date])
                            .datePickerStyle(.compact)
                        
                        Button("Apply") {
                            viewModel.kathaGetDataByDateAPI()
                            withAnimation {
                                viewModel.showDropdown = false
                                viewModel.showCustomDatePicker = false
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                }
                
                NavigationLink(destination: BookKathaView(isSelected: false), isActive: $navigateToAddKatha) { EmptyView() }.hidden()
                NavigationLink(destination: selectedBooking.map { BookingApproveSchedule(booking: $0) }, isActive: $navigateApprove) { EmptyView() }.hidden()
                NavigationLink(destination: selectedBooking.map { ClientDetailFormView(booking: $0) }, isActive: $navigateClientDetails) { EmptyView() }.hidden()
                
                if viewModel.filteredBookings.isEmpty {
                    EmptyStateView(imageName: "EmptyList", message: "No Booking List found")
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredBookings, id: \.katha_booking_id) { booking in
                                cellView(for: booking)
                            }

                        }
                        .padding()
                    }
                }
            }
            
            if viewModel.showDropdown && !viewModel.dateKeyOptions.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.dateKeyOptions, id: \.key) { option in
                        Button(action: {
                            viewModel.keyId = String(option.key ?? -3)
                            viewModel.dateRange = option.date_range ?? "all"
                            if viewModel.dateRange == "custom" {
                                withAnimation {
                                    viewModel.showDropdown = false
                                    viewModel.showCustomDatePicker = true
                                }
                            } else {
                                viewModel.kathaGetDataByDateAPI()
                                withAnimation {
                                    viewModel.showDropdown = false
                                    viewModel.showCustomDatePicker = false
                                }
                            }
                        }) {
                            Text(option.date_range ?? "Unknown")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .foregroundColor(.black)
                        }
                        .overlay(Rectangle().frame(height: 0.5).foregroundColor(Color.gray.opacity(0.3)), alignment: .bottom)
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
                .padding(.horizontal)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if allowedRoles.contains(roleID) {
                    Toggle("", isOn: $viewModel.showOnlyApproved)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .labelsHidden()
            }
         }
        }
        .onChange(of: viewModel.showOnlyApproved) { newValue in
            viewModel.onToggleChanged(newValue)
        }
        .onAppear {
            viewModel.onAppear()
        }
        .background(
            Color.clear.contentShape(Rectangle()).onTapGesture {
                if viewModel.showDropdown {
                    viewModel.showDropdown = false
                }
            }
        )
        .sheet(isPresented: $showAssignSheet) {
            AssignEmployeeSheet(assignList: viewModel.assignDetails) { selectedEmpCode in
                if let kathaId = selectedBooking?.katha_booking_id {
                    selectKathaAssignAPI(kathaId: kathaId, assignTo: selectedEmpCode)
                }
                
            }
        }
    }
    
    func selectKathaAssignAPI(kathaId: String, assignTo : String) {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode(),
            "katha_id": "\(kathaId)",
            "assign_to": assignTo,
        ]
        print(params)
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.kathaBookingAssign,
            method: .post,
            param: params,
            model: AssignBookingDetailModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                 showAssignSheet = false
                    ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
                case .failure(let error):
                    ToastManager.shared.show(message: "Enter Correct ID")
                    print("API Error: \(error)")
                }
            }
        }
    }
    private func cellView(for booking: NewBooking) -> some View {
        NewBookingCellView(
            config: NewBookingCellConfig(),
            onTap: {
                selectedBooking = booking
                if !viewModel.showOnlyApproved {
                    viewModel.assignBookingDetailAPI()
                    navigateApprove = true
                } else {
                    navigateClientDetails = true
                }
            },
            onAssignTap: {
                selectedBooking = booking
                viewModel.assignBookingDetailAPI()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showAssignSheet = true
                }
            },
            name: booking.name,
            amount: booking.amount,
            gST: booking.gST,
            channelName: booking.channelName,
            venue: booking.venue,
            katha_date: booking.katha_date,
            katha_from_Date: booking.katha_from_Date,
            kathaTiming: booking.kathaTiming,
            slotTiming: booking.slotTiming,
            status: booking.status,
            showAssignedList: viewModel.showOnlyApproved
        )
    }
}

struct NewBookingCellConfig {
    var showAmount: Bool = true
    var showGST: Bool = true
}


struct NewBookingCellView: View {
    
    var config: NewBookingCellConfig = NewBookingCellConfig()
    var onTap: (() -> Void)?
    var onAssignTap: (() -> Void)?
    
    let name : String?
    let amount : String?
    let gST : String?
    let channelName : String?
    let venue : String?
    let katha_date : String?
    let katha_from_Date : String?
    let kathaTiming : String?
    let slotTiming : String?
    let status : String?
    
    var showAssignedList: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(name?.uppercased() ?? "N/A")")
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    onTap?()
                }) {
                    Image(systemName: "arrowshape.forward.circle.fill")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
                
            }
            if config.showAmount || config.showGST {
                HStack {
                    Text("Amount: \(amount ?? "N/A")")
                        .font(.caption2)
                    Spacer()
                    Text("GST: \(gST ?? "N/A")")
                        .font(.caption2)
                }
            }
            
            HStack {
                Text("Channel: \(channelName ?? "N/A")")
                    .font(.caption2)
                Spacer()
                Text("Venue: \(venue ?? "N/A")")
                    .font(.caption2)
            }
            
            Text("Date: \(katha_date ?? katha_from_Date ?? "N/A")").font(.caption2)
            Text("Time: \(kathaTiming ?? slotTiming ?? "N/A")").font(.caption2)
            Text("Status: \(status ?? "N/A")").font(.caption2)
            
            if showAssignedList {
                Divider()
                HStack {
                    Text("Assigned To:")
                        .font(.caption).bold()
                    Button(action: {
                        onAssignTap?()
                    }) {
                        Text("Click Here To assign")
                            .font(.caption2)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
struct AssignEmployeeSheet: View {
    let assignList: [AssignBookingDetail]
    let onAssignSelected: (String) -> Void
    
    var body: some View {
        NavigationView {
            List(assignList, id: \.empCode) { employee in
                Button(action: {
                    if let empCode = employee.empCode {
                        onAssignSelected(empCode)
                    }
                }) {
                    VStack(alignment: .leading) {
                        Text(employee.name ?? "No Name")
                            .font(.headline)
                        Text("Emp Code: \(employee.empCode ?? "N/A")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Select Employee")
        }
    }
}
