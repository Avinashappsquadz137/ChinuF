//
//  UserModel.swift
//  SanskarEP
//
//  Created by Warln on 10/01/22.
//

import Foundation
import UIKit

struct dataContent{
    static var isAudio : String{
        return "4"
    }
    static var isWebSeries : String{
        return "2"
    }
}

struct currentUser {
    static var EmpCode: String {
        return UserDefaults.standard.value(forKey: "EmpCode") as? String ?? ""
    }
    
    static var Name: String {
        return UserDefaults.standard.value(forKey: "Name") as? String ?? ""
    }
    
    static var BDay: String {
        return UserDefaults.standard.value(forKey: "BDay") as? String ?? ""
    }
    static var today_intime:String {
        return UserDefaults.standard.value(forKey: "today_intime") as? String ?? ""
    }
    
    static var EmailID: String {
        return UserDefaults.standard.value(forKey: "EmailID") as? String ?? ""
    }
    
    static var JDate: String {
        return UserDefaults.standard.value(forKey: "JDate") as? String ?? ""
    }
    
    static var Dept: String {
        return UserDefaults.standard.value(forKey: "Dept") as? String ?? ""
    }
    
    static var device_type: String {
        return UserDefaults.standard.value(forKey: "device_type") as? String ?? "2"
    }
    
    static var address: String {
        return UserDefaults.standard.value(forKey: "address") as? String ?? ""
    }
    
    static var CntNo: String {
        return UserDefaults.standard.value(forKey: "CntNo") as? String ?? ""
    }
    
    static var Code: String {
        return UserDefaults.standard.value(forKey: "Code") as? String ?? ""
    }
    
    static var Designation: String {
        return UserDefaults.standard.value(forKey: "Designation") as? String ?? ""
    }
    
    static var ReportTo: String {
        return UserDefaults.standard.value(forKey: "ReportTo") as? String ?? ""
    }
    
    static var PImg: String {
        return UserDefaults.standard.value(forKey: "PImg") as? String ?? ""
    }
    
    static var AadharNo: String {
        return UserDefaults.standard.value(forKey: "AadharNo") as? String ?? ""
    }
    
    static var PanNo: String {
        return UserDefaults.standard.value(forKey: "PanNo") as? String ?? ""
    }
    
    static var BloodGroup: String {
        return UserDefaults.standard.value(forKey: "BloodGroup") as? String ?? ""
    }
    
    static var PolicyAmount: String {
        return UserDefaults.standard.value(forKey: "PolicyAmount") as? String ?? ""
    }
    
    static var pl_balance: String {
        return UserDefaults.standard.value(forKey: "pl_balance") as? String ?? ""
    }
    static var PolicyNumber: String {
        return UserDefaults.standard.value(forKey: "PolicyNumber") as? String ?? ""
    }
    static var PolicyValidity: String {
        return UserDefaults.standard.value(forKey: "PolicyValidity") as? String ?? ""
    }
    static var booking_role_id: String {
        return UserDefaults.standard.value(forKey: "booking_role_id") as? String ?? ""
    }
    static var DeviceId:String{
        return UIDevice().identifierForVendor?.uuidString ?? ""
    }
    static var deviceModel:String{
        return "\(UIDevice().type)"
    }
    
