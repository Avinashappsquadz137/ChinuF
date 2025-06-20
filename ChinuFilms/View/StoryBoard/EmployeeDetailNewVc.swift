//
//  EmployeeDetailNewVc.swift
//  SanskarEP
//
//  Created by Surya on 06/12/24.
//

import UIKit

class EmployeeDetailNewVc: UIViewController {
    

@IBOutlet weak var Leavetypetext: UITextField!
@IBOutlet weak var Listview: UIView!
@IBOutlet weak var employeeListview: UITableView!
@IBOutlet weak var typetableview: UITableView!
    
    var type  = ""
    var list: [[String: Any]] = []
    var PLlist: [[String: Any]] = []
    let options = ["Full Day Leave Status", "Half Day Leave Status", "Off Day Request Status","Tour Request Status","PL Summary"]
    var selectedOption: String = ""
    var selectedText: String = ""
    var Datalist: [String: Any]?
    var EmpCod: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        employeeListview.dataSource = self
        employeeListview.delegate = self

        typetableview.dataSource = self
        typetableview.delegate = self
      
        
        Listview.isHidden = true
        typetableview.isHidden = true
        employeeListview.isHidden = true
        
        employeeListview.register(UINib(nibName: "TourStCell", bundle: nil), forCellReuseIdentifier: "TourStCell")
        employeeListview.register(UINib(nibName: "statusTableViewCell", bundle: nil), forCellReuseIdentifier: "statusTableViewCell")
        employeeListview.register(UINib(nibName: "PLCell", bundle: nil), forCellReuseIdentifier: "PLCell")
        employeeListview.register(UINib(nibName: "bdayviewcell", bundle: nil), forCellReuseIdentifier: "bdayviewcell")
        
