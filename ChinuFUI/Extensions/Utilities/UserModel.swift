//
//  UserModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 26/04/25.
//

import Foundation
import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    // MARK: - Keys
    private enum Keys {
        static let empCode = "EmpCode"
        static let name = "Name"
        static let birthday = "BDay"
        static let todayInTime = "today_intime"
        static let emailID = "EmailID"
        static let joinDate = "JDate"
        static let department = "Dept"
        static let deviceType = "device_type"
        static let address = "address"
        static let contactNo = "CntNo"
        static let code = "Code"
        static let designation = "Designation"
        static let reportTo = "ReportTo"
        static let profileImage = "PImg"
        static let aadharNo = "AadharNo"
        static let panNo = "PanNo"
        static let bloodGroup = "BloodGroup"
        static let policyAmount = "PolicyAmount"
        static let plBalance = "pl_balance"
        static let policyNumber = "PolicyNumber"
        static let policyValidity = "PolicyValidity"
        static let bookingRoleID = "booking_role_id"
        static let isLoggedInKey = "isLoggedIn"
        static var kDeviceToken  = ""
        static let deviceModel = "DeviceModel"
        static let savedDeviceModel = "SavedDeviceModel"
        static let fCMToken = "FCMToken"
    }
    
    // MARK: - Device ID
    static var deviceId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    static func getSavedDeviceModel() -> String {
        UserDefaults.standard.string(forKey: Keys.savedDeviceModel) ?? deviceModel
    }
    // MARK: - Getter Methods
    static func getEmpCode() -> String {
        UserDefaults.standard.string(forKey: Keys.empCode) ?? "" //493
    }

    static func getName() -> String {
        UserDefaults.standard.string(forKey: Keys.name) ?? ""
    }
    
    static func getBirthday() -> String {
        UserDefaults.standard.string(forKey: Keys.birthday) ?? ""
    }
    
    static func getTodayInTime() -> String {
        UserDefaults.standard.string(forKey: Keys.todayInTime) ?? ""
    }
    
    static func getEmailID() -> String {
        UserDefaults.standard.string(forKey: Keys.emailID) ?? ""
    }
    
    static func getJoinDate() -> String {
        UserDefaults.standard.string(forKey: Keys.joinDate) ?? ""
    }
    
    static func getDepartment() -> String {
        UserDefaults.standard.string(forKey: Keys.department) ?? ""
    }
    
    static func getDeviceType() -> String {
        UserDefaults.standard.string(forKey: Keys.deviceType) ?? "2"
    }
    
    static func getAddress() -> String {
        UserDefaults.standard.string(forKey: Keys.address) ?? ""
    }
    
    static func getContactNo() -> String {
        UserDefaults.standard.string(forKey: Keys.contactNo) ?? ""
    }
    
    static func getCode() -> String {
        UserDefaults.standard.string(forKey: Keys.code) ?? ""
    }
    
    static func getDesignation() -> String {
        UserDefaults.standard.string(forKey: Keys.designation) ?? ""
    }
    
    static func getReportTo() -> String {
        UserDefaults.standard.string(forKey: Keys.reportTo) ?? ""
    }
    
    static func getProfileImage() -> String {
        UserDefaults.standard.string(forKey: Keys.profileImage) ?? ""
    }
    
    static func getAadharNo() -> String {
        UserDefaults.standard.string(forKey: Keys.aadharNo) ?? ""
    }
    
    static func getPanNo() -> String {
        UserDefaults.standard.string(forKey: Keys.panNo) ?? ""
    }
    
    static func getBloodGroup() -> String {
        UserDefaults.standard.string(forKey: Keys.bloodGroup) ?? ""
    }
    
    static func getPolicyAmount() -> String {
        UserDefaults.standard.string(forKey: Keys.policyAmount) ?? "150000"
    }
    
    static func getPlBalance() -> String {
        UserDefaults.standard.string(forKey: Keys.plBalance) ?? ""
    }
    
    static func getPolicyNumber() -> String {
        UserDefaults.standard.string(forKey: Keys.policyNumber) ?? "789456"
    }
    
    static func getPolicyValidity() -> String {
        UserDefaults.standard.string(forKey: Keys.policyValidity) ?? "2026"
    }
    
    static func getBookingRoleID() -> String {
        UserDefaults.standard.string(forKey: Keys.bookingRoleID) ?? ""
    }
    static func getFCMToken() -> String {
        UserDefaults.standard.string(forKey: Keys.fCMToken) ?? ""
    }
    static func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isLoggedInKey)
    }
 
    
    // MARK: - Setter Methods
    static func setEmpCode(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.empCode)
    }

    static func setName(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.name)
    }
    
    static func setBirthday(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.birthday)
    }
    
    static func setTodayInTime(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.todayInTime)
    }
    
    static func setEmailID(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.emailID)
    }
    
    static func setJoinDate(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.joinDate)
    }
    
    static func setDepartment(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.department)
    }
    
    static func setDeviceType(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.deviceType)
    }
    
    static func setAddress(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.address)
    }
    
    static func setContactNo(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.contactNo)
    }
    
    static func setCode(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.code)
    }
    
    static func setDesignation(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.designation)
    }
    
    static func setReportTo(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.reportTo)
    }
    
    static func setProfileImage(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.profileImage)
    }
    
    static func setAadharNo(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.aadharNo)
    }
    
    static func setPanNo(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.panNo)
    }
    
    static func setBloodGroup(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.bloodGroup)
    }
    
    static func setPolicyAmount(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.policyAmount)
    }
    
    static func setPlBalance(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.plBalance)
    }
    
    static func setPolicyNumber(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.policyNumber)
    }
    
    static func setPolicyValidity(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.policyValidity)
    }
    
    static func setBookingRoleID(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.bookingRoleID)
    }
    static func setLoggedIn(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.isLoggedInKey)
    }
    static func setFCMToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: Keys.fCMToken)
    }
    static func setSavedDeviceModel(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.savedDeviceModel)
    }

    // MARK: - Save All Login Data
    static func saveUserData(from user: Login) {
        setEmpCode(user.empCode ?? "")
        setName(user.name ?? "")
        setBirthday(user.bDay ?? "")
        setEmailID(user.emailID ?? "")
        setJoinDate(user.jDate ?? "")
        setDepartment(user.dept ?? "")
        setDeviceType(user.device_type ?? "")
        setSavedDeviceModel(user.device_model ?? "")
        setAddress(user.address ?? "")
        setContactNo(user.cntNo ?? "")
        setCode(user.code ?? "")
        setDesignation(user.designation ?? "")
        setReportTo(user.reportTo ?? "")
        setProfileImage(user.pImg ?? "")
        setAadharNo(user.aadharNo ?? "")
        setPanNo(user.panNo ?? "")
        setBloodGroup(user.bloodGroup ?? "")
        setPolicyNumber(user.policyNumber ?? "")
        setPolicyValidity(user.policyValidity ?? "")
        setPolicyAmount(user.policyAmount ?? "")
        setPlBalance(user.pl_balance ?? "")
        setTodayInTime(user.today_intime ?? "")
        if let roleID = user.booking_role_id {
            setBookingRoleID(String(roleID))
        } else {
            setBookingRoleID("")
        }
    }


    // MARK: - Helper Methods
    static func removeUserData() {
        UserDefaults.standard.removeObject(forKey: Keys.empCode)
        UserDefaults.standard.removeObject(forKey: Keys.name)
        UserDefaults.standard.removeObject(forKey: Keys.birthday)
        UserDefaults.standard.removeObject(forKey: Keys.emailID)
        UserDefaults.standard.removeObject(forKey: Keys.joinDate)
        UserDefaults.standard.removeObject(forKey: Keys.department)
        UserDefaults.standard.removeObject(forKey: Keys.deviceType)
        UserDefaults.standard.removeObject(forKey: Keys.address)
        UserDefaults.standard.removeObject(forKey: Keys.contactNo)
        UserDefaults.standard.removeObject(forKey: Keys.code)
        UserDefaults.standard.removeObject(forKey: Keys.designation)
        UserDefaults.standard.removeObject(forKey: Keys.reportTo)
        UserDefaults.standard.removeObject(forKey: Keys.profileImage)
        UserDefaults.standard.removeObject(forKey: Keys.aadharNo)
        UserDefaults.standard.removeObject(forKey: Keys.panNo)
        UserDefaults.standard.removeObject(forKey: Keys.bloodGroup)
        UserDefaults.standard.removeObject(forKey: Keys.policyAmount)
        UserDefaults.standard.removeObject(forKey: Keys.plBalance)
        UserDefaults.standard.removeObject(forKey: Keys.policyNumber)
        UserDefaults.standard.removeObject(forKey: Keys.policyValidity)
        UserDefaults.standard.removeObject(forKey: Keys.bookingRoleID)
    }
}
// MARK: - Device Model
var deviceModel: String {
    var systemInfo = utsname()
    uname(&systemInfo)

    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
}
