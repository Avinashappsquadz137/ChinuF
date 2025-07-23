//
//  ChannelListModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 31/05/25.
//

import Foundation

struct ChannelListModel : Codable {
    let status : Bool?
    let message : String?
    let data : [ChannelList]?
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
        data = try values.decodeIfPresent([ChannelList].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct ChannelList : Codable {
    let sno : Int?
    let channelName : String?
    let channel_thumbnail : String?

    enum CodingKeys: String, CodingKey {

        case sno = "Sno"
        case channelName = "ChannelName"
        case channel_thumbnail = "channel_thumbnail"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sno = try values.decodeIfPresent(Int.self, forKey: .sno)
        channelName = try values.decodeIfPresent(String.self, forKey: .channelName)
        channel_thumbnail = try values.decodeIfPresent(String.self, forKey: .channel_thumbnail)
    }

}

