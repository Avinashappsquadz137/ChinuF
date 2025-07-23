//
//  LoginModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 08/07/25.
//
import Foundation

struct LoginModel : Codable {
    let status : Bool?
    let message : String?
    let data : Login?
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
        data = try values.decodeIfPresent(Login.self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }
    

}


struct Login : Codable {
    let empCode : String?
    let name : String?
    let bDay : String?
    let emailID : String?
    let jDate : String?
    let dept : String?
    let device_type : String?
    let device_model : String?
    let device_id : String?
    let address : String?
    let cntNo : String?
    let code : String?
    let designation : String?
    let reportTo : String?
    let pImg : String?
    let aadharNo : String?
    let panNo : String?
    let bloodGroup : String?
    let pin : String?
    let policyNumber : String?
    let policyValidity : String?
    let policyAmount : String?
    let imageApproved : String?
    let pImg1 : String?
    let booking_role_id : Int?
    let pl_balance : String?
    let today_intime : String?

    enum CodingKeys: String, CodingKey {

        case empCode = "EmpCode"
        case name = "Name"
        case bDay = "BDay"
        case emailID = "EmailID"
        case jDate = "JDate"
        case dept = "Dept"
        case device_type = "device_type"
        case device_model = "device_model"
        case device_id = "device_id"
        case address = "address"
        case cntNo = "CntNo"
        case code = "Code"
        case designation = "Designation"
        case reportTo = "ReportTo"
        case pImg = "PImg"
        case aadharNo = "AadharNo"
        case panNo = "PanNo"
        case bloodGroup = "BloodGroup"
        case pin = "pin"
        case policyNumber = "PolicyNumber"
        case policyValidity = "PolicyValidity"
        case policyAmount = "PolicyAmount"
        case imageApproved = "ImageApproved"
        case pImg1 = "PImg1"
        case booking_role_id = "booking_role_id"
        case pl_balance = "pl_balance"
        case today_intime = "today_intime"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        bDay = try values.decodeIfPresent(String.self, forKey: .bDay)
        emailID = try values.decodeIfPresent(String.self, forKey: .emailID)
        jDate = try values.decodeIfPresent(String.self, forKey: .jDate)
        dept = try values.decodeIfPresent(String.self, forKey: .dept)
        device_type = try values.decodeIfPresent(String.self, forKey: .device_type)
        device_model = try values.decodeIfPresent(String.self, forKey: .device_model)
        device_id = try values.decodeIfPresent(String.self, forKey: .device_id)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        cntNo = try values.decodeIfPresent(String.self, forKey: .cntNo)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        designation = try values.decodeIfPresent(String.self, forKey: .designation)
        reportTo = try values.decodeIfPresent(String.self, forKey: .reportTo)
        pImg = try values.decodeIfPresent(String.self, forKey: .pImg)
        aadharNo = try values.decodeIfPresent(String.self, forKey: .aadharNo)
        panNo = try values.decodeIfPresent(String.self, forKey: .panNo)
        bloodGroup = try values.decodeIfPresent(String.self, forKey: .bloodGroup)
        pin = try values.decodeIfPresent(String.self, forKey: .pin)
        policyNumber = try values.decodeIfPresent(String.self, forKey: .policyNumber)
        policyValidity = try values.decodeIfPresent(String.self, forKey: .policyValidity)
        policyAmount = try values.decodeIfPresent(String.self, forKey: .policyAmount)
        imageApproved = try values.decodeIfPresent(String.self, forKey: .imageApproved)
        pImg1 = try values.decodeIfPresent(String.self, forKey: .pImg1)
        booking_role_id = try values.decodeIfPresent(Int.self, forKey: .booking_role_id)
        pl_balance = try values.decodeIfPresent(String.self, forKey: .pl_balance)
        today_intime = try values.decodeIfPresent(String.self, forKey: .today_intime)
    }

}
