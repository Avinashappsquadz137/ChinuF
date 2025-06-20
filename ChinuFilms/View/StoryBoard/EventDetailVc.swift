//
//  EventDetailVc.swift
//  SanskarEP
//
//  Created by Surya on 06/09/24.
//

import UIKit
import SDWebImage 

class EventDetailVc: UIViewController {

    @IBOutlet weak var empname: UILabel!
    @IBOutlet weak var empimage: UIImageView!
    @IBOutlet weak var empcode: UILabel!
    @IBOutlet weak var depart: UILabel!
    @IBOutlet weak var requestid: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var fromdate: UILabel!
    @IBOutlet weak var todate: UILabel!
    @IBOutlet weak var approvalbtn: UIButton!
    @IBOutlet weak var rejectbtn: UIButton!
    
    
    var datalist: [String: Any]?
    
    var request = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setdata()
    }
    
    
    @IBAction func approvaltn(_ sender: UIButton) {
        if let reqId = requestid.text, !reqId.isEmpty {
               getGrant(reqId, "granted")
           } else {
               print("Request ID is missing")
           }
    }
    
    @IBAction func rejectbtn(_ sender: UIButton) {
        if let reqId = requestid.text, !reqId.isEmpty {
               getGrant(reqId, "declined")
           } else {
               print("Request ID is missing")
           }
    }
    
    func setdata() {
        if let data = datalist {
               empname.text = data["Name"] as? String ?? ""
               empcode.text = data["Emp_Code"] as? String ?? ""
               fromdate.text = data["from_date"] as? String ?? ""
               todate.text = data["to_date"] as? String ?? ""
               depart.text = data["Dept"] as? String ?? ""
               reason.text = data["Reason"] as? String ?? ""
               type.text = data["leave_type"] as? String ?? ""
            
            
               requestid.text = data["ID"] as? String ?? ""
               
            approvalbtn.layer.cornerRadius = 8
            rejectbtn.layer.cornerRadius = 8
            
               if let image = data["PImg"] as? String {
                   
                   let img = image.replacingOccurrences(of: " ", with: "%20")
                   empimage.sd_setImage(with: URL(string: img))
               } else {
                   empimage.image = UIImage(named: "download")
               }
           }
    }
    
    func getGrant(_ id: String, _ reply: String) {
        var dict = Dictionary<String, Any>()
        dict["req_id"] = id
        print(dict["req_id"])
        dict["reply"] = reply
        print(dict["reply"])
       
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: kgrant) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
             
                AlertController.alert(message: (response?.validatedValue("message"))!)
//                DispatchQueue.main.async {
//                    self.dismiss(animated: true)
//                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }

    func approveBooking(bookingIds: [String], status: String, empcode: String) {
        var dict = Dictionary<String, Any>()
           dict["kathaid"] = bookingIds
           dict["empcode"] = currentUser.EmpCode
           dict["status"] = "1"
           DispatchQueue.main.async(execute: {Loader.showLoader()})
           APIManager.apiCall(postData: dict as NSDictionary, url: hodBApprovalApi) { result, response, error, data in
               DispatchQueue.main.async(execute: {Loader.hideLoader()})
               if let _ = data, (response?["status"] as? Bool == true), response != nil {
                   AlertController.alert(message: (response?.validatedValue("message"))!)
                   DispatchQueue.main.async {
                   }
               } else {
                   print(response?["error"] as Any)
               }
           }
        }
    func rejectBooking(bookingIds: [String], status: String) {
        var dict = Dictionary<String, Any>()
          dict["kathaid"] = bookingIds
          dict["empcode"] = currentUser.EmpCode
          dict["status"] = "2"
          DispatchQueue.main.async(execute: {Loader.showLoader()})
          APIManager.apiCall(postData: dict as NSDictionary, url: hodBApprovalApi) { result, response, error, data in
              DispatchQueue.main.async(execute: {Loader.hideLoader()})
              if let _ = data, (response?["status"] as? Bool == true), response != nil {
                  AlertController.alert(message: (response?.validatedValue("message"))!)
                  DispatchQueue.main.async {
                  }
              } else {
                  print(response?["error"] as Any)
              }
          }
       }
}
