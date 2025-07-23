//
//  KathaCategoryModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/05/25.
//

import Foundation
struct KathaCategoryModel : Codable {
    let status : Bool?
    let message : String?
    let data : [KathaCategory]?
    let assign_booking_detail : [Assign_booking_detail]?
    let error : [String]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
        case assign_booking_detail = "assign_booking_detail"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([KathaCategory].self, forKey: .data)
        assign_booking_detail = try values.decodeIfPresent([Assign_booking_detail].self, forKey: .assign_booking_detail)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct KathaCategory : Codable {
    let iD : Int?
    let kathaName : String?
    let gST : String?

    enum CodingKeys: String, CodingKey {

        case iD = "ID"
        case kathaName = "KathaName"
        case gST = "GST"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        iD = try values.decodeIfPresent(Int.self, forKey: .iD)
        kathaName = try values.decodeIfPresent(String.self, forKey: .kathaName)
        gST = try values.decodeIfPresent(String.self, forKey: .gST)
    }

}

struct Assign_booking_detail : Codable {
    let empCode : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case empCode = "EmpCode"
        case name = "Name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}
