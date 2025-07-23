//
//  getDateKeyModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 11/07/25.
//
import Foundation
struct GetDateKeyModel : Codable {
    let status : Bool?
    let message : String?
    let data : [GetDateKey]?
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
        data = try values.decodeIfPresent([GetDateKey].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}
struct GetDateKey : Codable {
    let key : Int?
    let date_range : String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case date_range = "date_range"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decodeIfPresent(Int.self, forKey: .key)
        date_range = try values.decodeIfPresent(String.self, forKey: .date_range)
    }

}

