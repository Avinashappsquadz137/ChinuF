//
//  AllStatusVc.swift
//  SanskarEP
//
//  Created by Surya on 01/03/24.
//

import UIKit
import iOSDropDown

class AllStatusVc: UIViewController {
    
@IBOutlet weak var LabelView: UIView!
@IBOutlet weak var selectText: DropDown!
@IBOutlet weak var headerLbl: UILabel!
@IBOutlet weak var tableview: UITableView!
@IBOutlet weak var upimage: UIImageView!
@IBOutlet weak var Selected: UISegmentedControl!
@IBOutlet weak var myreportview: UIView!
@IBOutlet weak var Allreportview: UIView!
@IBOutlet weak var searchbar: UISearchBar!
@IBOutlet weak var myreportv: NSLayoutConstraint!
@IBOutlet weak var tableviewheight: NSLayoutConstraint!
@IBOutlet weak var reasonview: UIView!
@IBOutlet weak var submit: UIButton!
@IBOutlet weak var reasontext: UITextView!
@IBOutlet weak var msglbl: UILabel!
    
    
    
    var getLeaveRequestList = [Datas]()
    var PLlist: [[String: Any]] = []
    var DetailData = [[String:Any]]()
    var reqNo = ""
    var type  = ""
    var LeaveType = ""
    var selectedOption: String = ""
    var filteredDetailData: [[String: Any]] = []

    
    let options = ["Full Day Leave Status", "Half Day Leave Status", "Off Day Request Status","Tour Request Status","PL Summary"]
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        EmployeeDetailAPi()
        
        reasonview.isHidden = true
        adjust()
        submit.layer.cornerRadius = 8
        tableviewheight.constant = -40
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: "TourStCell", bundle: nil), forCellReuseIdentifier: "TourStCell")
        tableview.register(UINib(nibName: "PLCell", bundle: nil), forCellReuseIdentifier: "PLCell")
        tableview.register(UINib(nibName: "bdayviewcell", bundle: nil), forCellReuseIdentifier: "bdayviewcell")
        searchbar.delegate = self
        filteredDetailData = DetailData
        
 //       setupDropDown()
        
        reasontext.delegate = self
        reasontext.layer.cornerRadius = 10
        reasontext.clipsToBounds = true
     
        reasontext.textColor = UIColor.lightGray
        reasontext.layer.borderWidth = 1
        
        myreportview.isHidden =  true
        Allreportview.isHidden =  true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func adjust(){
        if  currentUser.Code == "H" {
            Selected.isHidden = false
        } else {
            Selected.isHidden = true
            myreportv.constant = -35
        }
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func clearbtn(_ sender: UIButton) {
        reasonview.isHidden = true
    }
    
    
    @IBAction func submitbtn(_ sender: UIButton) {
        cancelApi() 
        reasonview.isHidden = true
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
    
    @IBAction func Selected(_ sender: UISegmentedControl) {
        if Selected.selectedSegmentIndex == 0 {
       //     myreportview.isHidden =  false
            Allreportview.isHidden =  true
            tableviewheight.constant = -40
        } else if Selected.selectedSegmentIndex == 1 {
            Allreportview.isHidden =  false
            myreportview.isHidden =  true
            tableviewheight.constant = 10
        }
        updateNoNotificationLabel()
        tableview.reloadData()
       
    }
    
        
    func EmployeeDetailAPi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        
        DispatchQueue.main.async { Loader.showLoader() }
        
        APIManager.apiCall(postData: dict as NSDictionary, url: EmployeeListApi) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }
            
            if let responseData = response, responseData["status"] as? Bool == true {
                if let JSON = responseData["data"] as? [[String: Any]] {
                    self.DetailData = JSON
                    self.filteredDetailData = JSON
                    
                    DispatchQueue.main.async {
                        self.updateNoNotificationLabel()
                        self.tableview.reloadData()
                    }
                }
            } else {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                print(response?["error"] as Any)
            }
        }
    }

        
    func updateNoNotificationLabel() {
        DispatchQueue.main.async {
            if self.Selected.selectedSegmentIndex == 1 {
                let isEmpty = self.filteredDetailData.isEmpty
                self.msglbl.isHidden = !isEmpty
                self.msglbl.text = isEmpty ? "No Data Available" : ""
            } else if  self.Selected.selectedSegmentIndex == 0 {
                let isEmpty = self.getLeaveRequestList.isEmpty
                self.msglbl.isHidden = !isEmpty
                self.msglbl.text = isEmpty ? "No Data Available" : ""
            }
        }
    }

    
    func cancelApi() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["RequestId"] = reqNo
        dict["leave_type"] = LeaveType
        dict["reason"] = reasontext.text
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
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: status) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            guard let data = data, error == nil else {
                AlertController.alert(message: error?.localizedDescription ?? "")
                return
            }
            do{
                let json = try JSONDecoder().decode(GetLeaveRequestList.self, from: data)
                self.getLeaveRequestList.append(contentsOf: json.data ?? [])
                DispatchQueue.main.async {
              //      AlertController.alert(message: (response?.validatedValue("message"))!)
                    self.tableview.reloadData()
                }
            }catch{
                print(error.localizedDescription)
            }
        }
    }
   
    
    @objc func Checkboxtapped(_ sender: UIButton) {
        self.reasonview.isHidden = !self.reasonview.isHidden
    }
    
    func PlgetDetails() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        getLeaveRequestList.removeAll()
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
            self.tableview.reloadData()
        }
    }
}


