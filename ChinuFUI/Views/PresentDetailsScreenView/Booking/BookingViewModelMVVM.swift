//
//  BookingViewModelMVVM.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 15/07/25.
//

import SwiftUI

@MainActor
class BookingViewModel: ObservableObject {
    @Published var bookings: [NewBooking] = []
    @Published var dateKeyOptions: [GetDateKey] = []
    @Published var assignDetails: [AssignBookingDetail] = []
    
    @Published var keyId: String? = nil
    @Published var dateRange: String = "all"
    @Published var selectDateStart: Date = Date()
    @Published var selectDateEnd: Date = Date()
    
    @Published var showDropdown = false
    @Published var showCustomDatePicker = false
    @Published var showOnlyApproved = false
    @Published var searchText = ""
    @Published var selectedAssign: Bool? = nil
    
    var filteredBookings: [NewBooking] {
        if searchText.isEmpty {
            return bookings
        } else {
            return bookings.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
    
    func onAppear() {
        resetDateFilter()
        getApproveKathalist()
    }
    
    func onToggleChanged(_ isApproved: Bool) {
        resetDateFilter()
        if isApproved {
            dateRange = ""
            kathaGetDataByDateAPI()
            getDateKeyModel()
        } else {
            getApproveKathalist()
        }
    }
    
    func resetDateFilter() {
        dateRange = "all"
        keyId = nil
        showCustomDatePicker = false
        showDropdown = false
        selectDateStart = Date()
        selectDateEnd = Date()
    }
    func assignBookingDetailAPI() {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode()
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.assignBookingDetail,
            method: .post,
            param: params,
            model: AssignBookingDetailModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        self.assignDetails = model.data ?? []
                    } else {
                        self.assignDetails = []
                        ToastManager.shared.show(message: model.message ?? "Failed to fetch")
                    }
                case .failure(let error):
                    self.assignDetails = []
                    ToastManager.shared.show(message: "API Error")
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func getApproveKathalist() {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode(),
            "category_id": "2"
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getApproveKathalist,
            method: .post,
            param: params,
            model: NewBookingModel.self
        ) { result in
            switch result {
            case .success(let model):
                self.bookings = model.data ?? []
                ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
            case .failure(let error):
                ToastManager.shared.show(message: "Enter Correct ID")
                print("API Error: \(error)")
            }
        }
    }
    
    func getDateKeyModel() {
        let dict: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode()
        ]
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getDateKeyAPI,
            method: .post,
            param: dict,
            model: GetDateKeyModel.self
        ) { result in
            switch result {
            case .success(let model):
                self.dateKeyOptions = model.data ?? []
                ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
            case .failure(let error):
                ToastManager.shared.show(message: "Enter Correct ID")
                print("API Error: \(error)")
            }
        }
    }
    
    func kathaGetDataByDateAPI() {
        var dict: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode()
        ]
        
        dict["value"] = keyId ?? "-3"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if dateRange == "custom" {
            dict["start_date"] = formatter.string(from: selectDateStart)
            dict["end_date"] = formatter.string(from: selectDateEnd)
        } else {
            dict["start_date"] = ""
            dict["end_date"] = ""
        }
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.kathaGetDataByDate,
            method: .post,
            param: dict,
            model: NewBookingModel.self
        ) { result in
            switch result {
            case .success(let model):
                self.bookings = model.data ?? []
                ToastManager.shared.show(message: model.message ?? "Fetched Successfully")
            case .failure(let error):
                ToastManager.shared.show(message: "Enter Correct ID")
                print("API Error: \(error)")
            }
        }
    }
}
