//
//  scheduleVC.swift
//  SanskarEP
//
//  Created by Surya on 09/12/24.
//

import UIKit

class scheduleVC: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var playerimage: UIImageView!
    @IBOutlet weak var playerview: UIView!
    @IBOutlet weak var actionbtn: UIButton!
    @IBOutlet weak var actionview: UIView!
    @IBOutlet weak var approvebtn: UIButton!
    @IBOutlet weak var Rejectbtn: UIButton!
    @IBOutlet weak var remarkstext: UITextView!
    
    
    var DataList  = [[String:Any]]()
    var kathaId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        ScheduleAPi()
        playerview.isHidden = true
        tableview.register(UINib(nibName: "NewEventListCell" , bundle: nil), forCellReuseIdentifier: "NewEventListCell")
        handleQCAction(status: "1")
        
   
        if let roleID = Int(currentUser.booking_role_id) {
            if roleID == 7 {
                actionbtn.isHidden = false
            }  else {
                actionbtn.isHidden = true
            }
        }

        approvebtn.layer.cornerRadius = 8
        Rejectbtn.layer.cornerRadius = 8
        actionview.layer.cornerRadius = 8
        actionbtn.layer.cornerRadius = 8
        actionview.isHidden = true
        
        remarkstext.delegate = self
        remarkstext.layer.cornerRadius = 10
        remarkstext.clipsToBounds = true
        remarkstext.text = "Remark ..."
        remarkstext.layer.borderWidth = 1.0
        remarkstext.layer.borderColor = UIColor.lightGray.cgColor
        remarkstext.textColor = UIColor.lightGray
       
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func actionbtn(_ sender: UIButton) {
        self.actionview.isHidden = !self.actionview.isHidden
    }
    
    @IBAction func clearbtn(_ sender: UIButton) {
        playerview.isHidden = true
    }
    
      
    @IBAction func approvebtn(_ sender: UIButton) {
        handleQCAction(status: "1")
        actionview.isHidden = true
    }
    
    @IBAction func rejectbtn(_ sender: UIButton) {
        handleQCAction(status: "2")
        actionview.isHidden = true
    }
    
    func ScheduleAPi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["Katha_Id"] = "\(kathaId)"
   
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: scheduleApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                if let dataArray = responseData["data"] as? [[String: Any]] {
                    self.DataList = dataArray
                    self.tableview.reloadData()
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
    
    func handleQCAction(status: String) {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["Katha_Id"] = "\(kathaId)"
        dict["Status"] = status
        dict["Remarks"] = remarkstext.text
        dict["PromoId"] = "1"
        
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: qcactionApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                if let dataArray = responseData["data"] as? [[String: Any]] {
                    self.DataList = dataArray
                    self.tableview.reloadData()
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
    
    @objc func viewbuttontapped(_ sender: UIButton) {
        let buttonIndex = sender.tag
        guard let rowData = DataList[buttonIndex] as? [String: Any] else { return }
        let PromoUrl = rowData["url"] as? String ?? ""
        let promoType = rowData["promo_type"] as? String ?? ""
        if promoType == "1" {
            let vc = storyboard!.instantiateViewController(withIdentifier: "videoplayerVC") as! videoplayerVC
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    if #available(iOS 16.0, *) {
                        let customDetent = UISheetPresentationController.Detent.custom { context in
                            return 540
                        }
                        sheet.detents = [customDetent]
                        sheet.largestUndimmedDetentIdentifier = customDetent.identifier
                    }
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 12
                }
            }
            vc.promo = PromoUrl
            self.present(vc, animated: true)
        } else {
            playerview.isHidden = false
            playerimage.sd_setImage(with: URL(string: PromoUrl))
        }
    }
}
extension scheduleVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
              return  DataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "NewEventListCell", for: indexPath) as! NewEventListCell
        cell.NameLbl.text = DataList[indexPath.row]["Type_name"] as? String ?? ""
        cell.viewbtn.tag = indexPath.row
        cell.viewbtn.addTarget(self, action: #selector(viewbuttontapped(_:)), for: .touchUpInside)
        cell.eventbtn.isHidden = true
        cell.TypeLbl.isHidden = true
        cell.colorlbl.isHidden = true
        cell.imageview.isHidden = true
        cell.Datelbl.isHidden = true
        return cell
    }
}
extension scheduleVC : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (remarkstext.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if remarkstext.textColor == UIColor.lightGray {
            remarkstext.text = ""
            remarkstext.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if remarkstext.text == "" {

            remarkstext.text = "Remark ..."
            remarkstext.textColor = UIColor.lightGray
        }
    }
}
