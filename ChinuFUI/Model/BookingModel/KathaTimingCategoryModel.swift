//
//  KathaTimingCategoryModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 31/05/25.
//
import Foundation

struct KathaTimingCategoryModel : Codable {
    let status : Bool?
    let message : String?
    let data : [KathaTimingCategory]?
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
        data = try values.decodeIfPresent([KathaTimingCategory].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct KathaTimingCategory : Codable {
    let sno : String?
    let slotName : String?
    let slotTiming : String?

    enum CodingKeys: String, CodingKey {

        case sno = "Sno"
        case slotName = "SlotName"
        case slotTiming = "SlotTiming"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sno = try values.decodeIfPresent(String.self, forKey: .sno)
        slotName = try values.decodeIfPresent(String.self, forKey: .slotName)
        slotTiming = try values.decodeIfPresent(String.self, forKey: .slotTiming)
    }

}

