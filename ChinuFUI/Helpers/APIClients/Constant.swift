//
//  Constant.swift
//  Binko Movi
//
//  Created by Warln on 20/08/22.


import UIKit

class ApiRequest {
    static let shared = ApiRequest()
    
    enum BuildType {
        case dev
        case pro
    }
    
    struct Url {
        static var buildType: BuildType = .dev
        
        static var serverURL: String {
            switch buildType {
            case .dev:
                return "https://emp.sanskargroup.in/chinufilms/"
            case .pro:
                return "https://emp.sanskargroup.in/"
            }
        }
    }
}

struct Constant {

    static let BASEURL                     = ApiRequest.Url.serverURL
    static let imageURL                    = "https://ep.sanskargroup.in/uploads/"
    
    static let getlogin                    = "api_panel/login_app"
    static let employeeMasterDetail        = "api_panel/employee_master_detail"
    static let monthWiseDetailApi          = "api_panel/get_month_wise_emp_detail"
    static let eventDetail                 = "api_panel/event_detail"
    static let sidebarapi                  = "api_panel/side_bar"
    static let getLogin                    = "api_panel/login_app"
    static let detailOfEmp                 = "api_panel/detailofemp"
    static let hodLeaveUpdate              = "api_panel/hod_leave_update"
    static let birthdayWishApi             = "api-panel/wish-birthday"
    static let birthdayWishreply           = "api-panel/wish-birthday"
    static let wfhomeRequest               = "api_panel/work_from_home"
    static let dayOffRequest               = "api_panel/off_day"
    static let leaveRequest                = "api_panel/employee_leave"
    static let getMonthWiseEmpDetail       = "api_panel/get_month_wise_emp_detail"
    static let guestRecordHistoryApi       = "api_panel/guest_record"
    static let applyNewGuest               = "api_panel/guest_request"
    static let getMyReportsListApi         = "api_panel/get_leave_requestList"
    static let myLeaveCancel               = "api_panel/leave_cancellation"
    static let employeeLeaveListApi        = "api_panel/employee"
    static let approveListHistory          = "api_panel_dev/aprovelistHistory"
    static let kathaApproval               = "api_panel/katha_approval"
    static let kathaBookingDetail          = "api_panel/katha_booking_detail"
    static let getApproveKathalist         = "api_panel/get-approve-kathalist"
    static let kathaApprovalApi            = "api_panel/katha_approval"
    static let kathaCategory               = "api_panel/katha_category"
    static let channelList                 = "api_panel/channel_list"
    static let getKathaTimingCategory      = "api_panel/get_katha_timing_by_katha_category"
    static let existGuruList               = "api_panel/exist_guru_list"
    static let kathabookingApi             = "api_panel/katha_booking"
    static let requestBookingList          = "api_panel/request_booking"
    static let getDataPromoAssign          = "api_panel/get_data_promo"
    static let bookingPromoType            = "api_panel/booking_promo_type"
    static let tourFormApi                 = "api_panel/tour_form"
    static let getTourBillingApprovalList  = "api_panel/get_tour_billing_approval_list"
    static let tourBillingRequestIos       = "api_panel/tour_billing_request_ios"
    static let deleteBillingRequest        = "api_panel/delete_tourid_billing_request"
    static let submitTourBillRequest       = "api_panel/submit_tour_billing_request"
    static let pushHistoryList             = "api_panel/push_history"
    static let guestFloor                  = "api_panel/get_floor"
    static let empGuestAction              = "api_panel/emp_action_guest"
    static let removePushHistory           = "api_panel/remove_push_history"
    static let selfPunchAPI                = "api_panel/selfPunch"
    static let updateProfile               = "api_panel/update_profile"
    static let getlogout                   = "api_panel/logout"
    static let verifyOTP                   = "api_panel/email_otp_verification"
    static let setNewPin                   = "api_panel/set_pin"
    static let kathaGetDataByDate          = "api_panel/get_data_by_date"
    static let getDateKeyAPI               = "api_panel/get_date_key"
    static let clientdetailApi             = "api_panel/kathabooking_clientdetail"
    static let assignBookingDetail         = "api_panel/assign_booking_detail"
    static let kathaBookingAssign          = "api_panel/katha_booking_assign"
    static let bookingLeadAPI              = "api_panel/booking_lead"
}


