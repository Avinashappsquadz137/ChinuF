//
//  SecondAssignedVC.swift
//  SanskarEP
//
//  Created by Surya on 28/09/24.
//

import UIKit

class SecondAssignedVC: UIViewController {

@IBOutlet weak var namelbl: UILabel!
@IBOutlet weak var channelLbl: UILabel!
@IBOutlet weak var dateLbl: UILabel!
@IBOutlet weak var timelbl: UILabel!
@IBOutlet weak var assigntxt: UITextField!
@IBOutlet weak var venuelbl: UILabel!
@IBOutlet weak var remarkstxt: UITextField!
@IBOutlet weak var tableview: UITableView!
@IBOutlet weak var assignview: UIView!
@IBOutlet weak var submitbtn: UIButton!
    
    var DataList  = [[String:Any]]()
    var selectedEmpcode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeData()
        selectTypeApi()
        assignview.isHidden = true
        tableview.isHidden = true
        
        tableview.dataSource = self
        tableview.delegate = self
    }
    func setup() {
        
        submitbtn.layer.cornerRadius = 10
        
        assigntxt.layer.cornerRadius = 10
        assigntxt.layer.borderWidth = 0.5
        assigntxt.layer.borderColor = UIColor.lightGray.cgColor
        
        remarkstxt.layer.cornerRadius = 10
        remarkstxt.layer.borderWidth = 0.5
        remarkstxt.layer.borderColor = UIColor.lightGray.cgColor
    }
@IBAction func submitbtn(_ sender: Any) {
 //   ReceptionApi()
    removeData()
    }
    
    
    @IBAction func assignbtn(_ sender: UIButton) {
        self.assignview.isHidden = !self.assignview.isHidden
        self.tableview.isHidden = !self.tableview.isHidden
    }
    
    func removeData() {
        assigntxt.text?.removeAll()
        remarkstxt.text?.removeAll()
    }
//    func ReceptionApi() {
//        var dict = Dictionary<String, Any>()
//        dict["EmpCode"] = currentUser.EmpCode
//        dict["sales_person"] = selectedEmpcode
//        dict["Remarks"] = remarkstxt.text
//        
//        DispatchQueue.main.async(execute: { Loader.showLoader() })
//        APIManager.apiCall(postData: dict as NSDictionary, url: receptionApi) { result, response, error, data in
//            DispatchQueue.main.async(execute: { Loader.hideLoader() })
//            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
//                if let dataArray = responseData["data"] as? [[String: Any]] {
//                    // Parse and update your datalist here
//                    self.DataList = dataArray
//                    // Reload the tableview
//                 //   self.tableview.reloadData()
//                    AlertController.alert(message: (response?.validatedValue("message"))!)
//                }
//            } else {
//                print(response?["error"] as Any)
//            }
//        }
//    }
    func selectTypeApi() {
        let dict = [String:Any]()
        APIManager.apiCall(postData: dict as NSDictionary, url: kathatypeApi) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }
            if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true {
                print(JSON)
                if let data = JSON["assign_booking_detail"] as? [[String:Any]] {
                    print(data)
                    self.DataList = data
                    print(self.DataList)
                
                    
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
}
extension SecondAssignedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "AssignCell1", for: indexPath)
        cell.textLabel?.text = DataList[indexPath.row]["Name"] as? String ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         selectedEmpcode = DataList[indexPath.row]
        let SelectedName = DataList[indexPath.row]["Name"] as? String ?? ""
        assigntxt.text = SelectedName
        self.tableview.isHidden = true
        self.assignview.isHidden = true
    }
    
}