extension AllStatusVc: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Selected.selectedSegmentIndex == 1 {
            return filteredDetailData.count
           } else if Selected.selectedSegmentIndex == 0 {
               return getLeaveRequestList.count
           }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Selected.selectedSegmentIndex == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "bdayviewcell", for: indexPath) as? bdayviewcell else {
                return UITableViewCell()
            }
            let index = filteredDetailData[indexPath.row]
            cell.MyLbl.text = "\(index["name"] as? String ?? "")"
            cell.MyLbl2.text = "\(index["EmpCode"] as? String ?? "")"
            cell.mylbl3.text = "\(index["Dept"] as? String ?? "")"
            let imageData = index["EmpImage"] as? String ?? ""
            let imgURL = imageData.replacingOccurrences(of: " ", with: "%20")
            cell.MyImage.image = nil
            cell.MyImage.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "placeholder"))
       //     cell.message.isHidden = true
            cell.msgbtn.isHidden = true
            cell.terminatedbtn.isHidden = true
            return cell
        }


        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TourStCell", for: indexPath) as? TourStCell else {
            return UITableViewCell()
        }
        let rowData = getLeaveRequestList[indexPath.row]
        reqNo =  "\(rowData.sno ?? 0)"
        cell.reqid.text = "\(rowData.sno ?? 0)"
        cell.fdate.text = rowData.date1
        cell.todate.text = rowData.date2
        cell.duration.text = ""
        LeaveType = rowData.leave_type ?? ""
        cell.leavetype.text = rowData.leave_type
        cell.hodA.text = rowData.status
        
        if rowData.leave_type == "half" {
            cell.todate.isHidden = true
            cell.tolbl.isHidden = true
        } else {
            cell.todate.isHidden = false
            cell.tolbl.isHidden = false
        }

        var rowdata = rowData.leave_can
        if rowdata == 0 {
            cell.canclebtn.isHidden = false
        } else {
            cell.canclebtn.isHidden = true
        }

        cell.canclebtn.tag = indexPath.row
        cell.canclebtn.addTarget(self, action: #selector(Checkboxtapped(_:)), for: .touchUpInside)
           return cell
       }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Selected.selectedSegmentIndex == 1 {
                let vc = storyboard!.instantiateViewController(withIdentifier: "ReportAllVc") as! ReportAllVc
    //        vc.Datalist = filteredDetailData[indexPath.row]
               let selectedData = filteredDetailData[indexPath.row]
                   let empCode = selectedData["EmpCode"] as? String ?? ""
                   let empname = selectedData["name"] as? String ?? ""
                   let empdepart = selectedData["Dept"] as? String ?? ""
                   let empimage = selectedData["EmpImage"] as? String ?? ""
                   vc.empCode = empCode
                   vc.empname = empname
                   vc.empdepart = empdepart
                   vc.empimage = empimage
            
            
                if #available(iOS 15.0, *) {
                    if let sheet = vc.sheetPresentationController {
                        var customDetent: UISheetPresentationController.Detent?
                        if #available(iOS 16.0, *) {
                            customDetent = UISheetPresentationController.Detent.custom { context in
                                return 520
                            }
                            sheet.detents = [customDetent!]
                            sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                        }
                        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                        sheet.prefersGrabberVisible = true
                        sheet.preferredCornerRadius = 12
                    }
                }
                present(vc, animated: true, completion: nil)
            

        } else {
//            if selectedOption != "PL Summary" {
//                      reqNo = list[indexPath.row]["Emp_Req_No"] as? String ?? ""
//                  }
        }
        
        }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Selected.selectedSegmentIndex == 1 {
            return 120
        } else  if Selected.selectedSegmentIndex == 0 {

                return 165
            }
        return 0
    }
}

extension AllStatusVc: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.isEmpty {
               filteredDetailData = DetailData
           } else {
               filteredDetailData = DetailData.filter { data in
                   let empCode = (data["EmpCode"] as? String ?? "").lowercased()
                   let name = (data["name"] as? String ?? "").lowercased()
                   return empCode.contains(searchText.lowercased()) || name.contains(searchText.lowercased())
               }
           }
           tableview.reloadData()
       }
}
extension AllStatusVc : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (reasontext.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if reasontext.textColor == UIColor.lightGray {
            reasontext.text = ""
            reasontext.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if reasontext.text == "" {

            reasontext.text = ""
            reasontext.textColor = UIColor.black
        }
    }
}
