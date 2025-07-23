//
//  GetMyReportsList.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 14/05/25.
//
import Foundation

struct GetMyReportsList : Codable {
    let status : Bool?
    let message : String?
    let data : [MyReportsList]?
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
        data = try values.decodeIfPresent([MyReportsList].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct MyReportsList : Codable {
    let sno : Int?
    let empCode : String?
    let date1 : String?
    let date2 : String?
    let leave_type : String?
    let leave_can : Int?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case sno = "Sno"
        case empCode = "EmpCode"
        case date1 = "Date1"
        case date2 = "Date2"
        case leave_type = "leave_type"
        case leave_can = "Leave_can"
        case status = "Status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sno = try values.decodeIfPresent(Int.self, forKey: .sno)
        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
        date1 = try values.decodeIfPresent(String.self, forKey: .date1)
        date2 = try values.decodeIfPresent(String.self, forKey: .date2)
        leave_type = try values.decodeIfPresent(String.self, forKey: .leave_type)
        leave_can = try values.decodeIfPresent(Int.self, forKey: .leave_can)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}

