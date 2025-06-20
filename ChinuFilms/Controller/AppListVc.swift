//
//  AppListVc.swift
//  SanskarEP
//
//  Created by Warln on 19/01/22.
//

import UIKit

class AppListVc: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var oneview: UIView!
    @IBOutlet weak var ApproveBtn: UIButton!
    @IBOutlet weak var RejectallBtn: UIButton!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var filterview: UIView!
    @IBOutlet weak var datepickerTxt: UITextField!
    @IBOutlet weak var datepickerText: UITextField!
    @IBOutlet weak var moveview: NSLayoutConstraint!
    
    var approveM = [[String:Any]]()
    var titleTxt: String?
    var type: String?
    var imageurl1 = "https://sap.sanskargroup.in/uploads/tour/"
    var fromDate: String?
    var toDate: String?
    
    var selectedRows: Set<Int> = []
    var selectedCheckboxes: Set<Int> = []
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: kCell.appList, bundle: nil), forCellReuseIdentifier: kCell.appList)
        tableView.delegate = self
        tableView.dataSource = self
        oneview.isHidden = true
        filterview.isHidden = true
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        setTitle()
        getDetails()
        setup()
       
        
        if #available(iOS 15.0, *) {
            sheetPresentationController?.prefersGrabberVisible = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            sheetPresentationController?.detents = [.large()]
        } else {
            
        }
    }
    
    func setup() {
        ApproveBtn.layer.cornerRadius = 5.0
    //    ApproveBtn.layer.borderWidth = 1.0
        RejectallBtn.layer.cornerRadius = 5.0
//      RejectallBtn.layer.borderWidth = 1.0
        
        datepickerTxt.layer.cornerRadius = 5.0
        datepickerText.layer.cornerRadius = 5.0
        
        submitbtn.layer.cornerRadius = 8.0
        filterview.layer.cornerRadius = 5.0
        oneview.layer.cornerRadius = 8
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @available(iOS 15.0, *)
    @IBAction func filterBtnPressed(_ sender: UIButton ) {
//        let vc = LeaveFilterVC()
//        vc.modalPresentationStyle = UIModalPresentationStyle.pageSheet
//        vc.delegate1 = self
//        guard let sheetController = vc.presentationController as? UISheetPresentationController else {
//            return
//        }
//        sheetController.detents = [.medium()]
//        sheetController.prefersGrabberVisible = true
//        present(vc, animated: true)
        filterview.isHidden = !filterview.isHidden
    }
    
    @IBAction func selectbutton(_ sender: UIButton) {
        oneview.isHidden = !oneview.isHidden
        
        if oneview.isHidden {
            // Hide OneView and adjust table view position
            let safeAreaInsetsTop = view.safeAreaInsets.top
            self.moveview.constant = safeAreaInsetsTop + 8
        } else {
            // Show OneView and adjust table view position
            self.moveview.constant = 60
        }
        if selectedRows.count == approveM.count {
                   selectedRows.removeAll()
            // Deselect all rows
           sender.setTitle("Select All", for: .normal)
               } else {
                   selectedRows = Set(0..<approveM.count)
                   // Change title to "Deselect All"
                   sender.setTitle("Deselect All", for: .normal)
               }
               tableView.reloadData()
           }
    
    @IBAction func AllApproveBtn(_ sender: UIButton) {
        for index in selectedRows {
               let data = approveM[index]
               getGrant(data["ID"] as? String ?? "", "granted")
           }
           // Remove the selected rows from the table
           approveM = approveM.enumerated().filter { !selectedRows.contains($0.offset) }.map { $0.element }
           selectedRows.removeAll()
           tableView.reloadData()
    }
    
    @IBAction func AllRejectBtn(_ sender: UIButton) {
        let selectedIDs = selectedRows.map { approveM[$0]["ID"] as? String ?? "" }
            
            // Perform rejection for all selected items
            for id in selectedIDs {
                getGrant(id, "declined")
            }
            
            // Remove the selected rows from the table
            approveM = approveM.filter { !selectedIDs.contains($0["ID"] as? String ?? "") }
            selectedRows.removeAll()
            tableView.reloadData()
    }
    
    @IBAction func datepicker1(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.datepickerTxt.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    @IBAction func datepicker2(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.datepickerText.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    @IBAction func submitbtn(_ sender: UIButton) {
        guard let fromDate = datepickerTxt.text, !fromDate.isEmpty,
                 let toDate = datepickerText.text, !toDate.isEmpty else {
               // Alert if any of the text fields are empty
               showAlert(message: "Please fill in both date fields.")
               return
           }
           
           // If both text fields are filled, proceed with the action
           filterApi()
       }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func clearFilterLabels() {
        // Clear text in the datepickerTxt and datepickerText fields
        datepickerTxt.text = ""
        datepickerText.text = ""
    }
    func getDetails() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["leave_type"] = type
        dict["fromDate"] = fromDate ?? ""
        dict["toDate"] = toDate ?? ""
  
       
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kAprrove) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            self.approveM.removeAll()
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                if let json = response?["data"] as? [Any] {
                    let jData = json[0] as? [[String:Any]] ?? [[:]]
                    print(jData)
                    self.approveM.append(contentsOf: jData)
                }
            }else{
                print(response?["error"] as Any)
            }

            self.tableView.reloadData()
        }
    }
    func filterApi() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["leave_type"] = type
        dict["fromDate"] = datepickerTxt.text
        dict["toDate"] = datepickerText.text

        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kAprrove) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            self.approveM.removeAll()
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                if let json = response?["data"] as? [Any] {
                    let jData = json[0] as? [[String:Any]] ?? [[:]]
                    print(jData)
                    self.approveM.append(contentsOf: jData)
                }
            }else{
                print(response?["error"] as Any)
            }

            self.tableView.reloadData()
            self.filterview.isHidden = true
            self.clearFilterLabels() 
        }
    }
    
    func getGrant(_ id: String, _ reply: String) {
        var dict = Dictionary<String,Any>()
        dict["req_id"] = id
        print(dict["req_id"])
        dict["reply"] = reply
        print(dict["reply"])
   
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kgrant) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                DispatchQueue.main.async {
                    self.getDetails()
                }
            }else{
                print(response?["error"] as Any)
            }
            self.tableView.reloadData()
            
        }
    }
    func updateApproveAllButtonTitle() {
        if selectedRows.count == approveM.count {
            ApproveBtn.setTitle("Approve All", for: .normal)
            RejectallBtn.setTitle("Reject All", for: .normal)
        } else {
            ApproveBtn.setTitle("Approve Selected", for: .normal)
            RejectallBtn.setTitle("Reject Selected", for: .normal)
        }
    }

    func setTitle() {
        switch type {
        case "full":
            headerLbl.text = "Full Day Request"
        case "half":
            headerLbl.text = "Half Day Request"
        case "off":
            headerLbl.text = "Off Day Request"
        case "tour":
            headerLbl.text = "Tour Day Request"
        case "WFH":
            headerLbl.text = "WHF Day Request"
        case "tour_request":
            headerLbl.text = "Tour Bill Approval"
        default:
            break
        }
    }
    @objc func checkboxTapped(_ sender: UIButton) {
           let rowIndex = sender.tag
           if selectedRows.contains(rowIndex) {
               selectedRows.remove(rowIndex)
           } else {
               selectedRows.insert(rowIndex)
           }
           tableView.reloadData()
       }
    
    @objc
    func AcceptOnClick(_ sender: UIButton ) {
        print(sender.tag)
        let index = approveM[sender.tag]
        getGrant(index["ID"] as? String ?? "", "granted")
        approveM.remove(at: sender.tag)
        tableView.reloadData()
       
    }
    
    @objc
    func rejectOnClick(_ sender: UIButton ) {
        print(sender.tag)
        let index = approveM[sender.tag]
        getGrant(index["ID"] as? String ?? "", "declined")
        approveM.remove(at: sender.tag)
        tableView.reloadData()
      
    }
