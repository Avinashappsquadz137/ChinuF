//
//  NotificationPushHistory.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 01/07/25.
//
import Foundation

struct NotificationPushHistory : Codable {
    let status : Bool?
    let message : String?
    let data : [PushHistory]?
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
        data = try values.decodeIfPresent([PushHistory].self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}
struct PushHistory : Codable , Identifiable {
    var id : String?
    var notification_title : String?
    var notification_content : String?
    var device_type : String?
    var notification_type : String?
    var notification_thumbnail : String?
    var from_EmpCode : String?
    var empCode : String?
    var req_id : Int?
    var note_type : String?
    var creation_date : String?
    var inOrOut : String?
    var status : Bool?

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
    init(
            id: String? = nil,
            notification_title: String? = nil,
            notification_content: String? = nil,
            device_type: String? = nil,
            notification_type: String? = nil,
            notification_thumbnail: String? = nil,
            from_EmpCode: String? = nil,
            empCode: String? = nil,
            req_id: Int? = nil,
            note_type: String? = nil,
            creation_date: String? = nil,
            inOrOut: String? = nil,
            status: Bool? = nil
        ) {
            self.id = id
            self.notification_title = notification_title
            self.notification_content = notification_content
            self.device_type = device_type
            self.notification_type = notification_type
            self.notification_thumbnail = notification_thumbnail
            self.from_EmpCode = from_EmpCode
            self.empCode = empCode
            self.req_id = req_id
            self.note_type = note_type
            self.creation_date = creation_date
            self.inOrOut = inOrOut
            self.status = status
        }
}

// MARK: - GetFloorList
struct GetFloorList: Codable {
    let status: Bool
    let message: String
    let data: [Datum]
    let error: String?
}

// MARK: - Datum
struct Datum: Codable {
    let name, id: String
}
