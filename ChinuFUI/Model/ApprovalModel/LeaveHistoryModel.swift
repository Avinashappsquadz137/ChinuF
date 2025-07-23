//
//  LeaveHistoryModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 15/05/25.
//
import Foundation

struct LeaveHistoryModel : Codable {
    let status : Bool?
    let message : String?
    let data : [LeaveHistory]?
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
        data = try values.decodeIfPresent([LeaveHistory].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}
struct LeaveHistory : Codable {
    let application_No : Int?
    let name : String?
    let leave_From : String?
    let leave_to : String?
    let lReason : String?
    let type : String?
    let imageURL : String?
    let location : String?
    let status : String?
    let department : String?

    enum CodingKeys: String, CodingKey {

        case application_No = "Application_No"
        case name = "name"
        case leave_From = "Leave_From"
        case leave_to = "Leave_to"
        case lReason = "LReason"
        case type = "type"
        case imageURL = "ImageURL"
        case location = "location"
        case status = "Status"
        case department = "Dept"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        application_No = try values.decodeIfPresent(Int.self, forKey: .application_No)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        leave_From = try values.decodeIfPresent(String.self, forKey: .leave_From)
        leave_to = try values.decodeIfPresent(String.self, forKey: .leave_to)
        lReason = try values.decodeIfPresent(String.self, forKey: .lReason)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        department = try values.decodeIfPresent(String.self, forKey: .department)
    }

}

