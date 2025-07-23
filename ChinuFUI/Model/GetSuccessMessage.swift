//
//  GetSuccessMessage.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 06/05/25.
//

import Foundation
struct GetSuccessMessage : Codable {
    let status : Bool?
    let message : String?
    let data : [String]?
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
        data = try values.decodeIfPresent([String].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}
struct GetSuccessMessageBook: Codable {
    let status: Bool?
    let message: String?
    let data: [String]?
    let error: ErrorValue?  

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
        case error
    }
}

enum ErrorValue: Codable {
    case messages([String])
    case dictionary([String: String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let messages = try? container.decode([String].self) {
            self = .messages(messages)
        } else if let dict = try? container.decode([String: String].self) {
            self = .dictionary(dict)
        } else {
            throw DecodingError.typeMismatch(ErrorValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported error format"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .messages(let messages):
            try container.encode(messages)
        case .dictionary(let dict):
            try container.encode(dict)
        }
    }

    /// ✅ Optional: Extract 1st message
    var firstErrorMessage: String? {
        switch self {
        case .messages(let messages):
            return messages.first
        case .dictionary(let dict):
            return dict.values.first
        }
    }
}
