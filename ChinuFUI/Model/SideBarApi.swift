//
//  SideBarApi.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 26/04/25.
//

import Foundation

struct SideBarApi : Codable {
    let status : Bool?
    let message : String?
    let data : [SideBar]?
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
        data = try values.decodeIfPresent([SideBar].self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }
    
}

struct SideBar : Codable , Identifiable{
    let name : String?
    let id : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case id = "id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
}
