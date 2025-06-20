//
//  CustomAlert.swift
//  SanskarEP
//
//  Created by Warln on 22/04/22.
//

import UIKit
import SDWebImage
import iOSDropDown

protocol CustomAlertDelegate: AnyObject {
    func didCompleteAction(with message: String)
}



class CustomAlert: UIViewController {
    
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var nameLbL: UILabel!
    @IBOutlet weak var locateTxt: DropDown!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var acceptbtn: UIButton!
    @IBOutlet weak var rejectbtn: UIButton!
    @IBOutlet weak var remarktext: UITextField!
    @IBOutlet weak var okbtn: UIButton!
    
    var locDetails: [[String: Any]] = []
    var selectedLocationID: String?
    
    //["Ground Floor","Reception","Conference Room","Second Floor"]
    var imgName: String?
    var nameTxt: String?
    var userInfo: [String: Any]?
    var type: String?
    var reqid: Int?
    var inoutkey: String?
    weak var delegate: CustomAlertDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Bundle.main.loadNibNamed("CustomAlert", owner: self, options: nil)
        holderView.layer.cornerRadius = 5
        holderView.clipsToBounds = true
        
        contentview.isHidden = true
        GuestFloor()
        
        
        
        if let userInfo = userInfo as? [String: Any] {
            print("Full userInfo: \(userInfo)")
            
            if let data = userInfo["data"] as? [String: Any] {
                print("Extracted data: \(data)")
                
                if let requestId = data["req_id"] {
                           if let reqIdInt = requestId as? Int {
                               self.reqid = reqIdInt
                           } else if let reqIdString = requestId as? String, let reqIdInt = Int(reqIdString) {
                               self.reqid = reqIdInt
                           } else {
                               print("req_id is neither Int nor String: \(requestId)")
                           }
                       } else {
                           print("req_id not found in data")
                       }
                   
                
                if let inoutkey = data["inOrOut"] as? String {
                    self.inoutkey = inoutkey
                }
                
                if let notificamtionType = data["notification_type"] as? String {
                    self.type = notificamtionType
                } else {
                    print("⚠️ 'notification_type' is nil or not an Int")
                }
            }
        }
            update()
    }
    
    func setdetail() {
        if let data = userInfo?["data"] as? [String: Any] {
            nameLbL.text = data["notification_content"] as? String ?? nameTxt

            if let imgUrl = data["img"] as? String, let url = URL(string: imgUrl) {
                posterImg.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(systemName: "person.fill"),
                    options: .refreshCached,
                    completed: nil
                )
            } else if let localImg = imgName, let url = URL(string: localImg) {
                posterImg.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.fill"))
            }
        } else {
            nameLbL.text = nameTxt
            if let localImg = imgName, let url = URL(string: localImg) {
                posterImg.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.fill"))
            }
        }
    }

    
    
    @IBAction func okbtn(_ sender: UIButton) {
        if let reqid = reqid {
                   let remark = remarktext.text ?? ""
            GuestAction(id: String(reqid), status: "2", reason: remark)
        }
    }
    
    func GuestFloor() {
        var dict = [String: Any]()
        dict["EmpCode"] = currentUser.EmpCode

        DispatchQueue.main.async {
            Loader.showLoader()
        }

        APIManager.apiCall(postData: dict as NSDictionary, url: guestFloor) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }

            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    if let dataArray = JSON["data"] as? [[String: Any]] {
                        self.locDetails = dataArray
                        
                        DispatchQueue.main.async {
                            self.setDrop()
                        }
                    }
                } else {
                    print(response?["error"] as Any)
                }
            }
        }
    }

    
    func update() {
        if type == "8" {
            contentview.isHidden = true
            locateTxt.isHidden = true
            
            if inoutkey == "0" {
                acceptbtn.setTitle("Accept", for: .normal)
                acceptbtn.setTitleColor(.white, for: .normal)
                rejectbtn.isHidden = true
                acceptbtn.isHidden = false
            }
            
            if inoutkey == "1" {
                acceptbtn.setTitle("In Time", for: .normal)
                acceptbtn.setTitleColor(.white, for: .normal)
                rejectbtn.isHidden = true
                acceptbtn.isHidden = false
            } else if inoutkey == "2" {
                rejectbtn.setTitle("Out Time", for: .normal)
                rejectbtn.setTitleColor(.white, for: .normal)
                acceptbtn.isHidden = true
                rejectbtn.isHidden = false
            }
        } else if type == "9" {
            contentview.isHidden = true
            locateTxt.isHidden = false
            
            setdetail()
            
            acceptbtn.isHidden = false
            rejectbtn.isHidden = false
            
            acceptbtn.setTitle("Accept", for: .normal)
            acceptbtn.setTitleColor(.white, for: .normal)
            
            rejectbtn.setTitle("Reject", for: .normal)
            rejectbtn.setTitleColor(.white, for: .normal)
        }
        setdetail()
    }


    
    
    func setDrop() {
        let locationNames = locDetails.compactMap { $0["name"] as? String }
        locateTxt.optionArray = locationNames
        locateTxt.isSearchEnable = true
        locateTxt.listHeight = 150

        locateTxt.didSelect { selectedText, index, id in
            self.locateTxt.text = selectedText
            
            if let selectedLocation = self.locDetails.first(where: { $0["name"] as? String == selectedText }),
               let selectedID = selectedLocation["id"] as? String {
                
                
                self.selectedLocationID = selectedID
            }
        }
    }

    
    
    @IBAction func rejectBtnPressed(_ sender: UIButton ) {
        switch type {
         case "8":
            contentview.isHidden = true
            let currentTime = getCurrentTime()
               if let reqid = reqid {
                getGrant(String(reqid), "2", currentTime)
               }
        case "9": 
            contentview.isHidden = false
            locateTxt.isHidden = true
           
                default:
                print("⚠️ Unknown action for accept button")
                    }
           
    }
    
    
    @IBAction func acceptBtnPressed(_ sender: UIButton ) {
        
        guard let type = type else { return }
        switch type {
         case "8":
            if let inoutkey = self.inoutkey, let reqid = self.reqid {
                            let currentTime = getCurrentTime()
                            
                            if inoutkey == "0" {
                                getGrant(String(reqid), "0", currentTime)
                            } else if inoutkey == "1" {
                                getGrant(String(reqid), "1", currentTime)
                            }
                        }
            case "9":
            contentview.isHidden = true
            if let reqid = reqid, let selectedID = selectedLocationID {
                       let remark = remarktext.text ?? ""
                GuestAction(id: String(reqid), status: "1", selectid: selectedID)
                   }
                default:
                print("⚠️ Unknown action for accept button")
                    }
        
         //   self.dismiss(animated: true)
    }
    
    @IBAction func dismissBtnPressed(_ sender: UIButton ) {
        self.dismiss(animated: true)
    }
    
    func getCurrentTime() -> String {
        return String(Int(Date().timeIntervalSince1970))
    }
    
    func getGrant(_ id: String, _ status: String, _ time: String? = nil) {
        var dict = [String: Any]()
        dict["id"] = id
        dict["status"] = status
        dict["time"] = time

        
        DispatchQueue.main.async { Loader.showLoader() }
        APIManager.apiCall(postData: dict as NSDictionary, url: GuestTime) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }
            if let response = response, response["status"] as? Bool == true {
              //  AlertController.alert(message: )
//                DispatchQueue.main.async {
//                  self.delegate?.didCompleteAction(with: response.validatedValue("message") as! String)
//                  self.dismiss(animated: true)
//              }
                DispatchQueue.main.async {
                    self.delegate?.didCompleteAction(with:response.validatedValue("message") as! String)
                    self.showToast(message: response.validatedValue("message") as! String) 
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.dismiss(animated: true)
                    }
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }

    
    func GuestAction(id: String,status: String,selectid: String? = nil,reason: String? = nil) {
        var dict = [String: Any]()
        dict["id"] = id
        dict["status"] = status
        dict["floor"] = selectid
        dict["reason"] = reason

        DispatchQueue.main.async { Loader.showLoader() }
        APIManager.apiCall(postData: dict as NSDictionary, url: guestAction) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }
            if let response = response, response["status"] as? Bool == true {
            //    AlertController.alert(message: response.validatedValue("message") as! String)
//                self.delegate?.didCompleteAction(with: response.validatedValue("message") as! String)
//                self.dismiss(animated: true)
                DispatchQueue.main.async {
                    self.delegate?.didCompleteAction(with:response.validatedValue("message") as! String)
                    self.showToast(message: response.validatedValue("message") as! String)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.dismiss(animated: true)
                    }
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }

    }

