//
//  NotificationMode.swift
//  SanskarEP
//
//  Created by Vaibhav on 24/02/25.
//

import Foundation

struct NotificationModel : Codable {
    let aps : Aps?
    let message : String?
    let data : NotificationData?
    let type : Int?

    enum CodingKeys: String, CodingKey {

        case aps = "aps"
        case message = "message"
        case data = "data"
        case type = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aps = try values.decodeIfPresent(Aps.self, forKey: .aps)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(NotificationData.self, forKey: .data)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
    }

}

struct Alert : Codable {
    let title : String?
    let subtitle : String?
    let actios : String?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case subtitle = "subtitle"
        case actios = "action-loc-key"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
        actios = try values.decodeIfPresent(String.self, forKey: .actios)
    }

}
struct NotificationData : Codable {
    let notification_title : String?
    let notification_type : Int?
    let img : String?
    let notification_content : String?
    let req_id : Int?
    let reason : String?

    enum CodingKeys: String, CodingKey {

        case notification_title = "notification_title"
        case notification_type = "notification_type"
        case img = "img"
        case notification_content = "notification_content"
        case req_id = "req_id"
        case reason = "reason"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notification_title = try values.decodeIfPresent(String.self, forKey: .notification_title)
        notification_type = try values.decodeIfPresent(Int.self, forKey: .notification_type)
        img = try values.decodeIfPresent(String.self, forKey: .img)
        notification_content = try values.decodeIfPresent(String.self, forKey: .notification_content)
        req_id = try values.decodeIfPresent(Int.self, forKey: .req_id)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
    }

}
struct Aps : Codable {
    let sound : String?
    let badge : Int?
    let alert : Alert?

    enum CodingKeys: String, CodingKey {

        case sound = "sound"
        case badge = "badge"
        case alert = "alert"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sound = try values.decodeIfPresent(String.self, forKey: .sound)
        badge = try values.decodeIfPresent(Int.self, forKey: .badge)
        alert = try values.decodeIfPresent(Alert.self, forKey: .alert)
    }

}