        if let data = Datalist {
            EmpCod =  data["EmpCode"] as? String ?? ""

        }
    }
    

    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choosetypebtn(_ sender: UIButton) {
        self.Listview.isHidden = !self.Listview.isHidden
        self.typetableview.isHidden = !self.typetableview.isHidden
        self.selectedText = ""
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
            return .systemGreen
        case "R":
            return .systemBlue
        case "XA":
            return .systemRed
        case "X":
            return .systemPurple
        default:
            return .black
        }
    }
    
    func getDetails() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = EmpCod
        dict["leave_type"] = type
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
                    self.employeeListview.reloadData()
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
    
    func PlgetDetails() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = EmpCod
        list.removeAll()
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kplPlanel) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                let json = response?["data"] as? [[String:Any]] ?? [[:]]
                for i in json {
                    self.PLlist.append(i)
                }
            }else{
                print(response?["error"] as Any)
            }
            self.employeeListview.reloadData()
        }
    }
    func configurefulldaystatus(_ cell: TourStCell, indexPath: IndexPath) {
        let rowData = list[indexPath.row]
        cell.reqid.text = rowData["Emp_Req_No"] as? String ?? ""
        cell.fdate.text = rowData["Leave_From"] as? String ?? ""
        cell.todate.text = rowData["Leave_to"] as? String ?? ""
        cell.duration.text = rowData["Lduration"] as? String ?? ""
        
        if let hodApprovalStatus = rowData["HOD_Approval"] as? String {
            cell.hodA.text = check(status: hodApprovalStatus)
            cell.hodA.textColor = sColor(status: hodApprovalStatus)
//            if ["A", "XA", "X"].contains(hodApprovalStatus){
                cell.canclebtn.isHidden = true
//            } else {
//                cell.canclebtn.isHidden = false
//            }
        } else {
            cell.hodA.text = ""
            cell.hodA.textColor = .black
            cell.canclebtn.isHidden = false
        }
  //      cell.canclebtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
    }
    
    func configurehalfdayStatus(_ cell: statusTableViewCell, indexPath: IndexPath) {
        let rowData = list[indexPath.row]
        cell.reqId.text = rowData["ID"] as? String ?? ""
        cell.fromdate.text = rowData["RDate"] as? String ?? ""
        
        if let hodApprovalStatus = rowData["Status"] as? String {
            cell.status.text = check(status: hodApprovalStatus)
            cell.status.textColor = sColor(status: hodApprovalStatus)
            
//            if ["A", "XA", "X"].contains(hodApprovalStatus) {
                cell.cancelbtn.isHidden = true
//            } else {
//                cell.cancelbtn.isHidden = false
//            }
        } else {
            cell.status.text = ""
            cell.status.textColor = .black
        }
        
        cell.todate.isHidden = true
        cell.to.isHidden = true
   //     cell.cancelbtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
    }
    
    func configureoffdayStatus(_ cell: statusTableViewCell, indexPath: IndexPath) {
        let rowData = list[indexPath.row]
               cell.reqId.text = rowData["Emp_Req_No"] as? String ?? ""
               cell.fromdate.text = rowData["Leave_From"] as? String ?? ""
        if let hodApprovalStatus = rowData["Status"] as? String {
               cell.status.text = check(status: hodApprovalStatus)
               cell.status.textColor = sColor(status: hodApprovalStatus)
            
//            if ["A", "XA", "X"].contains(hodApprovalStatus) {
                cell.cancelbtn.isHidden = true
//            } else {
//                cell.cancelbtn.isHidden = false
//            }
           } else {
               cell.status.text = ""
               cell.status.textColor = .black
           }
        cell.todate.isHidden = true
        cell.to.isHidden = true
  //      cell.cancelbtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
    }
    
    func configuretourdayStatus(_ cell: statusTableViewCell, indexPath: IndexPath) {
        let rowData = list[indexPath.row]
        cell.reqId.text = rowData["Location"] as? String ?? ""
        cell.fromdate.text = rowData["from_date"] as? String ?? ""
        cell.todate.text = rowData["to_date"] as? String ?? ""
        if let hodApprovalStatus = rowData["Status"] as? String {
            
               cell.status.text = check(status: hodApprovalStatus)
               cell.status.textColor = sColor(status: hodApprovalStatus)
//            if ["A", "XA", "X"].contains(hodApprovalStatus){
                cell.cancelbtn.isHidden = true
//            } else {
//                cell.cancelbtn.isHidden = false
//            }
           } else {
               cell.status.text = ""
               cell.status.textColor = .black
           }
  //      cell.cancelbtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
    }
    
    func configurePlStatus(_ cell: PLCell, indexPath: IndexPath) {
        let index = indexPath.row
           cell.dateLbl.text = PLlist[index]["Date"] as? String ?? ""
        let Added = PLlist[index]["Credit"] as? String ?? ""
        let Deduct = PLlist[index]["Debit"] as? String ?? ""
        
        if Added.isEmpty || Added == ".00" {
                cell.creditLbl.isHidden = true
                cell.addedlbl.isHidden = true
                cell.debitLbl.isHidden = false
                cell.deducted.isHidden = false
                cell.debitLbl.text = Deduct
            } else {
                cell.creditLbl.isHidden = false
                cell.addedlbl.isHidden = false
                cell.creditLbl.text = Added
                cell.debitLbl.isHidden = true
                cell.deducted.isHidden = true
            }
        cell.balanceLbl.text = PLlist[index]["Balance"] as? String ?? ""
        cell.refrencelbl.text = PLlist[index]["Reference"] as? String ?? ""

    }
}
extension EmployeeDetailNewVc: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == employeeListview {
            switch selectedOption {
            case "PL Summary":
                return PLlist.count
            default:
                return list.count
            }
        } else if tableView == typetableview {
            return options.count
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == typetableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = options[indexPath.row] as? String ?? ""
            
            return cell
            
        } else if tableView == employeeListview {
            var cellIdentifier: String
            switch selectedOption {
            case "Full Day Leave Status":
                cellIdentifier = "TourStCell"
            case "Half Day Leave Status":
                cellIdentifier = "statusTableViewCell"
            case "Off Day Request Status":
                cellIdentifier = "statusTableViewCell"
            case "Tour Request Status":
                cellIdentifier = "statusTableViewCell"
            case "PL Summary":
                cellIdentifier = "PLCell"
            default:
                cellIdentifier = "TourStCell"
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            switch selectedOption {
            case "Full Day Leave Status":
                if let tourCell = cell as? TourStCell {
                    configurefulldaystatus(tourCell, indexPath: indexPath)
                }
            case "Half Day Leave Status":
                if let halfdaystatusCell = cell as? statusTableViewCell {
                    configurehalfdayStatus(halfdaystatusCell, indexPath: indexPath)
                }
            case "Off Day Request Status":
                if let offdaystatusCell = cell as? statusTableViewCell {
                    configureoffdayStatus(offdaystatusCell, indexPath: indexPath)
                }
            case "Tour Request Status":
                if let tourdaystatusCell = cell as? statusTableViewCell {
                    configuretourdayStatus(tourdaystatusCell, indexPath: indexPath)
                }
            case "PL Summary":
                if let PLSUMMARYCell = cell as? PLCell {
                    configurePlStatus(PLSUMMARYCell, indexPath: indexPath)
                }
            default:
                break
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == typetableview {
               self.selectedOption = options[indexPath.row]
               self.selectedText = options[indexPath.row]
                Leavetypetext.text = selectedText
            
               switch selectedOption {
               case "Full Day Leave Status":
                   self.type = "full"
               case "Half Day Leave Status":
                   self.type = "half"
               case "Off Day Request Status":
                   self.type = "off"
               case "Tour Request Status":
                   self.type = "tour"
               case "PL Summary":
                   self.type = "pl"
               default:
                   self.type = ""
               }
               
               // Reload employeeListview with new data
               self.Listview.isHidden = true
               self.typetableview.isHidden = true
               self.employeeListview.isHidden = false
               
               self.getDetails()
               self.PlgetDetails()
           } else if tableView == employeeListview {
            
        } else {
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == typetableview {
            return 40
        } else if tableView == employeeListview {
            switch selectedOption {
            case "Full Day Leave Status":
                return 140
            case "Half Day Leave Status":
                return 100
            case "Off Day Request Status":
                return 100
            case "Tour Request Status":
                return 100
            case "PL Summary":
                return 180
                
            default:
                return 60
            }
        } else {
            return 10
        }
        
    }
}
