//
//  KathaAssignVc.swift
//  SanskarEP
//
//  Created by Surya on 25/09/24.
//

import UIKit

class KathaAssignVc: UIViewController {

@IBOutlet weak var namelbl: UILabel!
@IBOutlet weak var channellbl: UILabel!
@IBOutlet weak var datelbl: UILabel!
@IBOutlet weak var timelbl: UILabel!
@IBOutlet weak var venulbl: UILabel!
@IBOutlet weak var remarkstxt: UITextView!
@IBOutlet weak var assignview: UIView!
@IBOutlet weak var tableview: UITableView!
@IBOutlet weak var assigntxt: UITextField!
@IBOutlet weak var submitbtn: UIButton!
@IBOutlet weak var assignlistview: UIView!
@IBOutlet weak var assignlisttable: UITableView!
    
    
    var selectedassign: String?
    var selecteempcode: String?
    var Datalist: [String:Any]?
    var assigndata  = [[String:Any]]()
    var assignlist  = [[String:Any]]()
    var selectedRows: Set<Int> = []
    var selectedIds: [Int] = []
    var kathaId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeData()
        setup()
        KathAssignApi()
    //    KathForAssignApi()
        assignview.isHidden = true
        tableview.isHidden = true
        tableview.dataSource = self
        tableview.delegate = self
        
        remarkstxt.delegate = self
        remarkstxt.layer.cornerRadius = 10
        remarkstxt.clipsToBounds = true
        remarkstxt.text = "Remark ..."
        remarkstxt.textColor = UIColor.lightGray
        remarkstxt.layer.borderColor = UIColor.lightGray.cgColor
        
        assignlisttable.dataSource = self
        assignlisttable.delegate = self
        
        assignlisttable.register(UINib(nibName: "AssignListCell", bundle: nil), forCellReuseIdentifier: "AssignListCell")
        if let data = Datalist {
            namelbl.text   = data["Name"] as? String ?? ""
            channellbl.text   = data["ChannelName"] as? String ?? ""
            venulbl.text   = data["Venue"] as? String ?? ""
            timelbl.text   = data["SlotTiming"] as? String ?? ""
            datelbl.text = " \(data["Katha_from_Date"] as? String ?? "") to \(data["Katha_date"] as? String ?? "")"
            kathaId        = data["Katha_id"] as? Int ?? 0
        }
        
    }
    
    func setup(){
   
        
        submitbtn.layer.cornerRadius = 10
        submitbtn.layer.borderWidth = 0.5
      
        
        
        
    }
    func removeData() {
        remarkstxt.text?.removeAll()
   //     assigntxt.text?.removeAll()
    }
    @IBAction func assignbtn(_ sender: UIButton) {
//        self.assignview.isHidden = !self.assignview.isHidden
//        self.tableview.isHidden = !self.tableview.isHidden
    }
    
    @IBAction func submitbtn(_ sender: UIButton) {
        SubmitApi()
    }
    
    func KathAssignApi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: AssignAPi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                if let dataArray = responseData["data"] as? [[String: Any]] {
                    self.assignlist = dataArray
                    self.assignlisttable.reloadData()
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
//    func KathForAssignApi() {
//        var dict = Dictionary<String, Any>()
//        dict["EmpCode"] = currentUser.EmpCode
//        DispatchQueue.main.async(execute: { Loader.showLoader() })
//        APIManager.apiCall(postData: dict as NSDictionary, url: AssignPeopleAPi) { result, response, error, data in
//            DispatchQueue.main.async(execute: { Loader.hideLoader() })
//            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
//                if let dataArray = responseData["data"] as? [[String: Any]] {
//                    self.assigndata = dataArray
//                    self.tableview.reloadData()
//                }
//            } else {
//                print(response?["error"] as Any)
//            }
//        }
//    }
    func SubmitApi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["assign_to"] = selecteempcode ?? ""
        dict["promo_type"] = selectedIds
        dict["katha_id"] = "\(kathaId)"
     //   dict["remarks"] = remarkstxt.text

        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: AssignsubmitAPi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                // Handle success response
                AlertController.alert(message: (response?.validatedValue("message"))!)
            } else {
                print(response?["error"] as Any)
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
        }
    }

    @objc func checkboxTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
               if selectedRows.contains(rowIndex) {
                   selectedRows.remove(rowIndex)
                   if let id = assignlist[rowIndex]["id"] as? Int {
                       selectedIds.removeAll(where: { $0 == id })
                   }
               } else {
                   selectedRows.insert(rowIndex)
                   if let id = assignlist[rowIndex]["id"] as? Int {
                       selectedIds.append(id)
                   }
               }
               assignlisttable.reloadData()
           }
       }

extension KathaAssignVc: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == tableview {
//            return assigndata.count
//        } else if tableView == assignlisttable {
            return assignlist.count
//        } else {
//            return 0
//        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == tableview {
//            let cell1 = tableview.dequeueReusableCell(withIdentifier: "AssignCell", for: indexPath)
//            cell1.textLabel?.text = assigndata[indexPath.row]["name"] as? String ?? ""
//            return cell1
//        } else if tableView == assignlisttable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AssignListCell", for: indexPath) as! AssignListCell
            cell.AssignLbl?.text = assignlist[indexPath.row]["Type_name"] as? String ?? ""
            
            if selectedRows.contains(indexPath.row) {
                  cell.assignbtn.setImage(UIImage(named: "check"), for: .normal)
              } else {
                  cell.assignbtn.setImage(UIImage(named: "Uncheck"), for: .normal)
              }
            cell.locationview.isHidden = true
            cell.assignbtn.tag = indexPath.row
            cell.assignbtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
            return cell
        } 
//    else {
//            return UITableViewCell()
//        }
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == tableview  {
//            selectedassign = assigndata[indexPath.row]["name"] as? String ?? ""
//            selecteempcode = assigndata[indexPath.row]["EmpCode"] as? String ?? ""
//            assigntxt.text = selectedassign
//            self.tableview.isHidden = true
//            self.assignview.isHidden = true
//        } else if tableView == assignlisttable {
//            
//        }
//    }
}
extension KathaAssignVc: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (remarkstxt.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if remarkstxt.textColor == UIColor.lightGray {
            remarkstxt.text = ""
            remarkstxt.textColor = UIColor.black
            
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            
            if remarkstxt.text == "" {
                
                remarkstxt.text = "Remark ..."
                remarkstxt.textColor = UIColor.lightGray
            }
        }
    }
}
