//
//  APIManager.swift
//  YeshuTV
//
//  Created by virendra kumar on 16/12/21.
//


import UIKit
import Alamofire

// Type alias for response handler closure
/// <#Description#>
/// - Parameters:
///   - result: Bool
///   - response: Response as Dictionary
///   - error: error
///   - data:data
/// - Returns: Void
 typealias responseHandler = (_ result: Bool, _ response: NSDictionary?, _ error: NSError?, _ data: Data?) -> Void


class APIManager: NSObject {
    
    class func getServerPath() -> String {
        let serverPath: String = BASEURL
        return serverPath
    }
    
    class func getFullPath(path: String) -> String {
        
        var fullPath: String!
        fullPath = APIManager.getServerPath()
        fullPath.append("/")
        fullPath.append(path)
        let escapedAddress: String = fullPath.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        return escapedAddress
        
    }
    
    class func getServerPath2() -> String {
        let serverPath: String = bookingBase
        return serverPath
    }
    
    class func getFullPath2(path: String) -> String {
        
        var fullPath: String!
        fullPath = APIManager.getServerPath2()
        fullPath.append("/")
        fullPath.append(path)
        let escapedAddress: String = fullPath.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        return escapedAddress
        
    }
    class func setHeader() -> Dictionary<String, String> {
        
        var dict = Dictionary<String,String>()
        
        dict["device_type"] = currentUser.device_type
       
        return dict
    }
    
    class func json(from object:AnyObject) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    class func setRequest(dict: NSDictionary, url: String)->NSMutableURLRequest{
        let request = NSMutableURLRequest(url: NSURL.init(string: url)! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 50 // 10 secs
        let values = ["key": "value"]
        request.httpBody = try! JSONSerialization.data(withJSONObject: values, options: [])
        return request
    }
    class  func convertToDictionary(text: String) -> [String: Any]?
    {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    //post
    /// Call the function and pass api
    /// - Parameters:
    ///   - postData: Parameter as [String: Any]
    ///   - url: API Url
    ///   - identifire: Option identifier to handle check
    ///   - completionHandler: response handling code
    class func apiCall(postData: NSDictionary, url: String, identifier: String = "", completionHandler: @escaping responseHandler) {
        let path: String = APIManager.getFullPath(path: url)
        
        NSLog("Request URL ->  \(path)")
        NSLog("Request parameter ->  \(postData.jsonStringRepresentation?.description ?? "")")
        NSLog("Request Header ->  \(APIManager.setHeader().jsonStringRepresentation?.description ?? "")")

