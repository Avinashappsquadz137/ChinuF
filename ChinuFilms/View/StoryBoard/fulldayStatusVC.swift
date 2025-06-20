//
//  fulldayStatusVC.swift
//  SanskarEP
//
//  Created by Surya on 24/11/23.
//

import UIKit

class fulldayStatusVC: UIViewController {
    
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var TableView: UITableView!
    
    //   var list: [[String:Any]] = [[:]]
    //    var list  = [[[String:Any]]] []
    
    
 
    var reqNo = ""
    
    var type  = ""
    
    var list: [[String: Any]] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.delegate = self
        TableView.dataSource = self
        TableView.register(UINib(nibName: "TourStCell", bundle: nil), forCellReuseIdentifier: "TourStCell")
        getDetails()
    }
    
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    func check(status: String ) -> String {
        
        switch status {
        case "A":
            return " Approved"
        case "R":
            return " Pending"
        case "XA":
            return " Declined"
        case "X":
            return " Cancel"
        default:
            return ""
        }
    }
    
    func sColor(status: String ) -> UIColor {
        
        switch status {
        case "A":
            return .green
        case "R":
            return .blue
        case "XA":
            return .red
        case "X":
            return .purple
        default:
            return .black
        }
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        cancelApi()
       }
    
    func cancelApi() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["RequestId"] = reqNo
        dict["leave_type"] = "full"
       
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kLeaveCancel) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                self.getDetails()
            }else{
                print(response?["error"] as Any)
            }
            self.TableView.reloadData()
        }
    }
    
    func getDetails() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["leave_type"] = "full"
        list.removeAll()
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: status) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary,
               let status = JSON.value(forKey: "status") as? Bool,
               status == true {
                
                if let jsonData = response?["data"] as? [[[String: Any]]] {
                    self.list = jsonData.flatMap { $0.flatMap { $0 } }
                    print(self.list)
                    self.TableView.reloadData()
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
}
extension fulldayStatusVC: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return list.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourStCell", for: indexPath) as! TourStCell
        print(list)
        
        let rowData = list[indexPath.row]
        cell.reqid.text = rowData["Emp_Req_No"] as? String ?? ""
        cell.fdate.text = rowData["Leave_From"] as? String ?? ""
        cell.todate.text = rowData["Leave_to"] as? String ?? ""
        cell.duration.text = rowData["Lduration"] as? String ?? ""
        
        if let hodApprovalStatus = rowData["HOD_Approval"] as? String {
            cell.hodA.text = check(status: hodApprovalStatus)
            cell.hodA.textColor = sColor(status: hodApprovalStatus)
            
          
            if hodApprovalStatus == "A" {
             //   cell.canclebtn.isEnabled = false
                cell.canclebtn.isHidden = true
            } else {
          //      cell.canclebtn.isEnabled = true
                cell.canclebtn.isHidden = false
            }
        } else {
            cell.hodA.text = ""
            cell.hodA.textColor = .black
       //     cell.canclebtn.isEnabled = true
            cell.canclebtn.isHidden = false
        }
        
        cell.canclebtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reqNo = list[indexPath.row]["Emp_Req_No"] as? String ?? ""
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}
