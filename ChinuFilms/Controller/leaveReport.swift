//
//  leaveReport.swift
//  SanskarEP
//
//  Created by Warln on 14/01/22.
//

import UIKit

class leaveReport: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLbL: UILabel!
    
    var report : [Any] = []
    var titleTxt: String?
    var type: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: kCell.leaveReport, bundle: nil), forCellReuseIdentifier: kCell.leaveReport)
        headerLbL.text = titleTxt
        getReport()
        
    }
    
    //MARK: - IBAction Button Pressed
    @IBAction func backBtnPressed(_ sender: UIButton ) {
        self.navigationController?.popViewController(animated: true)
            dismiss(animated: true,completion: nil)
    }
    
    func getReport() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["leave_type"] = type
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kleaveReport) { [self] result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let Json = data, (response?["status"] as? Bool == true), response != nil {
                print(Json)
                let rep = response?["data"] as? [Any] ?? []
                self.report = (rep[0] as? [Any] ?? [])
            }else{
                print(response?["error"] as Any)
            }
            tableView.reloadData()
        }
    }
    
    func check(status: String ) -> String {
        
        switch status {
        case "A":
            return " Approve"
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
            return .yellow
        case "XA":
            return .red
        case "X":
            return .purple
        default:
            return .black
        }
    }
    

}

//MARK: - UITableView Datascource

extension leaveReport: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if report.count > 0 {
            return report.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCell.leaveReport, for: indexPath) as? LeaveReqCell else {
            return UITableViewCell()
        }
        let index = (report[indexPath.row] as? [String:Any] ?? [:])
        if type == "full"{
            cell.requestId.text = (index["Emp_Req_No"] as? String ?? "")
            cell.dateLbl.text = "\(index["Leave_From"] as? String ?? "") to \(index["Leave_to"] as? String ?? "")"
            cell.noDays.text = (index["Lduration"] as? String ?? "")
            cell.status.text = check(status: (index["HOD_Approval"] as? String ?? ""))
            cell.status.textColor = sColor(status: (index["HOD_Approval"] as? String ?? ""))
        }else if type == "half"{
            cell.requestId.text = (index["ID"] as? String ?? "")
            cell.dateLbl.text = (index["RDate"] as? String ?? "")
            cell.status.text = check(status: index["Status"] as? String ?? "")
            cell.status.textColor = sColor(status:  index["Status"] as? String ?? "")
            cell.NDayView.isHidden = true
        }else if type == "tour"{
            cell.requestId.text = index["ID"] as? String ?? ""
            cell.dateLbl.text = "\(index["from_date"] as? String ?? "") to \(index["to_date"] as? String ?? "")"
            cell.status.text = check(status: index["Status"] as? String ?? "")
            cell.status.textColor = sColor(status: index["Status"] as? String ?? "")
            cell.NDayView.isHidden = true
        }else if type == "off"{
            
            cell.requestId.text = index["Emp_Req_No"] as? String ?? ""
            cell.dateLbl.text = (index["Leave_From"] as? String ?? "")
            cell.status.text = check(status: index["Status"] as? String ?? "")
            cell.status.textColor = sColor(status: index["Status"] as? String ?? "")
            cell.NDayView.isHidden = true
            
        }
        return cell
    }
    
    
}

extension leaveReport: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
