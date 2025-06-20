//
//  ApprovalLitNewVc.swift
//  SanskarEP
//
//  Created by Surya on 08/08/24.
//

import UIKit

class ApprovalLitNewVc: UIViewController {
    
    
    
    @IBOutlet weak var Mainview: UIView!
    @IBOutlet weak var Leaveview: UIView!
    @IBOutlet weak var Bookingview: UIView!
    @IBOutlet weak var TourView: UIView!
    @IBOutlet weak var LeaveDetailview: UIView!
    @IBOutlet weak var Leavetableview: UITableView!
    @IBOutlet weak var Bookingdetailview: UIView!
    @IBOutlet weak var TourDetaiview: UIView!
    @IBOutlet weak var BookingTableview: UITableView!
    @IBOutlet weak var TourTableview: UITableView!
    @IBOutlet weak var Leavebtn: UIButton!
    @IBOutlet weak var BookingBtn: UIButton!
    @IBOutlet weak var TourBtn: UIButton!
    @IBOutlet weak var Allselectview: UIView!
    @IBOutlet weak var Deselectview: UIView! 
    @IBOutlet weak var selectbtn: UIButton!
    @IBOutlet weak var openselectview: NSLayoutConstraint!
    @IBOutlet weak var AllApprovebtn: UIButton!
    @IBOutlet weak var RejectAllbtn: UIButton!
    @IBOutlet weak var Leaveimageview: UIImageView!
    @IBOutlet weak var Bookingimageview: UIImageView!
    @IBOutlet weak var Tourimageview: UIImageView!
    @IBOutlet weak var heightcons: NSLayoutConstraint!
    @IBOutlet weak var bookingallselective: UIView!
    @IBOutlet weak var bookingdeselectview: UIView!
    @IBOutlet weak var bookingallapprovebtn: UIButton!
    @IBOutlet weak var bookingallrejectbtn: UIButton!
    @IBOutlet weak var bookingall: UIButton!
    @IBOutlet weak var tourtablens: NSLayoutConstraint!
    
    
    var Datalist = [[String:Any]]()
    var datalist = [[String:Any]]()
    var approveM = [[String:Any]]()
    var type: String?
    var fromDate: String?
    var toDate: String?
    var imageurl1 = "https://sap.sanskargroup.in/uploads/tour/"
    var selectedRows: Set<Int> = []
    var selectedCheckboxes: Set<Int> = []
    
    var selectedBookingRows: Set<Int> = []
    
    var selectedTourRows: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        bookingdetailapi()
        HODdetail()
        
        type = "All"
        LeaveDetailview.isHidden = false
        Bookingdetailview.isHidden = true
        TourDetaiview.isHidden = true
        Allselectview.isHidden = false
        Deselectview.isHidden = true
        AllApprovebtn.layer.cornerRadius = 8
        RejectAllbtn.layer.cornerRadius = 8
        
        bookingallapprovebtn.layer.cornerRadius = 8
        bookingallrejectbtn.layer.cornerRadius = 8
        //   selectbtn.isHidden = true
        
        Leavetableview.delegate = self
        Leavetableview.dataSource = self
        Leavetableview.register(UINib(nibName: "allapproveCell", bundle: nil), forCellReuseIdentifier: "allapproveCell")
        Leavetableview.register(UINib(nibName: "apptourCell", bundle: nil), forCellReuseIdentifier: "apptourCell")
        
        BookingTableview.delegate = self
        BookingTableview.dataSource = self
        BookingTableview.register(UINib(nibName: "NewApprovalBookingCell", bundle: nil), forCellReuseIdentifier: "NewApprovalBookingCell")
        
        TourTableview.delegate = self
        TourTableview.dataSource = self
        TourTableview.register(UINib(nibName: "NewApprovalTourCell", bundle: nil), forCellReuseIdentifier: "NewApprovalTourCell")
        LeavebtnAction(Leavebtn)
        

