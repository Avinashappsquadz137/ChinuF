//
//  PunchHistoryModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 01/05/25.
//
import Foundation

struct PunchHistoryModel : Codable {
    let status : Bool?
    let message : String?
    let data : [Attendance]?
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
        data = try values.decodeIfPresent([Attendance].self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}

struct Attendance : Codable {
    let date : Int?
    let inTime : String?
    let outTime : String?
    let locationIn : String?
    let locationOut : String?
    let status : Int?
    let date1 : String?

    enum CodingKeys: String, CodingKey {

        case date = "Date"
        case inTime = "InTime"
        case outTime = "OutTime"
        case locationIn = "LocationIn"
        case locationOut = "LocationOut"
        case status = "status"
        case date1 = "Date1"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(Int.self, forKey: .date)
        date1 = try values.decodeIfPresent(String.self, forKey: .date1)
        inTime = try values.decodeIfPresent(String.self, forKey: .inTime)
        outTime = try values.decodeIfPresent(String.self, forKey: .outTime)
        locationIn = try values.decodeIfPresent(String.self, forKey: .locationIn)
        locationOut = try values.decodeIfPresent(String.self, forKey: .locationOut)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
    }

}
