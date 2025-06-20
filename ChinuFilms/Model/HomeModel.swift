//
//  HomeModel.swift
//  SanskarEP
//
//  Created by Warln on 11/01/22.
//

import Foundation

struct TaskManagement {
    var taskName: String
    var taskImg: String
    
}

struct leaveManager {
    var taskName: String
    var taskImg: String
}

struct RequestDetail {
    var title: String
    var image: String
}

struct Approve {
    var title: String
    var image: String
   
}

struct Booking {
    var title: String
    var image: String
}
struct GuestManage {
    var title: String
    var image: String
}
struct KathaManage {
    var title: String
    var image: String
}
struct tour: Codable {
    var ID: String
    var Name: String
    var Dept: String
    var Requirement: String
    var Location: String
}
struct TourDetail {
    var title: String
    var image: String
}
struct BookingDetail {
    var title: String
    var image: String
}
struct TourData: Codable {
    let sno: Int
    let tourId: String
    let empCode: String
    let billingThumbnail: String
    let hod: String
    let status: Int
    let creationOn: CreationOn
    let amount: String
    let updationTime: String?
    let reason: String

    struct CreationOn: Codable {
        let date: String
        let timezoneType: Int
        let timezone: String
    }
}
struct HodTour: Codable {
  //  let sectionType: String
    let imageGallery: [String]
}
struct YourData {
    var status: Int 
}
struct NewRequestManage {
    var title: String
    var image: String
}
struct OtherManage {
    var title: String
    var image: String
}



struct EventData {
    var name: String
    var pImg: String
    var dept: String
    var empReqNo: String
    var empCode: String
    var lReason: String
    var leaveType: String
    var fromDate: String
    var toDate: String
    var reqDate: String
    
    // Initializer that takes a dictionary and parses it
    init?(dict: [String: Any]) {
        guard let name = dict["Name"] as? String,
              let pImg = dict["PImg"] as? String,
              let dept = dict["Dept"] as? String,
              let empReqNo = dict["Emp_Req_No"] as? String,
              let empCode = dict["Emp_Code"] as? String,
              let lReason = dict["LReason"] as? String,
              let leaveType = dict["leave_type"] as? String,
              let fromDate = dict["from_date"] as? String,
              let toDate = dict["to_date"] as? String,
              let reqDate = dict["req_date"] as? String else {
            return nil
        }
        
        self.name = name
        self.pImg = pImg
        self.dept = dept
        self.empReqNo = empReqNo
        self.empCode = empCode
        self.lReason = lReason
        self.leaveType = leaveType
        self.fromDate = fromDate
        self.toDate = toDate
        self.reqDate = reqDate
    }
}
