//
//  TourBillingRequestModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 01/07/25.
//

import Foundation
struct TourBillingRequestModel : Codable {
    let status : Bool?
    let message : String?
    let data : [BillingRequestModel]?
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
        data = try values.decodeIfPresent([BillingRequestModel].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct BillingRequestModel : Codable {
    let sno : Int?
    let tour_id : String?
    let empCode : String?
    let billing_thumbnail : String?
    let hOD : String?
    let status : Int?
    let creationOn : CreationOn?
    let amount : String?
    let updation_time : String?
    let reason : String?
    let allbillSno : String?

    enum CodingKeys: String, CodingKey {

        case sno = "Sno"
        case tour_id = "Tour_id"
        case empCode = "EmpCode"
        case billing_thumbnail = "Billing_thumbnail"
        case hOD = "HOD"
        case status = "Status"
        case creationOn = "CreationOn"
        case amount = "Amount"
        case updation_time = "updation_time"
        case reason = "reason"
        case allbillSno = "allbillSno"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sno = try values.decodeIfPresent(Int.self, forKey: .sno)
        tour_id = try values.decodeIfPresent(String.self, forKey: .tour_id)
        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
        billing_thumbnail = try values.decodeIfPresent(String.self, forKey: .billing_thumbnail)
        hOD = try values.decodeIfPresent(String.self, forKey: .hOD)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        creationOn = try values.decodeIfPresent(CreationOn.self, forKey: .creationOn)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        updation_time = try values.decodeIfPresent(String.self, forKey: .updation_time)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        allbillSno = try values.decodeIfPresent(String.self, forKey: .allbillSno)
    }

}

struct CreationOn : Codable {
    let date : String?
    let timezone_type : Int?
    let timezone : String?

    enum CodingKeys: String, CodingKey {

        case date = "date"
        case timezone_type = "timezone_type"
        case timezone = "timezone"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        timezone_type = try values.decodeIfPresent(Int.self, forKey: .timezone_type)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
    }

}
