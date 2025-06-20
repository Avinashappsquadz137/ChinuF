//
//  submittedmdeldata.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 31/07/24.
//


import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let status: Bool
    let message: String
    let data: [Datum]
    let error: JSONNull?
}

// MARK: - Datum
struct Datum: Codable {
    let tempID, compID: String
    let name: Name
    let item, fromLocation, toLocation, remarks: String
    let miscItem, challanDetail, chalanqr, challanDate: String
    let createdDate, updatedDate, status: String
    let clientName, officeCallTime, empCode, transportBy: JSONNull?
    let transportDetail: JSONNull?
    var products: [Product]
    let qrCodeList: [String]
    var misproducts: [Misproduct]?

    enum CodingKeys: String, CodingKey {
        case tempID = "TEMP_ID"
        case compID = "COMP_ID"
        case name = "NAME"
        case item = "ITEM"
        case fromLocation = "FROM_LOCATION"
        case toLocation = "TO_LOCATION"
        case remarks = "REMARKS"
        case miscItem = "MISC_ITEM"
        case challanDetail = "CHALLAN_DETAIL"
        case chalanqr = "CHALANQR"
        case challanDate = "CHALLAN_DATE"
        case createdDate = "CREATED_DATE"
        case updatedDate = "UPDATED_DATE"
        case status = "STATUS"
        case clientName = "client_name"
        case officeCallTime = "office_call_time"
        case empCode = "emp_code"
        case transportBy = "transport_by"
        case transportDetail = "transport_detail"
        case products
        case qrCodeList = "qr_code_list"
        case misproducts
    }
}

// MARK: - Misproduct
struct Misproduct: Codable {
    let itemChecked: Bool
    let itemName, itemQuantity: String

    enum CodingKeys: String, CodingKey {
        case itemChecked
        case itemName = "item_name"
        case itemQuantity = "item_quantity"
    }
}

enum Name: String, Codable {
    case sans00290 = "SANS-00290"
}

// MARK: - Product
struct Product: Codable {
    let itemMasterID, itemName, itemQrStr, itemQrThumbnail: String
    let itemDesc: ItemDesc
    let modelNo, brand, srNumber, compID: String
    let itemCategoryID, createdBy: String
    let createdIP: CreatedIP
    let referenceFile, createdDate, lastmodifiedDate, status: String
    let itemID, itemCategory, categoryName: String

    enum CodingKeys: String, CodingKey {
        case itemMasterID = "ITEM_MASTER_ID"
        case itemName = "ITEM_NAME"
        case itemQrStr = "ITEM_QR_STR"
        case itemQrThumbnail = "ITEM_QR_THUMBNAIL"
        case itemDesc = "ITEM_DESC"
        case modelNo = "MODEL_NO"
        case brand = "BRAND"
        case srNumber = "SR_NUMBER"
        case compID = "COMP_ID"
        case itemCategoryID = "ITEM_CATEGORY_ID"
        case createdBy = "CREATED_BY"
        case createdIP = "CREATED_IP"
        case referenceFile = "REFERENCE_FILE"
        case createdDate = "CREATED_DATE"
        case lastmodifiedDate = "LASTMODIFIED_DATE"
        case status = "STATUS"
        case itemID = "ITEM_ID"
        case itemCategory = "ITEM_CATEGORY"
        case categoryName
    }
}

enum CreatedIP: String, Codable {
    case empty = ""
    case the19216840132 = "192.168.40.132"
}

enum ItemDesc: String, Codable {
    case boatMike = "boat mike"
    case empty = ""
    case mic = "MIC"
    case mike11 = "mike 11"
    case outDoorKatha = "OUT DOOR KATHA"
    case receiver = "RECEIVER"
    case sony9021 = "sony 9021"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
