//
//  AttandanceDetail.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 29/04/25.
//

import Foundation

struct AttandanceDetail : Codable {
    let status : Bool?
    let message : String?
    let name : String?
    let data : [DetailOfEMP]?
    let error : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case message = "message"
        case name = "name"
        case data = "data"
        case error = "error"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        data = try values.decodeIfPresent([DetailOfEMP].self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }
    
}
struct DetailOfEMP : Codable {
    let month : String?
    let h : Int?
    let f : Int?
    let tour: Int?
    let wfh: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case month = "month"
        case h = "H"
        case f = "F"
        case tour = "Tour"
        case wfh = "WFH"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        month = try values.decodeIfPresent(String.self, forKey: .month)
        h = try values.decodeIfPresent(Int.self, forKey: .h)
        f = try values.decodeIfPresent(Int.self, forKey: .f)
        tour = try values.decodeIfPresent(Int.self, forKey: .tour)
        wfh = try values.decodeIfPresent(Int.self, forKey: .wfh)    
    }
    
}
