//
//  LeaveReport.swift
//  SanskarEP
//
//  Created by Warln on 14/01/22.
//

import Foundation



// MARK: - Datum
struct Full: Codable {
    let empReqNo, lduration, leaveFrom, leaveTo: String
    let hodApproval: String

    enum CodingKeys: String, CodingKey {
        case empReqNo = "Emp_Req_No"
        case lduration = "Lduration"
        case leaveFrom = "Leave_From"
        case leaveTo = "Leave_to"
        case hodApproval = "HOD_Approval"
    }
}

struct Half: Codable {
    let id, rDate, status: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case rDate = "RDate"
        case status = "Status"
    }
}

struct Tour: Codable {
    let id, fromDate, toDate, status: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case fromDate = "from_date"
        case toDate = "to_date"
        case status = "Status"
    }
}



// MARK: - Datum
struct EmpLData: Codable {
    let status: Bool
    let message: String
    let data: [EmpList]
    let error: [String]
}

// MARK: - Datum
struct EmpList: Codable {
    let name, empCode: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case empCode = "EmpCode"
        case status = "Status"
    }
}
