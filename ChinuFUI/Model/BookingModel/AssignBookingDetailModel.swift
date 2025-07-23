//
//  AssignBookingDetailModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 14/07/25.
//
import Foundation
struct AssignBookingDetailModel : Codable {
    let status : Bool?
    let message : String?
    let data : [AssignBookingDetail]?
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
        data = try values.decodeIfPresent([AssignBookingDetail].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct AssignBookingDetail : Codable , Identifiable  , Equatable{
    var id: String { empCode ?? UUID().uuidString }
    let name : String?
    let empCode : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case empCode = "EmpCode"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
    }
    static func == (lhs: AssignBookingDetail, rhs: AssignBookingDetail) -> Bool {
            return lhs.empCode == rhs.empCode
        }
}