        if currentUser.EmpCode == "SANS-00042" {
            TourView.isHidden = false
            Bookingview.isHidden = true
            Leaveview.isHidden = false
          
        } else  if currentUser.EmpCode == "SANS-00079" || currentUser.EmpCode == "SANS-00082" {
            Bookingview.isHidden = false
            Leaveview.isHidden = false
            TourView.isHidden = true
        
        } else {
          
            TourView.isHidden = true
            Leaveview.isHidden = true
            Bookingview.isHidden = true
            heightcons.constant = -20
        }
        getDetails()
        Leavetableview.reloadData()
        
        bookingdeselectview.isHidden = true
        bookingallselective.isHidden = true
    }
  
    
    @IBAction func LeavebtnAction(_ sender: UIButton) {
        bookingallselective.isHidden = true
        Allselectview.isHidden = false

        type = "All"
        getDetails()
        Leaveimageview.image = UIImage(named : "radioimage")
        Bookingimageview.image = UIImage(named : "radio")
        Tourimageview.image = UIImage(named : "radio")
        
     
        LeaveDetailview.isHidden = false
        //!self.LeaveDetailview.isHidden
        Bookingdetailview.isHidden = true
        TourDetaiview.isHidden = true
        self.Leavetableview.reloadData()
        //Deselectview.isHidden = true
        Allselectview.isHidden = false
        if Allselectview.isHidden {
            let safeAreaInsetsTop = view.safeAreaInsets.top
            self.openselectview.constant = safeAreaInsetsTop + 10
        } else {
            self.openselectview.constant = 10
        }
    }
    
   
    
    @IBAction func BookigBtn(_ sender: Any) {
        bookingallselective.isHidden = false
        Allselectview.isHidden = true
        
        Leaveimageview.image = UIImage(named : "radio")
        Bookingimageview.image = UIImage(named : "radioimage")
        Tourimageview.image = UIImage(named : "radio")
        
        Bookingdetailview.isHidden = false
        LeaveDetailview.isHidden = true
        TourDetaiview.isHidden = true
        self.BookingTableview.reloadData()
       // Deselectview.isHidden = true
        Allselectview.isHidden = false
        
        if bookingallselective.isHidden {
            let safeAreaInsetsTop = view.safeAreaInsets.top
            self.openselectview.constant = safeAreaInsetsTop + 10
        } else {
            self.openselectview.constant = 10
        }

    }
    
    
    @IBAction func TouBtn(_ sender: UIButton) {
        Leaveimageview.image = UIImage(named : "radio")
        Bookingimageview.image = UIImage(named : "radio")
        Tourimageview.image = UIImage(named : "radioimage")
        
        TourDetaiview.isHidden = false
        LeaveDetailview.isHidden = true
        Bookingdetailview.isHidden = true
        self.TourTableview.reloadData()
 //       Deselectview.isHidden = true
        Allselectview.isHidden = true
        bookingallselective.isHidden = true
        tourtablens.constant = -60
//        if Allselectview.isHidden {
//            let safeAreaInsetsTop = view.safeAreaInsets.top
//            self.openselectview.constant = safeAreaInsetsTop + 10
//        } else {
//            self.openselectview.constant = 10
//        }
    }
    
   
    @IBAction func leaveallselect(_ sender: UIButton) {
        if selectedRows.count == approveM.count {
               selectedRows.removeAll()
               sender.setTitle("Select", for: .normal)
               Deselectview.isHidden = true
           } else {
               selectedRows = Set(0..<approveM.count)
               sender.setTitle("Deselect", for: .normal)
               Deselectview.isHidden = false
           }
           Leavetableview.reloadData()
    }
    
    
    @IBAction func bookingallselectbtn(_ sender: UIButton) {
        
        if selectedBookingRows.count == Datalist.count {
            selectedBookingRows.removeAll()
           sender.setTitle("Select", for: .normal)
            bookingdeselectview.isHidden = true
               } else {
                   selectedBookingRows = Set(0..<Datalist.count)
                   sender.setTitle("Deselect", for: .normal)
                   bookingdeselectview.isHidden = false
               }
               BookingTableview.reloadData()
           
    }
    
    func getDetails() {
        var dict = [String: Any]()
        dict["EmpCode"] = currentUser.EmpCode
        dict["leave_type"] = "All"
        dict["fromDate"] = fromDate ?? ""
        dict["toDate"] = toDate ?? ""

        DispatchQueue.main.async {
            Loader.showLoader()
        }

        APIManager.apiCall(postData: dict as NSDictionary, url: kAprrove) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }
            self.approveM.removeAll()

            if let data = data, response?["status"] as? Bool == true {
                if let json = response?["data"] as? [[String: Any]] {
                    self.approveM.append(contentsOf: json)
                }
            } else {
                print(response?["error"] as Any)
            }

            DispatchQueue.main.async {
                self.Leavetableview.reloadData()
            }
        }
    }

    
    @objc func checkboxTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        if selectedRows.contains(rowIndex) {
            selectedRows.remove(rowIndex)
        } else {
            selectedRows.insert(rowIndex)
        }

        // If all rows are selected, update button title
        if selectedRows.count == approveM.count {
            selectbtn.setTitle("Deselect", for: .normal)
            Deselectview.isHidden = false
        } else {
            selectbtn.setTitle("Select", for: .normal)
        }
        
        Leavetableview.reloadData()
    }

    
    @objc func CheckboxTapped(_ sender: UIButton) {
//           let rowIndex = sender.tag
//           if selectedBookingRows.contains(rowIndex) {
//               selectedBookingRows.remove(rowIndex)
//           } else {
//               selectedBookingRows.insert(rowIndex)
//           }
//           BookingTableview.reloadData()
        let rowIndex = sender.tag
        if selectedBookingRows.contains(rowIndex) {
            selectedBookingRows.remove(rowIndex)
        } else {
            selectedBookingRows.insert(rowIndex)
        }

        // If all rows are selected, update button title
        if selectedBookingRows.count == Datalist.count {
            bookingall.setTitle("Deselect", for: .normal)
            bookingdeselectview.isHidden = false
        } else {
            bookingall.setTitle("Select", for: .normal)
        }
        
        BookingTableview.reloadData()
       }
    
    @objc func Checkboxtapped(_ sender: UIButton) {
        let index = sender.tag

        let sno = datalist[index]["Sno"] as? Int ?? 0
        let requestAmount = datalist[index]["Amount"] as? String ?? ""
        let empcode = datalist[index]["EmpCode"] as? String ?? ""
        let tour = datalist[index]["TourID"] as? String ?? ""
        let date = datalist[index]["Date1"] as? String ?? ""
        let date1 = datalist[index]["Date2"] as? String ?? ""
        let location = datalist[index]["Location"] as? String ?? ""
        let approvedAmount = datalist[index]["Approval_Amount"] as? String ?? ""
        let status = datalist[index]["Status"] as? String ?? ""
        let empname = datalist[index]["Name"] as? String ?? ""

        let vc = storyboard?.instantiateViewController(withIdentifier: "HODAllDetail2VC") as! HODAllDetail2VC

        vc.heamt = requestAmount
        vc.hemco = empcode
        vc.hemn  = empname
        vc.htour = tour
        vc.location = location
        vc.hdat1 = date
        vc.hdat2 = date1
        vc.hsno = String(sno)
        vc.haamt = approvedAmount
        vc.hst = status

        self.present(vc, animated: true, completion: nil)
    }

    
    func getGrant(_ id: [String], _ reply: String) {
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
            self.Leavetableview.reloadData()
            
        }
    }

    @objc
    func LeaveAcceptOnClick(_ sender: UIButton) {
        print(sender.tag)
        let index = approveM[sender.tag]
        if let id = index["ID"] as? String {
            getGrant([id], "granted")
        }
        approveM.remove(at: sender.tag)
        Leavetableview.reloadData()
    }

    
    @objc
    func LeaverejectOnClick(_ sender: UIButton ) {
        print(sender.tag)
        let index = approveM[sender.tag]
    //    getGrant(index["ID"] as? String ?? "", "declined")
        if let id = index["ID"] as? String {
            getGrant([id], "declined")
        }
        approveM.remove(at: sender.tag)
        Leavetableview.reloadData()
      
    }
    
    func updateApproveAllButtonTitle() {
        if selectedRows.count == approveM.count {
            AllApprovebtn.setTitle("Approve All", for: .normal)
            RejectAllbtn.setTitle("Reject All", for: .normal)
        } else {
            AllApprovebtn.setTitle("Approve", for: .normal)
            RejectAllbtn.setTitle("Reject", for: .normal)
        }
    }
    
    func updateApproveAllButtonTitle1() {
        if selectedBookingRows.count == Datalist.count {
            bookingallapprovebtn.setTitle("Approve All", for: .normal)
            bookingallrejectbtn.setTitle("Reject All", for: .normal)
        } else {
            bookingallapprovebtn.setTitle("Approve", for: .normal)
            bookingallrejectbtn.setTitle("Reject", for: .normal)
        }
    }
    
    func approveBooking(_ bookingIds: [String], _ status: String) {
        var dict = Dictionary<String, Any>()
        dict["katha_id"] = bookingIds.map { String($0) }
        dict["EmpCode"] = currentUser.EmpCode
        dict["status"] = status

        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: hodBApprovalApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                DispatchQueue.main.async {
                    self.BookingTableview.reloadData()
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }

    @objc
    func BookingAcceptonClick(_ sender: UIButton) {
        let index = Datalist[sender.tag]
        if let id = index["Katha_id"] as? String {
            approveBooking([id],  "1")
        }
        Datalist.remove(at: sender.tag)
        BookingTableview.reloadData()
    }

    
    @objc
    func BookingrejectonClick(_ sender: UIButton ) {
        let index = Datalist[sender.tag]
        if let id = index["Katha_id"] as? String {
            approveBooking([id],  "2")
        }
        Datalist.remove(at: sender.tag)
        BookingTableview.reloadData()
    }
    
    @objc
    func TouracceptonClick(_ sender: UIButton ) {
//        print(sender.tag)
//        let index = datalist[sender.tag]
//        getGrant([index["ID"] as? String ?? ""], "granted" )
//        datalist.remove(at: sender.tag)
//        TourTableview.reloadData()
       
    }
    
    @objc
    func TourRejectonClick(_ sender: UIButton ) {
//        print(sender.tag)
//        let index = datalist[sender.tag]
//        getGrant([index["ID"] as? String ?? ""], "declined")
//        datalist.remove(at: sender.tag)
//        TourTableview.reloadData()
      
    }
    

    @IBAction func AllApproveBtn(_ sender: UIButton) {
     
        var ids: [String] = []

        for index in selectedRows {
            if let id = approveM[index]["ID"] as? String {
                ids.append(id)
            }
        }
        if !ids.isEmpty {
            getGrant(ids, "granted")
        }
        
        approveM = approveM.enumerated().filter { !selectedRows.contains($0.offset) }.map { $0.element }
        selectedRows.removeAll()
        Leavetableview.reloadData() 
    }
    
    @IBAction func AllRejectBtn(_ sender: UIButton) {

        var ids: [String] = []

        for index in selectedRows {
            if let id = approveM[index]["ID"] as? String {
                ids.append(id)
            }
        }
        if !ids.isEmpty {
            getGrant(ids, "declined")
        }
        approveM = approveM.enumerated().filter { !selectedRows.contains($0.offset) }.map { $0.element }
        selectedRows.removeAll()
        Leavetableview.reloadData()
    }
    
    @IBAction func bookingallselet(_ sender: UIButton) {
        var ids: [String] = []

        for index in selectedBookingRows {
            if let id = Datalist[index]["Katha_id"] as? String {
                ids.append(id)
            }
        }
        if !ids.isEmpty {
            approveBooking(ids, "1")
        }
        
        Datalist = Datalist.enumerated().filter { !selectedBookingRows.contains($0.offset) }.map { $0.element }
        selectedBookingRows.removeAll()
        BookingTableview.reloadData()
    }
    
    
    @IBAction func bookingallreject(_ sender: UIButton) {
        var ids: [String] = []

        for index in selectedBookingRows {
            if let id = Datalist[index]["Katha_id"] as? String {
                ids.append(id)
            }
        }
        if !ids.isEmpty {
            approveBooking(ids, "2")
        }
        
        Datalist = Datalist.enumerated().filter { !selectedBookingRows.contains($0.offset) }.map { $0.element }
        selectedBookingRows.removeAll()
        BookingTableview.reloadData()
    }
    
    func bookingdetailapi() {
        var dict = Dictionary<String, Any>()
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: katha_booking_detailApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true {
                print(JSON)
                if let data = JSON["data"] as? [[String:Any]] {
                    print(data)
                    self.Datalist = data
                    print(self.Datalist)
                    DispatchQueue.main.async {
                       self.BookingTableview.reloadData()
                    }
                }
            }  else {
                
              //  AlertController.alert(message: (response?.validatedValue("message"))!)
            }
            self.BookingTableview.reloadData()
        }
    }
    
    func HODdetail() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        APIManager.apiCall(postData: dict as NSDictionary, url: HODdetails) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    self.datalist = data
                }
            }
            else {
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
            self.TourTableview.reloadData()
        }
    }
}

