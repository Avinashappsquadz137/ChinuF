//
//  BookingHistoryModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 26/05/25.
//
import Foundation

struct BookingHistoryModel : Codable {
    let status : Bool?
    let message : String?
    let data : [BookingHistory]?
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
        data = try values.decodeIfPresent([BookingHistory].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}
struct BookingHistory : Codable {
    let katha_id : String?
    let name : String?
    let amount : String?
    let katha_category_Id : String?
    let katha_date : String?
    let katha_from_Date : String?
    let kathaTiming : String?
    let gST : String?
    let venue : String?
    let katha_booking_id : String?
    let channelName : String?

    enum CodingKeys: String, CodingKey {

        case katha_id = "Katha_id"
        case name = "Name"
        case amount = "Amount"
        case katha_category_Id = "Katha_category_Id"
        case katha_date = "Katha_date"
        case katha_from_Date = "Katha_from_Date"
        case kathaTiming = "KathaTiming"
        case gST = "GST"
        case venue = "Venue"
        case katha_booking_id = "katha_booking_id"
        case channelName = "ChannelName"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        katha_id = try values.decodeIfPresent(String.self, forKey: .katha_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        katha_category_Id = try values.decodeIfPresent(String.self, forKey: .katha_category_Id)
        katha_date = try values.decodeIfPresent(String.self, forKey: .katha_date)
        katha_from_Date = try values.decodeIfPresent(String.self, forKey: .katha_from_Date)
        kathaTiming = try values.decodeIfPresent(String.self, forKey: .kathaTiming)
        gST = try values.decodeIfPresent(String.self, forKey: .gST)
        venue = try values.decodeIfPresent(String.self, forKey: .venue)
        katha_booking_id = try values.decodeIfPresent(String.self, forKey: .katha_booking_id)
        channelName = try values.decodeIfPresent(String.self, forKey: .channelName)
    }

}