//    func approveOrRejectAll(isApprove: Bool) {
//        for index in 0..<approveM.count {
//            let request = approveM[index]
//            let requestId = request["ID"] as? String ?? ""
//            let reply = isApprove ? "granted" : "declined"
//            getGrant(requestId, reply)
//        }
//        approveM.removeAll() // Clear the data source as all requests are either approved or rejected
//        tableView.reloadData()
//    }
    
}

//MARK: - Extension UItableView Datasoucre
extension AppListVc: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if approveM.count  > 0 {
            return approveM.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCell.appList, for: indexPath) as? AcceptCell else {
            return ApprovalCell()
        }
        let index = approveM[indexPath.row]
        if type == "full"{
            cell.requestId.text = ": \(index["ID"] as? String ?? "")"
            cell.emp.text = ": \(index["Name"] as? String ?? "")"
            cell.requestDate.text = ": \(index["req_date"] as? String ?? "")"
            cell.dateLbl.text = ": \(index["from_date"] as? String ?? "") to \(index["to_date"] as? String ?? "")"
            cell.reasonLbl.text = ": \(index["Reason"] as? String ?? "")"
            cell.hideShift.isHidden = true
            cell.reqHide.isHidden = true
            
            
        }else if type == "half"{
            cell.requestId.text = ": \(index["ID"] as? String ?? "")"
            cell.emp.text = ": \(index["Name"] as? String ?? "")"
            cell.requestDate.text = ": \(index["req_date"] as? String ?? "")"
            cell.dateLbl.text = ": \(index["from_date"] as? String ?? "")"
            cell.reasonLbl.text = ": \(index["Reason"] as? String ?? "")"
            cell.shiftLbl.text = ": \(index["daySihft"] as? String ?? "")"
            cell.reqHide.isHidden = true
            
            
        }else if type == "off"{
            cell.requestId.text = ": \(index["ID"] as? String ?? "")"
            cell.emp.text = ": \(index["Name"] as? String ?? "")"
            cell.requestDate.text = ": \(index["req_date"] as? String ?? "")"
            cell.dateLbl.text = ": \(index["from_date"] as? String ?? "")"
            cell.reasonLbl.text = ": \(index["Requirement"] as? String ?? "")"
            cell.hideShift.isHidden = true
            cell.reqHide.isHidden = true
            
            
        }else if type == "tour"{
            
            cell.requestId.text = ": \(index["ID"] as? String ?? "")"
            cell.emp.text = ": \(index["Name"] as? String ?? "")"
            cell.requestDate.text = ": \(index["req_date"] as? String ?? "")"
            cell.dateLbl.text = ": \(index["from_date"] as? String ?? "") to \(index["to_date"] as? String ?? "")"
            cell.reasonLbl.text = ": \(index["Reason"] as? String ?? "")"
            cell.hideShift.text = "Location"
            cell.shiftLbl.text = ": \(index["Location"] as? String ?? "")"
            cell.reqLbl.text = ": \(index["Requirement"] as? String ?? "")"
            
            
            
        }else if type == "WFH"{
            
            cell.requestId.text = ": \(index["ID"] as? String ?? "")"
            cell.emp.text = ": \(index["Name"] as? String ?? "")"
            cell.requestDate.text = ": \(index["req_date"] as? String ?? "")"
            cell.dateLbl.text = ": \(index["from_date"] as? String ?? "") to \(index["to_date"] as? String ?? "")"
            cell.reasonLbl.text = ": \(index["Reason"] as? String ?? "")"
            cell.hideShift.isHidden = true
            cell.reqHide.isHidden = true
            
            
        }else if type == "tour_request"{
          
              //  cell.requestId.text = "Tour_id"
                cell.requestId.text = ": \(index["Tour_id"] as? String ?? "")"
               // cell.emp.text = "EmpCode"
                cell.emp.text = ": \(index["EmpCode"] as? String ?? "")"
                cell.reasonLbl.text = ": \(index["reason"] as? String ?? "")"
                cell.hideShift.text = "Amount"
                cell.shiftLbl.text = ": \(index["Amount"] as? String ?? "")"
                cell.reqHide.isHidden = true
                cell.dateLbl.isHidden = true
                cell.requestDate.isHidden = true
            
                var img = imageurl1 + "\(index["Billing_thumbnail"] as? String ?? "")"
                var img1 = img.replacingOccurrences(of: " ", with: "")
                print(img1)
               cell.setImage(with: img1)
            }
        
            cell.setImage(with: index["image"] as? String ?? "")
            cell.acceptBtN.tag = indexPath.row
            cell.rejectBtn.tag = indexPath.row
            cell.acceptBtN.addTarget(self, action: #selector(AcceptOnClick(_:)), for: .touchUpInside)
            cell.rejectBtn.addTarget(self, action: #selector(rejectOnClick(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
    
        if selectedRows.contains(indexPath.row) {
              cell.checkbtn.setImage(UIImage(named: "check-mark 1"), for: .normal)
          } else {
              cell.checkbtn.setImage(UIImage(named: "checkmark"), for: .normal)
          }
        
              cell.checkbtn.tag = indexPath.row
              cell.checkbtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
              updateApproveAllButtonTitle()
    
            return cell
        }
    
    }

    
    //MARK: - Extension UITableView Delegate
    
extension AppListVc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedRows.contains(indexPath.row) {
            selectedRows.remove(indexPath.row)
        } else {
            selectedRows.insert(indexPath.row)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}
    class TourApp:UITableViewCell{
            }
extension AppListVc: FilterVCDelegate1 {
    func didGetDate1(with start: String, with end: String) {
        DispatchQueue.main.async {
            self.fromDate = start
            self.toDate = end
            self.getDetails()
        }
    }
    
}
