//
//  SantData.swift
//  SanskarEP
//
//  Created by Warln on 09/03/22.
//

import Foundation

struct SantData: Codable {
    let santName: [SantName]

    enum CodingKeys: String, CodingKey {
        case santName = "SantName"
    }
}

// MARK: - SantName
struct SantName: Codable {
    let sc, sn: String

    enum CodingKeys: String, CodingKey {
        case sc = "SC"
        case sn = "SN"
    }
}

struct StData: Codable {
    let status: Bool
    let message: String
    let data: [StValue]
    let error: [String]
}

// MARK: - Datum
struct StValue: Codable {
    let requestType, reason: String
    let status: String?
    let reqDate: String

    enum CodingKeys: String, CodingKey {
        case requestType = "RequestType"
        case reason, status
        case reqDate = "req_date"
    }
}

struct AdvanceD: Codable {
    let status: Bool
    let message: String
    let data: [AdvanceV]
    let error: [String]
}

// MARK: - Datum
struct AdvanceV: Codable {
    let requestedAmount, approvedAmount, reason, repaymentDuration: String
    let reqDate, status: String

    enum CodingKeys: String, CodingKey {
        case requestedAmount = "RequestedAmount"
        case approvedAmount = "ApprovedAmount"
        case reason = "Reason"
        case repaymentDuration = "RepaymentDuration"
        case reqDate = "req_date"
        case status = "Status"
    }
}

struct ROData: Codable {
    let status: Bool
    let message: String
    var roDetails: [RODetail]

    enum CodingKeys: String, CodingKey {
        case status, message
        case roDetails = "RODetails"
    }
}

struct RODetail: Codable {
    let bookingNo, bookingDt, channel, progTyp: String
    let santCode, santName, startDt, endDt: String
    let startTime, endTime, kathaLoct, bookingAmt: String
    let inclGst, status, createdBy, empName: String

    enum CodingKeys: String, CodingKey {
        case bookingNo = "booking_no"
        case bookingDt = "booking_dt"
        case channel
        case progTyp = "prog_typ"
        case santCode = "sant_code"
        case santName = "sant_name"
        case startDt = "start_dt"
        case endDt = "end_dt"
        case startTime = "start_time"
        case endTime = "end_time"
        case kathaLoct = "katha_loct"
        case bookingAmt = "booking_amt"
        case inclGst = "incl_gst"
        case status
        case createdBy = "created_by"
        case empName = "emp_name"
    }
}

