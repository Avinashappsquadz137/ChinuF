//
//  TourStatusVc.swift
//  SanskarEP
//
//  Created by Surya on 28/11/23.
//

import UIKit

class TourStatusVc: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var tabview: UIView!
 
    var reqNo = ""
    
    var type  = ""
    var list: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "statusTableViewCell", bundle: nil), forCellReuseIdentifier: "statusTableViewCell")
        getDetails()
    }
    
    @IBAction func backbtn(_ sender: Any) {
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
        dict["leave_type"] = "tour"
       
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kLeaveCancel) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                self.getDetails()
            }else{
                print(response?["error"] as Any)
            }
            self.tableview.reloadData()
        }
    }
    func getDetails() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["leave_type"] = "tour"
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
                    DispatchQueue.main.async {
                        self.tabview.isHidden = true
                   //     self.tableview.reloadData()
                    }
                    self.tableview.reloadData()
                }
            } else {
                print(response?["error"] as Any)
             
                // Display the error message on a label
                DispatchQueue.main.async {
                    self.Label1.text = response?.validatedValue("message")
                    self.tableview.isHidden = true
                }
            }
        }
    }
}
extension TourStatusVc: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return list.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "statusTableViewCell", for: indexPath) as! statusTableViewCell
        print(list)
        
        let rowData = list[indexPath.row]
        cell.reqId.text = rowData["Location"] as? String ?? ""
        cell.fromdate.text = rowData["from_date"] as? String ?? ""
        cell.todate.text = rowData["to_date"] as? String ?? ""
        if let hodApprovalStatus = rowData["Status"] as? String {
               cell.status.text = check(status: hodApprovalStatus)
               cell.status.textColor = sColor(status: hodApprovalStatus)
            
            if hodApprovalStatus == "A" {
             //   cell.canclebtn.isEnabled = false
                cell.cancelbtn.isHidden = true
            } else {
          //      cell.canclebtn.isEnabled = true
                cell.cancelbtn.isHidden = false
            }

            
           } else {
               cell.status.text = ""
               cell.status.textColor = .black
           }
        
        cell.cancelbtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}
