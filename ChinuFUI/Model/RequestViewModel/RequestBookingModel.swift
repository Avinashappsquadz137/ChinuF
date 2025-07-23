//
//  RequestBookingModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 27/06/25.
//
import Foundation

struct RequestBookingModel : Codable {
    let status : Bool?
    let message : String?
    let data : [RequestBooking]?
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
        data = try values.decodeIfPresent([RequestBooking].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct RequestBooking : Codable {
    let katha_id : Int?
    let katha_date : String?
    let katha_from_Date : String?
    let kathaTiming : String?
    let name : String?
    let amount : String?
    let salesEmpCode : String?
    let gST : String?
    let venue : String?
    let hodApproval : String?
    let katha_booking_id : String?
    let katha_category_Id : String?
    let channelName : String?
    let slotTiming : String?
    let remarks : String?
    let request_type : Int?
    let permission : Int?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case katha_id = "Katha_id"
        case katha_date = "Katha_date"
        case katha_from_Date = "Katha_from_Date"
        case kathaTiming = "KathaTiming"
        case name = "Name"
        case amount = "Amount"
        case salesEmpCode = "salesEmpCode"
        case gST = "GST"
        case venue = "Venue"
        case hodApproval = "HodApproval"
        case katha_booking_id = "katha_booking_id"
        case katha_category_Id = "Katha_category_Id"
        case channelName = "ChannelName"
        case slotTiming = "SlotTiming"
        case remarks = "Remarks"
        case request_type = "request_type"
        case permission = "permission"
        case status = "Status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        katha_id = try values.decodeIfPresent(Int.self, forKey: .katha_id)
        katha_date = try values.decodeIfPresent(String.self, forKey: .katha_date)
        katha_from_Date = try values.decodeIfPresent(String.self, forKey: .katha_from_Date)
        kathaTiming = try values.decodeIfPresent(String.self, forKey: .kathaTiming)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        salesEmpCode = try values.decodeIfPresent(String.self, forKey: .salesEmpCode)
        gST = try values.decodeIfPresent(String.self, forKey: .gST)
        venue = try values.decodeIfPresent(String.self, forKey: .venue)
        hodApproval = try values.decodeIfPresent(String.self, forKey: .hodApproval)
        katha_booking_id = try values.decodeIfPresent(String.self, forKey: .katha_booking_id)
        katha_category_Id = try values.decodeIfPresent(String.self, forKey: .katha_category_Id)
        channelName = try values.decodeIfPresent(String.self, forKey: .channelName)
        slotTiming = try values.decodeIfPresent(String.self, forKey: .slotTiming)
        remarks = try values.decodeIfPresent(String.self, forKey: .remarks)
        request_type = try values.decodeIfPresent(Int.self, forKey: .request_type)
        permission = try values.decodeIfPresent(Int.self, forKey: .permission)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}

