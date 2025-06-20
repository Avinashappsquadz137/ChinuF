//
//  MonthWiseEmpDetail.swift
//  SanskarEP
//
//  Created by Surya on 11/02/25.
//

import Foundation

struct MonthWiseEmpDetail : Codable {
    let status : Bool?
    let message : String?
    let data : [EpmDetails]?
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
        data = try values.decodeIfPresent([EpmDetails].self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
struct EpmDetails : Codable {
    let date : Int?
    let inTime : String?
    let outTime : String?
    let status : Int?

    enum CodingKeys: String, CodingKey {

        case date = "Date"
        case inTime = "InTime"
        case outTime = "OutTime"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(Int.self, forKey: .date)
        inTime = try values.decodeIfPresent(String.self, forKey: .inTime)
        outTime = try values.decodeIfPresent(String.self, forKey: .outTime)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }

}
