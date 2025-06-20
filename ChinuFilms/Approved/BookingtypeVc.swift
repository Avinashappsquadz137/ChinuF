//
//  BookingtypeVc.swift
//  SanskarEP
//
//  Created by Surya on 14/02/25.
//

import UIKit

class BookingtypeVc: UIViewController {
    
    @IBOutlet weak var selected: UISegmentedControl!
    @IBOutlet weak var selectbtn: UIButton!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var oneview: UIView!
    @IBOutlet weak var tabletop: NSLayoutConstraint!
    @IBOutlet weak var approveall: UIButton!
    @IBOutlet weak var rejectall: UIButton!
    @IBOutlet weak var filterbtn: UIButton!
    @IBOutlet weak var searchview: UIView!
    @IBOutlet weak var filtertable: UITableView!
    @IBOutlet weak var notlbl: UILabel!
    @IBOutlet weak var remarksview: UITextView!
    @IBOutlet weak var tableheight: NSLayoutConstraint!
    @IBOutlet weak var searchValue: NSLayoutConstraint!
    
    
    
    var type: String?
    var filterList = ["7 Days","15 Days","30 Days","3 months","6 months"]
    var Datalist = [[String:Any]]()
    var filteredDatalist =  [[String:Any]]()
    var selectedBookingRows: Set<Int> = []
    var selectedRows: Set<Int> = []
    var isSearching = false
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        selectbtn.isHidden = false
        filterbtn.isHidden = true
        filtertable.isHidden = true
    
        oneview.isHidden = false
        bookingdetailapi()
        
        tabletop.constant = 8
        searchview.isHidden =  false
        
        tableheight.constant = 8
        
        selected.selectedSegmentIndex = 0
        selectedbtn(selected)
        
        approveall.layer.cornerRadius = 8
        rejectall.layer.cornerRadius = 8
        remarksview.delegate = self
        remarksview.layer.cornerRadius = 10
        remarksview.layer.borderWidth = 1.0
        remarksview.clipsToBounds = true
        remarksview.text = "Remark ..."
        remarksview.textColor = UIColor.lightGray
        rejectall.isEnabled = false
        search.delegate =  self
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "NewApprovalBookingCell", bundle: nil), forCellReuseIdentifier: "NewApprovalBookingCell")
        filtertable.register(UINib(nibName: "AssignListCell", bundle: nil), forCellReuseIdentifier: "AssignListCell")
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
     dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectedbtn(_ sender: UISegmentedControl) {
        if selected.selectedSegmentIndex == 0 {
            selectbtn.isHidden = false
            filterbtn.isHidden = true
            searchview.isHidden = false
            tabletop.constant = 5
            tableheight.constant = 290
            oneview.isHidden = false
            
            if Datalist.isEmpty {
                oneview.isHidden = true
                selectbtn.isHidden = true
                searchview.isHidden = true
            }
            tableview.reloadData()
            searchValue.constant = 8
        } else if selected.selectedSegmentIndex == 1 {
           
            selectbtn.isHidden = true
            filterbtn.isHidden = true
            searchview.isHidden = false
            oneview.isHidden = true
            tabletop.constant = 5
            tableheight.constant = 400
            
            searchValue.constant = -40
            type = "1"
         
            tableview.reloadData()
            
        } else if selected.selectedSegmentIndex == 2 {
            selectbtn.isHidden = true
            filterbtn.isHidden = false
            searchview.isHidden = true
            tabletop.constant = -50
            tableheight.constant = 460
            oneview.isHidden = true
            type = "2"
        
            tableview.reloadData()
          
        }
        updateNoNotificationLabel()
    }
    
    
    func updateNoNotificationLabel() {
        if selected.selectedSegmentIndex == 0 {
            notlbl.isHidden = !Datalist.isEmpty
            notlbl.text = Datalist.isEmpty ? "No Data Available" : ""
        } else {
         //   notlbl.isHidden = !LeaveDetails.isEmpty
       //     notlbl.text = LeaveDetails.isEmpty ? "No Data Available" : ""
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
                    self.tableview.reloadData()
                }
            } else {
                print(response?["error"] as Any)
            }
        }
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
                    self.filteredDatalist = data
                

                    DispatchQueue.main.async {
                        self.updateNoNotificationLabel()
                        self.tableview.reloadData()
                        self.oneview.isHidden = false
                        self.selectbtn.isHidden = false
                        self.searchview.isHidden = false
                        
                        if self.Datalist.isEmpty {
                            self.oneview.isHidden = true
                            self.selectbtn.isHidden = true
                            self.searchview.isHidden = true
                        }
                        
                    }
                }
            }  else {
                
              //  AlertController.alert(message: (response?.validatedValue("message"))!)
            }
            self.tableview.reloadData()
        }
    }
    
   
    @IBAction func approveallbtn(_ sender: UIButton) {
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
        tableview.reloadData()
    }
    
    @IBAction func rejectalllbtn(_ sender: UIButton) {
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
        tableview.reloadData()
    }
    
    @IBAction func allselectbtn(_ sender: UIButton) {
        oneview.isHidden = false
        if selectedRows.count == Datalist.count {
               selectedRows.removeAll()
            sender.setImage(UIImage(named: "Uncheck"), for: .normal)
            
           } else {
               selectedRows = Set(0..<Datalist.count)
               sender.setImage(UIImage(named: "check"), for: .normal)
           }
           tableview.reloadData()
    }
    
    @IBAction func filteronclick(_ sender: UIButton) {
       self.filtertable.isHidden = !self.filtertable.isHidden

    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
        if selectedRows.contains(rowIndex) {
            selectedRows.remove(rowIndex)
        } else {
            selectedRows.insert(rowIndex)
        }
//        if selectedRows.count == Datalist.count {
//            selectbtn.setTitle("Deselect", for: .normal)
//        } else {
//            selectbtn.setTitle("Select", for: .normal)
//        }
        tableview.reloadData()
    }
    
}

