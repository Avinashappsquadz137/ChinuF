//
//  BookReceptionModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 17/07/25.
//

import Foundation
struct BookReceptionModel : Codable {
    let status : Bool?
    let message : String?
    let data : [BookReception]?
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
        data = try values.decodeIfPresent([BookReception].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct BookReception : Codable {
    let booking_id : Int?
    let caller_name : String?
    let caller_mobile : String?
    let remarks : String?
    let location : String?
    let creator_name : String?
    let sales_person_name : String?
    let status : String?
    let katha_date : String?
    let katha_from_Date : String?

    enum CodingKeys: String, CodingKey {

        case booking_id = "booking_id"
        case caller_name = "caller_name"
        case caller_mobile = "caller_mobile"
        case remarks = "remarks"
        case location = "location"
        case creator_name = "creator_name"
        case sales_person_name = "sales_person_name"
        case status = "Status"
        case katha_date = "Katha_date"
        case katha_from_Date = "Katha_from_Date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        booking_id = try values.decodeIfPresent(Int.self, forKey: .booking_id)
        caller_name = try values.decodeIfPresent(String.self, forKey: .caller_name)
        caller_mobile = try values.decodeIfPresent(String.self, forKey: .caller_mobile)
        remarks = try values.decodeIfPresent(String.self, forKey: .remarks)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        creator_name = try values.decodeIfPresent(String.self, forKey: .creator_name)
        sales_person_name = try values.decodeIfPresent(String.self, forKey: .sales_person_name)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        katha_date = try values.decodeIfPresent(String.self, forKey: .katha_date)
        katha_from_Date = try values.decodeIfPresent(String.self, forKey: .katha_from_Date)
    }

}
