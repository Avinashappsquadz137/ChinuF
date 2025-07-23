//
//  ExistGuruListModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 31/05/25.
//
import Foundation
struct ExistGuruListModel : Codable {
    let status : Bool?
    let message : String?
    let data : [ExistGuruList]?
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
        data = try values.decodeIfPresent([ExistGuruList].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct ExistGuruList : Codable {
    let guru_name : String?
    let guru_ID : Int?

    enum CodingKeys: String, CodingKey {

        case guru_name = "guru_name"
        case guru_ID = "guru_ID"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        guru_name = try values.decodeIfPresent(String.self, forKey: .guru_name)
        guru_ID = try values.decodeIfPresent(Int.self, forKey: .guru_ID)
    }

}

