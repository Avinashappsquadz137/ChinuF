//
//  OTPModel.swift
//  SanskarEP
//
//  Created by Warln on 17/01/22.
//

import Foundation

// MARK: - Welcome
struct OTPModel: Codable {
    let status: Bool
    let message: String
    let data: Reset
}

// MARK: - DataClass
struct Reset: Codable {
    let empCode, name, cntNo, emailID: String
    let otp: Int

    enum CodingKeys: String, CodingKey {
        case empCode = "EmpCode"
        case name = "Name"
        case cntNo = "CntNo"
        case emailID = "EmailID"
        case otp
    }
}
