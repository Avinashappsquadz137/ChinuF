//
//  MonthWiseEmpDetail.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/04/25.
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
      let fullDate: String?
      let date: Int?
      let inTime: String?
      let outTime: String?
      let status: Int?
      let locationIn: String?
      let locationOut: String?

    enum CodingKeys: String, CodingKey {
        case fullDate = "Date1"
        case date = "Date"
        case inTime = "InTime"
        case outTime = "OutTime"
        case status = "status"
        case locationIn = "LocationIn"
        case locationOut = "LocationOut"
    }

    init(from decoder: Decoder) throws {
           let values = try decoder.container(keyedBy: CodingKeys.self)
           fullDate = try values.decodeIfPresent(String.self, forKey: .fullDate)
           date = try values.decodeIfPresent(Int.self, forKey: .date)
           inTime = try values.decodeIfPresent(String.self, forKey: .inTime)
           outTime = try values.decodeIfPresent(String.self, forKey: .outTime)
           status = try values.decodeIfPresent(Int.self, forKey: .status)
           locationIn = try values.decodeIfPresent(String.self, forKey: .locationIn)
           locationOut = try values.decodeIfPresent(String.self, forKey: .locationOut)
       }

}