    static func saveData(Login_Data: NSDictionary) {
                
        let user_data = Login_Data.dictValue("data")
        
        UserDefaults.standard.setValue(user_data.validatedValue("EmpCode"), forKey: "EmpCode")
        UserDefaults.standard.setValue(user_data.validatedValue("Name"), forKey: "Name")
        UserDefaults.standard.setValue(user_data.validatedValue("BDay"), forKey: "BDay")
        UserDefaults.standard.setValue(user_data.validatedValue("EmailID"), forKey: "EmailID")
        UserDefaults.standard.setValue(user_data.validatedValue("JDate"), forKey: "JDate")
        UserDefaults.standard.setValue(user_data.validatedValue("Dept"), forKey: "Dept")
        UserDefaults.standard.setValue(user_data.validatedValue("address"), forKey: "address")
        UserDefaults.standard.setValue(user_data.validatedValue("CntNo"), forKey: "CntNo")
        UserDefaults.standard.setValue(user_data.validatedValue("Code"), forKey: "Code")
        UserDefaults.standard.setValue(user_data.validatedValue("Designation"), forKey: "Designation")
        UserDefaults.standard.setValue(user_data.validatedValue("ReportTo"), forKey: "ReportTo")
        UserDefaults.standard.setValue(user_data.validatedValue("PImg"), forKey: "PImg")
        UserDefaults.standard.setValue(user_data.validatedValue("AadharNo"), forKey: "AadharNo")
        UserDefaults.standard.setValue(user_data.validatedValue("PanNo"), forKey: "PanNo")
        UserDefaults.standard.setValue(user_data.validatedValue("BloodGroup"), forKey: "BloodGroup")
        UserDefaults.standard.setValue(user_data.validatedValue("PolicyAmount"), forKey: "PolicyAmount")
        UserDefaults.standard.setValue(user_data.validatedValue("pl_balance"), forKey: "pl_balance")
        UserDefaults.standard.setValue(user_data.validatedValue("today_intime"), forKey: "today_intime")
        UserDefaults.standard.setValue(user_data.validatedValue("PolicyNumber"), forKey: "PolicyNumber")
        UserDefaults.standard.setValue(user_data.validatedValue("PolicyValidity"), forKey: "PolicyValidity")
        UserDefaults.standard.setValue(user_data.validatedValue("booking_role_id"), forKey: "booking_role_id")
    }
    
    static func saveValue(value:String,key:String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    
    static func removeData() {
        UserDefaults.standard.removeObject(forKey: "EmpCode")
    }
}


//MARK:- DICTIONARY VALIDATION
extension Dictionary {
    
    func validatedValue (_ key:Key) -> String{
        if let object = self[key] as AnyObject?{
            if object is NSNull{
                // if key not exist or key contain NSNull
                return ""
            }
            else if ((object as? String == "null") || (object as? String == "<null>") || (object as? String == "(null)") || (object as? String == "nil") || (object as? String == "Nil")) {
                //logInfo("null string")
                return ""
            }else{
                return "\(object)"
            }
        }else{
            return ""
        }
    }
    
    func dictValue(_ key:Key) -> Dictionary<String,Any>{
        if let object = self[key] as AnyObject?{
            if object is NSNull{
                return [:]
            }
            else if object.count == 0{
                return [:]
            }else{
                return object as? Dictionary<String,Any> ?? [:]
            }
        }else{
            return [:]
        }
    }
    
    func ArrayDict (_ key:Key) -> Array<Dictionary<String,Any>>{
        if let object = self[key] as AnyObject?{
            if object is NSNull{
                // if key not exist or key contain NSNull
                return []
            }
            else if object.count == 0{
                //logInfo("null string")
                return []
            }else{
                return object as? Array<Dictionary<String,Any>> ?? []
            }
        }else{
            return []
        }
    }
}


extension NSDictionary{
    func validatedValue (_ key:Key) -> String{
        if let object = self[key] as AnyObject?{
            if object is NSNull{
                // if key not exist or key contain NSNull
                return ""
            }
            else if ((object as? String == "null") || (object as? String == "<null>") || (object as? String == "(null)") || (object as? String == "nil") || (object as? String == "Nil")) {
                //logInfo("null string")
                return ""
            }else{
                return "\(object)"
            }
        }else{
            return ""
        }
    }
    
    
    func dictValue(_ key:Key) -> Dictionary<String,Any>{
        if let object = self[key] as AnyObject?{
            if object is NSNull{
                return [:]
            }
            else if object.count == 0{
                return [:]
            }else{
                return object as? Dictionary<String,Any> ?? [:]
            }
        }else{
            return [:]
        }
    }
    
    
    
    func ArrayofDict (_ key:Key) -> Array<Dictionary<String,Any>>{
        if let object = self[key] as AnyObject?{
            if object is NSNull{
                // if key not exist or key contain NSNull
                return []
            }
            else if object.count == 0{
                //logInfo("null string")
                return []
            }else{
                return object as? Array<Dictionary<String,Any>> ?? []
            }
        }else{
            return []
        }
    }
    
}

