//
//  BookingPromoModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 27/06/25.
//
import Foundation
struct BookingPromoModel : Codable {
    let status : Bool?
    let message : String?
    let data : [BookingPromo]?
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
        data = try values.decodeIfPresent([BookingPromo].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct BookingPromo : Codable {
    let id : Int?
    let type_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case type_name = "Type_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        type_name = try values.decodeIfPresent(String.self, forKey: .type_name)
    }

}

