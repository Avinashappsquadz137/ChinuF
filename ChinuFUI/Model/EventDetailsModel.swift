//
//  EventDetailsModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 25/04/25.
//

import Foundation

struct EventDetailsModel : Codable {
    let status : Bool?
    let message : String?
    let data : [Events]?
    let error : [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case data = "data"
        case error = "error"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([Events].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }
    
}

struct Events : Codable {
    let name : String?
    let pImg : String?
    let dept : String?
    let iD : String?
    let emp_Code : String?
    let reason : String?
    let leave_type : String?
    let event_type : String?
    var actionStatus : String?
    let from_date : String?
    let to_date : String?
    let req_date : String?
    let bDay : String?
    let status : String?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "Name"
        case pImg = "PImg"
        case dept = "Dept"
        case iD = "ID"
        case emp_Code = "Emp_Code"
        case reason = "Reason"
        case leave_type = "leave_type"
        case event_type = "event_type"
        case actionStatus = "actionStatus"
        case from_date = "from_date"
        case to_date = "to_date"
        case req_date = "req_date"
        case bDay = "BDay"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pImg = try values.decodeIfPresent(String.self, forKey: .pImg)
        dept = try values.decodeIfPresent(String.self, forKey: .dept)
        iD = try values.decodeIfPresent(String.self, forKey: .iD)
        emp_Code = try values.decodeIfPresent(String.self, forKey: .emp_Code)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        leave_type = try values.decodeIfPresent(String.self, forKey: .leave_type)
        event_type = try values.decodeIfPresent(String.self, forKey: .event_type)
        if let stringValue = try? values.decode(String.self, forKey: .actionStatus) {
            actionStatus = stringValue
        } else if let intValue = try? values.decode(Int.self, forKey: .actionStatus) {
            actionStatus = String(intValue)
        } else {
            actionStatus = nil
        }
        from_date = try values.decodeIfPresent(String.self, forKey: .from_date)
        to_date = try values.decodeIfPresent(String.self, forKey: .to_date)
        req_date = try values.decodeIfPresent(String.self, forKey: .req_date)
        bDay = try values.decodeIfPresent(String.self, forKey: .bDay)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        
    }
    
}