        let headers = HTTPHeaders(APIManager.setHeader()) // ✅ Convert Dictionary to HTTPHeaders

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in postData {
                if let arrayValue = value as? NSArray {
                    let str = APIManager.json(from: arrayValue)
                    if let data = str?.data(using: .utf8) {
                        multipartFormData.append(data, withName: key as! String)
                    }
                } else if let stringValue = "\(value)".data(using: .utf8) {
                    multipartFormData.append(stringValue, withName: key as! String)
                }
            }
        }, to: path, headers: headers) // ✅ Removed encodingCompletion
        .uploadProgress { progress in
            NSLog("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    if let jsonResponse = value as? NSDictionary {
                        NSLog("HTTP Response Value -> \(jsonResponse.jsonStringRepresentation ?? "")")
                        completionHandler(true, jsonResponse, nil, response.data)
                    } else {
                        NSLog("HTTP Response Value -> \(String(describing: value))")
                        completionHandler(true, nil, nil, response.data)
                    }
                case .failure(let error):
                    Loader.hideLoader()
                    NSLog("Upload Failed: \(error.localizedDescription)")
                    completionHandler(false, nil, error as NSError?, nil)
                }
            }
        }
    }

    
    class func apiWithoutHeader(postData: NSDictionary, url: String, identifire: String, completionHandler: @escaping responseHandler) {
        let path: String = APIManager.getFullPath2(path: url)

        print("Request URL -> \(path)")
        print("Request parameter -> \(postData.jsonStringRepresentation?.description ?? "")")

        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in postData {
                    if let arrayValue = value as? NSArray {
                        let jsonString = APIManager.json(from: arrayValue)
                        if let data = jsonString?.data(using: .utf8) {
                            multipartFormData.append(data, withName: key as! String)
                        }
                    } else if let stringValue = "\(value)".data(using: .utf8) {
                        multipartFormData.append(stringValue, withName: key as! String)
                    }
                }
            },
            to: path,
            headers: nil // ✅ Use `nil` instead of `[:]`
        )
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    if let jsonResponse = value as? NSDictionary {
                        print("HTTP Response Value -> \(jsonResponse.jsonStringRepresentation ?? "")")
                        completionHandler(true, jsonResponse, nil, response.data)
                    } else {
                        print("HTTP Response Value -> \(String(describing: value))")
                        completionHandler(true, nil, nil, response.data)
                    }
                case .failure(let error):
                    Loader.hideLoader()
                    print("Upload Failed: \(error.localizedDescription)")
                    completionHandler(false, nil, error as NSError?, nil)
                }
            }
        }
    }



    class func apiCall2(postData: NSDictionary, url: String, identifire: String, completionHandler: @escaping (_ result: Bool, _ response: NSDictionary?, _ error: NSError?, _ errorMessage: String?) -> Void) {
        
        let path: String = APIManager.getFullPath(path: url)
        
        print("Request URL -> \(path)")
        print("Request Parameters -> \(postData)")
        
        let headers = HTTPHeaders(APIManager.setHeader()) // ✅ Convert Dictionary to HTTPHeaders
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in postData {
                print("Uploading Key: \(key), Value: \(value)")
                if let arrayValue = value as? NSArray {
                    let jsonString = APIManager.json(from: arrayValue)
                    if let data = jsonString?.data(using: .utf8) {
                        multipartFormData.append(data, withName: key as! String)
                    }
                } else if let stringValue = "\(value)".data(using: .utf8) {
                    multipartFormData.append(stringValue, withName: key as! String)
                }
            }
        }, to: path, headers: headers) // ✅ Removed `encodingCompletion`
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseString { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let responseString):
                    print("Response: \(responseString)")
                    if let jsonData = responseString.data(using: .utf8),
                       let jsonResponse = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? NSDictionary {
                        completionHandler(true, jsonResponse, nil, "Success")
                    } else {
                        completionHandler(true, nil, nil, "Invalid response format")
                    }
                case .failure(let error):
                    Loader.hideLoader()
                    print("Upload Failed: \(error.localizedDescription)")
                    completionHandler(false, nil, error as NSError?, "Request failed")
                }
            }
        }
    }

   

}

struct BodyStringEncoding: ParameterEncoding {
    
    private let body: String
    
    init(body: String) { self.body = body }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard var urlRequest = urlRequest.urlRequest else { throw Errors.emptyURLRequest }
        guard let data = body.data(using: .utf8) else { throw Errors.encodingProblem }
        urlRequest.httpBody = data
        return urlRequest
    }
}

extension BodyStringEncoding {
    enum Errors: Error {
        case emptyURLRequest
        case encodingProblem
    }
}

extension BodyStringEncoding.Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyURLRequest: return "Empty url request"
        case .encodingProblem: return "Encoding problem"
        }
    }
}


extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,options: [.prettyPrinted]) else {
            return nil
        }
        return String(data: theJSONData, encoding: .ascii)
    }
}

extension NSDictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,options: [.prettyPrinted]) else {
            return nil
        }
        return String(data: theJSONData, encoding: .ascii)
    }
}

extension Array {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,options: [.prettyPrinted]) else {
            return nil
        }
        return String(data: theJSONData, encoding: .ascii)
    }
}


