//
//  WebServiceOperation.swift
//  Amen App
//
//  Created by pampana ajay on 07/10/21.
//

import Foundation
import UIKit
import Alamofire


struct MultiPartDataFormatStructure {
    
    enum MIME_TYPE {
        case text_plain
        case text_html
        case image_jpg
        case image_jpeg
        case image_png
        case image_gif
        case audio_mpeg
        case audio_ogg
        case audio_any
        case video_mp4
        
        func getMimeType() -> String {
            switch self {
            case .text_plain:
                return "text/plain"
            case .text_html:
                return "text/html"
            case .image_jpg:
                return "image/jpg"
            case .image_jpeg:
                return "image/jpeg"
            case .image_png:
                return "image/png"
            case .image_gif:
                return "image/gif"
            case .audio_mpeg:
                return "audio/mpeg"
            case .audio_ogg:
                return "audio/ogg"
            case .audio_any:
                return "audio/*"
            case .video_mp4:
                return "video/mp4"
            }
        }
    }
    
    internal let strKey:String?
    internal let strFileName:String?
    internal let mimeType:MIME_TYPE?
    internal let data:Data?
    
    init(key:String?,mimeType:MIME_TYPE?,data:Data?,name:String?) {
        self.strKey = key
        self.mimeType = mimeType
        self.data = data
        self.strFileName = name
    }
}

class WebServiceOperation: MyWebServiceOperation {
    private var maxcall = 2
    private class WebServiceCallingClass:NSObject {
        
        enum WEB_SERVICE_TYPE:Int {
            case WEB_SERVICE_TYPE_GET = 0
            case WEB_SERVICE_TYPE_POST
            case WEB_SERVICE_TYPE_MULTI_PART
        }
        
        class func callWebserviceFor(URL url:URL,SERVICE_TYPE serviceType:WEB_SERVICE_TYPE,PARAM param:Dictionary<String,AnyObject>?,HANDLER handler:((_ response:Data?,_ isError:Bool)->())?) {
            print("fireUrl:%@",url)
//            Alamofire.request(url, method: (serviceType == .WEB_SERVICE_TYPE_POST) ? .post: .get , parameters: param, encoding: JSONEncoding.defaul, headers: nil)
           
            let headers: HTTPHeaders = [
//                "Accesstoken": "\(Userdefault.value(forKey: "access_token") ?? "")",
                "":""
            ]
            print(headers)
            

            AF.request(url, method: (serviceType == .WEB_SERVICE_TYPE_POST) ? .post : .get, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                guard let data = response.data, data.count > 0 else{
                    if let handler = handler {
                        DispatchQueue.main.async {
                            handler(nil,true)
                        }
                    }
                    return
                }
                if let handler = handler {
                    DispatchQueue.main.async {
                        handler(data,false)
                    }
                }
            }
        }
        
        class func callMultiPart(
            URL url: URL,
            PARAM param: Dictionary<String, Any>?,
            MultiPartArray arrMultipart: [MultiPartDataFormatStructure]?,
            HANDLER handler: ((_ response: Data?, _ isError: Bool) -> ())?
        ) {
            print(param as Any)
            print(arrMultipart as Any)
            print(url as Any)

            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]

            AF.upload(multipartFormData: { multipartFormData in
                // Add normal parameters
                if let param = param {
                    for (key, value) in param {
                        if let data = "\(value)".data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                }

                // Add multipart data (files, images, etc.)
                if let arr = arrMultipart {
                    for obj in arr {
                        if let key = obj.strKey, let mimeType = obj.mimeType, let data = obj.data, let fileName = obj.strFileName {
                            multipartFormData.append(data, withName: key, fileName: fileName, mimeType: mimeType.getMimeType())
                        }
                    }
                }
            }, to: url, method: .post, headers: headers)
            .uploadProgress { progress in
                NotificationCenter.default.post(name: Notification.Name("UploadProgress"), object: progress.fractionCompleted)
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                print(response.result)
                
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let json):
                        print("JSON Response: \(json)")
                        handler?(response.data, false)
                    case .failure(let error):
                        print("Upload Failed: \(error.localizedDescription)")
                        handler?(nil, true)
                    }
                }
            }
        }
    }
    
    enum WEB_SERVICE:Int {
        case WEB_SERVICE_GET = 0
        case WEB_SERVICE_POST
        case WEB_SERVICE_MULTI_PART
    }
    
    private var urlString:String = ""
    private var param:Dictionary<String,AnyObject>? = nil
    private var arrMultipart:[MultiPartDataFormatStructure]? = nil
    private var serviceType:WebServiceCallingClass.WEB_SERVICE_TYPE = .WEB_SERVICE_TYPE_POST
    private var header:HTTPHeaders? = nil
    public static let __kStrVideoRawDataKey = "__kStrVideoRawDataKey"
    public static let __kStrVideoSnapshotDataKey = "__kStrVideoSnapshotDataKey"
    
    var responseData:Data?
    var dictResponse:[String:Any]?
    
    
    
    private override init() {
        super.init()
    }
    
    init(_ url:String!,_ param:Dictionary<String,AnyObject>?,_ serviceType:WEB_SERVICE = WEB_SERVICE.WEB_SERVICE_POST, _ arrMultipartData:[MultiPartDataFormatStructure]? = nil) {
        
        self.urlString = url
        self.param = param
        self.arrMultipart = arrMultipartData
        
        if serviceType == .WEB_SERVICE_POST {
            self.serviceType = .WEB_SERVICE_TYPE_POST
        }
        if serviceType == .WEB_SERVICE_GET {
            self.serviceType = .WEB_SERVICE_TYPE_GET
        }
        if serviceType == .WEB_SERVICE_MULTI_PART {
            self.serviceType = .WEB_SERVICE_TYPE_MULTI_PART
        }
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        
        guard let url = URL(string: self.urlString) else {
            finish(true)
            return
        }
        
        
        
        if self.serviceType == .WEB_SERVICE_TYPE_MULTI_PART {
            WebServiceCallingClass.callMultiPart(URL: url, PARAM: self.param, MultiPartArray: self.arrMultipart) { (data:Data?, error:Bool) in
                self.responseData = data
                if let data = data, data.count > 0 {
                    do{
                        self.dictResponse = try (JSONSerialization.jsonObject(with: data, options: []) as? [String : Any])
                    }catch let err {
                        print(err.localizedDescription)
                    }
                }
                self.executing(false)
                self.finish(true)
            }
        }else{
            WebServiceCallingClass.callWebserviceFor(URL: url, SERVICE_TYPE: self.serviceType, PARAM: self.param) { (response, error) in
                self.responseData = response
                if let data = response, data.count > 0 {
                    do{
                        self.dictResponse = try (JSONSerialization.jsonObject(with: data, options: []) as? [String : Any])
                    }catch let err {
                        print(err.localizedDescription)
                        print("failed1")
                    }
                    self.executing(false)
                    self.finish(true)
                }else{
                        WebServiceCallingClass.callWebserviceFor(URL: url, SERVICE_TYPE: self.serviceType, PARAM: self.param) { (response, error) in
                            self.responseData = response
                            if let data = response, data.count > 0 {
                                do{
                                    self.dictResponse = try (JSONSerialization.jsonObject(with: data, options: []) as? [String : Any])
                                }catch let err {
                                    print(err.localizedDescription)
                                    print("failed1")
                                }
                                
                            }
                            self.executing(false)
                            self.finish(true)
                            
                        }
                    
                }
                
            }
        }
    }
}





