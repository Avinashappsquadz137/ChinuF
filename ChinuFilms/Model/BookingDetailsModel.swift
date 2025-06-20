//
//  BookingDetailsModel.swift
//  SanskarEP
//
//  Created by Surya on 14/02/25.
//

import Foundation

struct BookingDetailsModel : Codable {
    let status : Bool?
    let message : String?
    let data : [BookingDetails]?
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
        data = try values.decodeIfPresent([BookingDetails].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}
struct BookingDetails: Codable {
    let ChannelName: String?
    let KathafromDate: String?
    let Kathadate: String?
    let KathaTiming: String?
    let Amount: String?
    let Venue: String?
    let Name: String?
    let Katha_id: String?

    enum CodingKeys: String, CodingKey {
        case ChannelName = "ChannelName"
        case KathafromDate = "Katha_from_Date"
        case Kathadate = "Katha_date"
        case KathaTiming = "KathaTiming"
        case Amount = "Amount"
        case Venue = "Venue"
        case Name = "Name"
        case Katha_id = "Katha_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
    
        ChannelName = try values.decodeIfPresent(String.self, forKey: .ChannelName)
        KathafromDate = try values.decodeIfPresent(String.self, forKey: .KathafromDate)
        Kathadate = try values.decodeIfPresent(String.self, forKey: .Kathadate)
        KathaTiming = try values.decodeIfPresent(String.self, forKey: .KathaTiming)
        Amount = try values.decodeIfPresent(String.self, forKey: .Amount)
        Venue = try values.decodeIfPresent(String.self, forKey: .Venue)
        Name = try values.decodeIfPresent(String.self, forKey: .Name)
        Katha_id = try values.decodeIfPresent(String.self, forKey: .Katha_id)
    }

}
