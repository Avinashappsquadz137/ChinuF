//
//  HomeMasterDetailModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/07/25.
//
import Foundation
struct HomeMasterDetailModel : Codable {
    let status : Bool?
    let message : String?
    let data : HomeMasterDetail?
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
        data = try values.decodeIfPresent(HomeMasterDetail.self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct HomeMasterDetail : Codable , Equatable{
    let pl_balance : String?
    let InTime : String?
    let OutTime : String?
    let notification_count : Int?
    let BDay : String?
    
    let notice_active: Bool?        // true if notice should be shown
    let notice_title: String?       // title of the notice
    let notice_message: String?     // body message
    
    enum CodingKeys: String, CodingKey {

        case pl_balance = "pl_balance"
        case InTime = "InTime"
        case OutTime = "OutTime"
        case BDay = "BDay"
        case notification_count = "notification_count"
        case notice_active = "notice_active"
        case notice_title = "notice_title"
        case notice_message = "notice_message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pl_balance = try values.decodeIfPresent(String.self, forKey: .pl_balance)
        InTime = try values.decodeIfPresent(String.self, forKey: .InTime)
        OutTime = try values.decodeIfPresent(String.self, forKey: .OutTime)
        BDay = try values.decodeIfPresent(String.self, forKey: .BDay)
        notification_count = try values.decodeIfPresent(Int.self, forKey: .notification_count)
        notice_active = try values.decodeIfPresent(Bool.self, forKey: .notice_active)
        notice_title = try values.decodeIfPresent(String.self, forKey: .notice_title)
        notice_message = try values.decodeIfPresent(String.self, forKey: .notice_message)

    }
}

