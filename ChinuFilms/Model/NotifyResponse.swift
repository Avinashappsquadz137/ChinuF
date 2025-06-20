//
//  NotifyResponse.swift
//  SanskarEP
//
//  Created by Warln on 04/04/22.
//

//import Foundation
//
//struct NotifyResponse: Decodable {
//    let data: [Notify]
//}
//
//struct Notify: Decodable {
//    let id: String
//    let notification_title: String
//    let notification_content: String
//    let notification_thumbnail: String
//    let from_EmpCode: String
//    let req_id: String
//    let note_type: String
//    let status: String
//}

import Foundation
struct NotifyResponse : Codable {
    let status : Bool?
    let message : String?
    let data : [Notify]?
    let error : String?

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
        data = try values.decodeIfPresent([Notify].self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}


struct Notify : Codable {
    let id : String?
    let notification_title : String?
    let notification_content : String?
    let device_type : String?
    let notification_type : String?
    let notification_thumbnail : String?
    let from_EmpCode : String?
    let empCode : String?
    let req_id : Int?
    let note_type : String?
    let creation_date : String?
    let inOrOut : String?
    let status : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case notification_title = "notification_title"
        case notification_content = "notification_content"
        case device_type = "device_type"
        case notification_type = "notification_type"
        case notification_thumbnail = "notification_thumbnail"
        case from_EmpCode = "from_EmpCode"
        case empCode = "EmpCode"
        case req_id = "req_id"
        case note_type = "note_type"
        case creation_date = "creation_date"
        case inOrOut = "inOrOut"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        notification_title = try values.decodeIfPresent(String.self, forKey: .notification_title)
        notification_content = try values.decodeIfPresent(String.self, forKey: .notification_content)
        device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
        notification_type = try values.decodeIfPresent(String.self, forKey: .notification_type)
        notification_thumbnail = try values.decodeIfPresent(String.self, forKey: .notification_thumbnail)
        from_EmpCode = try values.decodeIfPresent(String.self, forKey: .from_EmpCode)
        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
        req_id = try values.decodeIfPresent(Int.self, forKey: .req_id)
        note_type = try values.decodeIfPresent(String.self, forKey: .note_type)
        creation_date = try values.decodeIfPresent(String.self, forKey: .creation_date)
        inOrOut = try values.decodeIfPresent(String.self, forKey: .inOrOut)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }

}


//struct Notify : Codable {
//    let id : String?
//    let notification_title : String?
//    let notification_content : String?
//    let device_type : String?
//    let notification_type : String?
//    let notification_thumbnail : String?
//    let from_EmpCode : String?
//    let empCode : String?
//    let req_id : String?
//    let note_type : String?
//    let creation_date : String?
//    let status : Bool?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case notification_title = "notification_title"
//        case notification_content = "notification_content"
//        case device_type = "device_type"
//        case notification_type = "notification_type"
//        case notification_thumbnail = "notification_thumbnail"
//        case from_EmpCode = "from_EmpCode"
//        case empCode = "EmpCode"
//        case req_id = "req_id"
//        case note_type = "note_type"
//        case creation_date = "creation_date"
//        case status = "status"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(String.self, forKey: .id)
//        notification_title = try values.decodeIfPresent(String.self, forKey: .notification_title)
//        notification_content = try values.decodeIfPresent(String.self, forKey: .notification_content)
//        device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
//        notification_type = try values.decodeIfPresent(String.self, forKey: .notification_type)
//        notification_thumbnail = try values.decodeIfPresent(String.self, forKey: .notification_thumbnail)
//        from_EmpCode = try values.decodeIfPresent(String.self, forKey: .from_EmpCode)
//        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
//        req_id = try values.decodeIfPresent(String.self, forKey: .req_id)
//        note_type = try values.decodeIfPresent(String.self, forKey: .note_type)
//        creation_date = try values.decodeIfPresent(String.self, forKey: .creation_date)
//        status = try values.decodeIfPresent(Bool.self, forKey: .status)
//    }
//
//}