extension ApprovalLitNewVc: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == Leavetableview {
                   return approveM.count
               } else if tableView == BookingTableview {
                   return Datalist.count
               } else if tableView == TourTableview {
                   return datalist.count
               }
               
               return 0
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == Leavetableview {
            let item = approveM[indexPath.row]
               let leaveType = item["leave_type"] as? String ?? ""
               if leaveType == "full" || leaveType == "half" || leaveType == "tour" || leaveType == "WFH" {
                   guard let cell = tableView.dequeueReusableCell(withIdentifier: "apptourCell", for: indexPath) as? apptourCell else {
                       return UITableViewCell()
                   }
                   cell.name.text = item["Name"] as? String ?? ""
                   cell.dept.text = item["Dept"] as? String ?? ""
                   cell.reason.text = item["Reason"] as? String ?? ""
                   cell.location.text = item["Location"] as? String ?? ""
                   cell.type.text = item["leave_type"] as? String ?? ""
                   cell.requ.text = item["Requirement"] as? String ?? ""
                
                if  leaveType == "half" {
                    cell.datelbl.text = item["from_date"] as? String ?? ""
                } else {
                    cell.datelbl.text = "\(item["from_date"] as? String ?? "") to \(item["to_date"] as? String ?? "")"
                }

                  cell.setImage(with: item["image"] as? String ?? "")
                   if selectedRows.contains(indexPath.row) {
                       cell.checkbtn.setImage(UIImage(named: "check"), for: .normal)
                   } else {
                       cell.checkbtn.setImage(UIImage(named: "Uncheck"), for: .normal)
                   }
                   cell.checkbtn.tag = indexPath.row
                   cell.checkbtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
                   cell.approvebtn.tag = indexPath.row
                cell.approvebtn.addTarget(self, action: #selector(LeaveAcceptOnClick(_:)), for: .touchUpInside)
                   cell.rejectbtn.tag = indexPath.row
                cell.rejectbtn.addTarget(self, action: #selector(LeaverejectOnClick(_:)), for: .touchUpInside)
                  cell.selectionStyle = .none
                   updateApproveAllButtonTitle()
                   return cell
               }
            
        } else if tableView == BookingTableview {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewApprovalBookingCell", for: indexPath) as? NewApprovalBookingCell else {
                return NewApprovalBookingCell()
            }
            let Amount = Datalist[indexPath.row]["Amount"] as? String ?? ""
             cell.Amountlbl.text = Amount
            let Channel = Datalist[indexPath.row]["ChannelName"] as? String ?? ""
            
             cell.ChannelLbl.text = "(" + Channel + ")"
            let KathaTime = Datalist[indexPath.row]["KathaTiming"] as? String ?? ""
             cell.TimeLbl.text = KathaTime
            let Venue = Datalist[indexPath.row]["Venue"] as? String ?? ""
             cell.Locationlbl.text = Venue
            let fromdate = Datalist[indexPath.row]["Katha_from_Date"] as? String ?? ""
             cell.fromdate.text = fromdate
            let todate = Datalist[indexPath.row]["Katha_date"] as? String ?? ""
             cell.todate.text = todate
            let Name = Datalist[indexPath.row]["Name"] as? String ?? ""
            let kathid = Datalist[indexPath.row]["Katha_id"] as? String ?? ""
            
             cell.NameLbl.text = Name
            
            if selectedBookingRows.contains(indexPath.row) {
                  cell.checkbutton.setImage(UIImage(named: "check-mark 1"), for: .normal)
              } else {
                  cell.checkbutton.setImage(UIImage(named: ""), for: .normal)
              }
            cell.checkbutton.tag = indexPath.row
            cell.checkbutton.addTarget(self, action: #selector(CheckboxTapped(_:)), for: .touchUpInside)
            cell.Approvebtn.tag = indexPath.row
            cell.Approvebtn.addTarget(self, action: #selector(BookingAcceptonClick(_:)), for: .touchUpInside)
            cell.rejectbtn.tag = indexPath.row
            cell.rejectbtn.addTarget(self, action: #selector(BookingrejectonClick(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            updateApproveAllButtonTitle1()
            return cell
            
        } else if tableView == TourTableview {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewApprovalTourCell", for: indexPath) as? NewApprovalTourCell else {
                return NewApprovalTourCell()
            }
            
            let requestAmount = datalist[indexPath.row]["Amount"] as? String ?? ""
            print(requestAmount)
            cell.ReqAmnt.text = requestAmount
            
            if let requestAmount = datalist[indexPath.row]["Amount"] as? String {
                cell.ReqAmnt.text =  requestAmount + ".00"
            } else {
                cell.ReqAmnt.text = "₹ 0" 
            }
            
            if let requestAmount = datalist[indexPath.row]["Approval_Amount"] as? String {
                cell.AppAmnt.text =  requestAmount + ".00"
            } else {
                cell.AppAmnt.text = "₹ 0"
            }
            
            let empcode = datalist[indexPath.row]["EmpCode"] as? String ?? ""
            cell.EmpCode.text = empcode
            let tour = datalist[indexPath.row]["TourID"] as? String ?? ""
              cell.TourId.text = tour
            let date = datalist[indexPath.row]["Date1"] as?  String ?? ""
            cell.FromDate.text = date
            let date1 = datalist[indexPath.row]["Date2"] as?  String ?? ""
            cell.ToDate.text = date1
           let  Tour = datalist[indexPath.row]["Location"] as? String ?? ""
              cell.Location.text = Tour
           let sno = datalist[indexPath.row]["Sno"] as?  Int ?? 0
            let ApprovedAmount = datalist[indexPath.row]["Approval_Amount"] as? String ?? ""
            
//            if selectedTourRows.contains(indexPath.row) {
//                  cell.Checkbutn.setImage(UIImage(named: "check-mark 1"), for: .normal)
//              } else {
//                  cell.Checkbutn.setImage(UIImage(named: ""), for: .normal)
//              }
            cell.Checkbutn.tag = indexPath.row
            cell.Checkbutn.addTarget(self, action: #selector(Checkboxtapped(_:)), for: .touchUpInside)
        
        //    updateApproveAllButtonTitle()
            return cell
        }
       
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == Leavetableview {
            if selectedRows.contains(indexPath.row) {
                selectedRows.remove(indexPath.row)
            } else {
                selectedRows.insert(indexPath.row)
            }
            
            Leavetableview.reloadRows(at: [indexPath], with: .none)
            
        } else if tableView == BookingTableview {
            if selectedBookingRows.contains(indexPath.row) {
                selectedBookingRows.remove(indexPath.row)
            } else {
                selectedBookingRows.insert(indexPath.row)
            }
            
            BookingTableview.reloadRows(at: [indexPath], with: .none)
            
        } else if tableView == TourTableview {
//            if selectedTourRows.contains(indexPath.row) {
//                selectedTourRows.remove(indexPath.row)
//            } else {
//                selectedTourRows.insert(indexPath.row)
//            }
//            
//            TourTableview.reloadRows(at: [indexPath], with: .none)
        }
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == Leavetableview {
            let item = approveM[indexPath.row]
            let leaveType = item["leave_type"] as? String ?? ""
            if leaveType == "full" || leaveType == "half" || leaveType == "tour" || leaveType == "WFH"{
                return 200
//            } else if leaveType == "tour_request" {
//                return 200
            } else {
                return 100
            }
        } else if tableView == BookingTableview {
            return 150
        } else if tableView == TourTableview {
            return 170
        } else {
            return 100
        }
    }

}
