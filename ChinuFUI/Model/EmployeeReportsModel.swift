//
//  EmployeeReports.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 15/05/25.
//
import Foundation

struct EmployeeReportsModel : Codable {
    let status : Bool?
    let message : String?
    let data : [EmployeeReports]?
    let error : String?

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
        data = try values.decodeIfPresent([EmployeeReports].self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}

struct EmployeeReports : Codable {
    let name : String?
    let empCode : String?
    let dept : String?
    let empImage : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case empCode = "EmpCode"
        case dept = "Dept"
        case empImage = "EmpImage"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
        dept = try values.decodeIfPresent(String.self, forKey: .dept)
        empImage = try values.decodeIfPresent(String.self, forKey: .empImage)
    }

}

