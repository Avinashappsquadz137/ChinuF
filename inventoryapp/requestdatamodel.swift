//
//  requestdatamodel.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 03/08/24.
//
//
//import Foundation
//
//// MARK: - Response
//struct Response: Codable {
//    let status: Bool
//    let message: String
//    let data: [ChallanDetail]
//    let error: String?
//}
//
//// MARK: - ChallanDetail
//struct ChallanDetail: Codable {
//    let challanID: String
//    let name: String
//    let mobileNo: String
//    let products: [Productt]
//    
//    enum CodingKeys: String, CodingKey {
//        case challanID = "challan_id"
//        case name
//        case mobileNo = "mobile_no"
//        case products
//    }
//}
//
//// MARK: - Product
//struct Productt: Codable {
//    // Define properties for Product here
//}
//
//
//
//
//struct datumc {
//    let tempID: String
//    let compID: String
//    let name: String
//    let item: [String]
//    let fromLocation: String
//    let toLocation: String
//    let remarks: String
//    let miscItem: [MiscItem]
//    let challanDetail: String
//    let challanQR: String
//    let challanDate: String
//    let createdDate: String
//    let updatedDate: String
//    let status: String
//    let products: [Product]
//    let qrCodeList: [String]
//    let misproducts: [MisProduct]
//
//    struct MiscItem {
//        let itemChecked: Bool
//        let itemName: String
//        let itemQuantity: String
//    }
//
//    struct Product {
//        let itemMasterID: String
//        let itemName: String
//        let itemQRStr: String
//        let itemQRThumbnail: String
//        let itemDesc: String
//        let modelNo: String
//        let brand: String
//        let srNumber: String
//        let compID: String
//        let itemCategoryID: String
//        let createdBy: String
//        let createdDate: String
//        let lastModifiedDate: String
//        let status: String
//        let itemID: String
//        let itemCategory: String
//        let categoryName: String
//    }
//
//    struct MisProduct {
//        let itemChecked: Bool
//        let itemName: String
//        let itemQuantity: String
//    }
//}
//
//
//struct mispro {
//    let itemChecked: Bool
//    let itemName: String
//    let itemQuantity: String
//}
import Foundation

// MARK: - ChallanResponse
struct ChallanResponse: Decodable {
    let status: Bool
    let message: String
    let data: [ChallanData]
    let error: String?
}

// MARK: - ChallanData
struct ChallanData: Codable {
    let challanID: String
    let name: String
    let mobileNo: String
    let products: [ChallanProduct]
    
    enum CodingKeys: String, CodingKey {
        case challanID = "challan_id"
        case name
        case mobileNo = "mobile_no"
        case products
    }
}

// MARK: - ChallanProduct
struct ChallanProduct: Codable {
    // Define the properties of a product
    // If products are empty, you can define an empty struct
    // or remove this struct if products are not used
}

// Example of how to decode the JSON
let jsonData = """
{
    "status": true,
    "message": "Generate challan detail",
    "data": [
        {
            "challan_id": "5",
            "name": "rahul",
            "mobile_no": "7739866377",
            "products": []
        }
    ],
    "error": null
}
""".data(using: .utf8)!