extension BookingtypeVc: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableview {
            switch selected.selectedSegmentIndex {
            case 1, 2:
                return 10
            case 0:
                return isSearching ? filteredDatalist.count : Datalist.count
            
              
            default:
                return 0
            }
        } else if tableView == filtertable {
            return filterList.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableview {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewApprovalBookingCell", for: indexPath) as? NewApprovalBookingCell else {
                return UITableViewCell()
            }
            switch selected.selectedSegmentIndex {
            case 1, 2:
               
                cell.checkbutton.isHidden = true

            case 0:
//                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewApprovalBookingCell", for: indexPath) as? NewApprovalBookingCell else {
//                    return NewApprovalBookingCell()
//                }
                let item = isSearching ? filteredDatalist[indexPath.row] : Datalist[indexPath.row]
                
                let Amount = item["Amount"] as? String ?? ""
                 cell.Amountlbl.text = Amount
                let Channel = item["ChannelName"] as? String ?? ""
                
                 cell.ChannelLbl.text = "(" + Channel + ")"
                let KathaTime = item["KathaTiming"] as? String ?? ""
                 cell.TimeLbl.text = KathaTime
                let Venue = item["Venue"] as? String ?? ""
                 cell.Locationlbl.text = Venue
                let fromdate = item["Katha_from_Date"] as? String ?? ""
                 cell.fromdate.text = fromdate
                let todate = item["Katha_date"] as? String ?? ""
                 cell.todate.text = todate
                let Name = item["Name"] as? String ?? ""
                let kathid = item["Katha_id"] as? String ?? ""
                
                 cell.NameLbl.text = Name
                
                if selectedBookingRows.contains(indexPath.row) {
                      cell.checkbutton.setImage(UIImage(named: "check-mark 1"), for: .normal)
                  } else {
                      cell.checkbutton.setImage(UIImage(named: ""), for: .normal)
                  }
                
                if selectedRows.contains(indexPath.row) {
                    cell.checkbutton.setImage(UIImage(named: "check"), for: .normal)
                } else {
                    cell.checkbutton.setImage(UIImage(named: "Uncheck"), for: .normal)
                }
                
                cell.checkbutton.tag = indexPath.row
                cell.checkbutton.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
                cell.selectionStyle = .none
                cell.checkbutton.isHidden = false
                return cell
               
               

            default:
                break
            }
            
            return cell
        } else if tableView == filtertable {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssignListCell", for: indexPath) as? AssignListCell else {
              
                return UITableViewCell()
               
            }
            cell.locationview.isHidden = true
            cell.AssignLbl.text = filterList[indexPath.row]
          
            return cell
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableview {
            if selected.selectedSegmentIndex == 0 {
                return 150
            } else {
                return 145
            }
        } else if tableView == filtertable {
            return 60
        }
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == filtertable {
            
        } else {
            
        }
    }
    
}
extension BookingtypeVc: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
      
        let text = remarksview.text.trimmingCharacters(in: .whitespacesAndNewlines)
        rejectall.isEnabled = !text.isEmpty && text != "Remark ..."
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if remarksview.textColor == UIColor.lightGray {
            remarksview.text = ""
            remarksview.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if remarksview.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            remarksview.text = "Remark ..."
            remarksview.textColor = UIColor.lightGray
            rejectall.isEnabled = false
        }
    }
}
extension BookingtypeVc: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
         //   filteredLeaveDetails = LeaveDetails
            filteredDatalist = Datalist
        } else {
            isSearching = true
//            filteredLeaveDetails = Datalist.filter { data in
//                return (data.name?.lowercased() ?? "").contains(searchText.lowercased()) ||
//                       (data.lReason?.lowercased() ?? "").contains(searchText.lowercased())
//            }
            
            filteredDatalist = Datalist.filter { data in
                let Name = (data["Name"] as? String ?? "").lowercased()
                let Venue = (data["Venue"] as? String ?? "").lowercased()
                return Name.contains(searchText.lowercased()) || Venue.contains(searchText.lowercased())
            }
        }
        updateNoNotificationLabel()
        tableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
  //      filteredLeaveDetails = LeaveDetails
        filteredDatalist = Datalist
        tableview.reloadData()
        searchBar.resignFirstResponder()
    }
}
