//
//  BookingApprovalVc.swift
//  SanskarEP
//
//  Created by Surya on 30/03/24.
//

import UIKit

class BookingApprovalVc: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var Filterview: UIView!
    @IBOutlet weak var DateTxt: UITextField!
    @IBOutlet weak var DateTxt1: UITextField!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var OneView: UIView!
    @IBOutlet weak var approvalAllBtn: UIButton!
    @IBOutlet weak var RejectAllBtn: UIButton!
    @IBOutlet weak var view2: NSLayoutConstraint!
    
    
    var selectedRows: Set<Int> = []
    var selectedCheckboxes: Set<Int> = []
    
    var Datalist = [[String:Any]]()
    var KathaBookingId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "BookingApprCell", bundle: nil), forCellReuseIdentifier: "BookingApprCell")
        setup()
        Filterview.isHidden = true
        OneView.isHidden = true
        OneView.layer.cornerRadius = 8
        bookingdetailapi()
    }
    
    func setup(){
        Filterview.layer.cornerRadius = 5.0
        DateTxt.layer.cornerRadius = 5.0
        DateTxt1.layer.cornerRadius = 5.0
        submitbtn.layer.cornerRadius = 5.0
        approvalAllBtn.layer.cornerRadius = 5.0
     //   approvalAllBtn.layer.borderWidth = 1.0
        RejectAllBtn.layer.cornerRadius = 5.0
 //       RejectAllBtn.layer.borderWidth = 1.0
    }

    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    
    @IBAction func filterbtn(_ sender: UIButton) {
        Filterview.isHidden = !Filterview.isHidden
    }
    
    @IBAction func SelectAllBtn(_ sender: UIButton) {
        OneView.isHidden = !OneView.isHidden
           
           if OneView.isHidden {
               // Hide OneView and adjust table view position
               let safeAreaInsetsTop = view.safeAreaInsets.top
               self.view2.constant = safeAreaInsetsTop + 8
           } else {
               // Show OneView and adjust table view position
               self.view2.constant = 60
           }
           
           if selectedRows.count == Datalist.count {
               // Deselect all rows
               selectedRows.removeAll()
               // Change title to "Select All"
               sender.setTitle("Select All", for: .normal)
           } else {
               // Select all rows
               selectedRows = Set(0..<Datalist.count)
               // Change title to "Deselect All"
               sender.setTitle("Deselect All", for: .normal)
           }
           
           tableview.reloadData()
       }
    
       func updateApproveAllButtonTitle() {
           if selectedRows.count == Datalist.count {
               approvalAllBtn.setTitle("Approve All", for: .normal)
               RejectAllBtn.setTitle("Reject All", for: .normal)
           } else {
               approvalAllBtn.setTitle("Approve Selected", for: .normal)
               RejectAllBtn.setTitle("Reject Selected", for: .normal)
           }
       }
    
    func filterApi() {
        var dict = Dictionary<String, Any>()
        dict["start_date"] = DateTxt.text
        dict["end_date"] = DateTxt1.text

        DispatchQueue.main.async {
            Loader.showLoader()
        }

        APIManager.apiCall(postData: dict as NSDictionary, url: KathaFilter) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }

            self.Datalist.removeAll()

            if let data = data,
               let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let status = responseDict["status"] as? Bool, status,
               let dataArray = responseDict["data"] as? [[String: Any]] {
                
                print(dataArray)
                self.Datalist.append(contentsOf: dataArray)
            } else {
                print(response?["error"] as Any)
            }

            DispatchQueue.main.async {
                self.tableview.reloadData()
                self.Filterview.isHidden = true
                self.clearFilterLabels()
            }
        }
    }


    func clearFilterLabels() {
        // Clear text in the datepickerTxt and datepickerText fields
        DateTxt.text = ""
        DateTxt1.text = ""
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
                       self.tableview.reloadData()
                    }
                }
            }  else {
                
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
            self.tableview.reloadData()
        }
    }
    
    func approveBooking(bookingIds: [String], status: String) {
//            var dict = Dictionary<String, Any>()
//            dict["kathaid"] = bookingIds
//            dict["empcode"] = currentUser.EmpCode
//            dict["status"] = "1"
//
//            DispatchQueue.main.async(execute: {Loader.showLoader()})
//            APIManager.apiCall(postData: dict as NSDictionary, url: hodBApprovalApi) { result, response, error, data in
//                DispatchQueue.main.async(execute: {Loader.hideLoader()})
//                if let _ = data, (response?["status"] as? Bool == true), response != nil {
//                    AlertController.alert(message: (response?.validatedValue("message"))!)
//                    DispatchQueue.main.async {
//            //            self.bookingdetailapi()
//                    }
//                } else {
//                    print(response?["error"] as Any)
//                }
//                self.tableview.reloadData()
//            }
        var dict = Dictionary<String, Any>()
           dict["kathaid"] = bookingIds
           dict["empcode"] = currentUser.EmpCode
           dict["status"] = "1"

           DispatchQueue.main.async(execute: {Loader.showLoader()})
           APIManager.apiCall(postData: dict as NSDictionary, url: hodBApprovalApi) { result, response, error, data in
               DispatchQueue.main.async(execute: {Loader.hideLoader()})
               if let _ = data, (response?["status"] as? Bool == true), response != nil {
                   AlertController.alert(message: (response?.validatedValue("message"))!)
                   DispatchQueue.main.async {
                       // Remove processed bookings from Datalist
                       self.Datalist = self.Datalist.filter { !bookingIds.contains($0["katha_booking_id"] as? String ?? "") }
                       self.selectedRows.removeAll()
                       self.tableview.reloadData()
                   }
               } else {
                   print(response?["error"] as Any)
               }
           }
        }
    func rejectBooking(bookingIds: [String], status: String) {
//           var dict = Dictionary<String, Any>()
//           dict["kathaid"] = bookingIds
//           dict["empcode"] = currentUser.EmpCode
//           dict["status"] = "2"
//
//           DispatchQueue.main.async(execute: {Loader.showLoader()})
//           APIManager.apiCall(postData: dict as NSDictionary, url: hodBApprovalApi) { result, response, error, data in
//               DispatchQueue.main.async(execute: {Loader.hideLoader()})
//               if let _ = data, (response?["status"] as? Bool == true), response != nil {
//                   AlertController.alert(message: (response?.validatedValue("message"))!)
//                   DispatchQueue.main.async {
//             //          self.bookingdetailapi()
//                   }
//               } else {
//                   print(response?["error"] as Any)
//               }
//               self.tableview.reloadData()
//           }
        var dict = Dictionary<String, Any>()
          dict["kathaid"] = bookingIds
          dict["empcode"] = currentUser.EmpCode
          dict["status"] = "2"

          DispatchQueue.main.async(execute: {Loader.showLoader()})
          APIManager.apiCall(postData: dict as NSDictionary, url: hodBApprovalApi) { result, response, error, data in
              DispatchQueue.main.async(execute: {Loader.hideLoader()})
              if let _ = data, (response?["status"] as? Bool == true), response != nil {
                  AlertController.alert(message: (response?.validatedValue("message"))!)
                  DispatchQueue.main.async {
                      // Remove processed bookings from Datalist
                      self.Datalist = self.Datalist.filter { !bookingIds.contains($0["katha_booking_id"] as? String ?? "") }
                      self.selectedRows.removeAll()
                      self.tableview.reloadData()
                  }
              } else {
                  print(response?["error"] as Any)
              }
          }
       }
    private func showConfirmationPopup(action: String, bookingIds: [String], indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to \(action) this booking?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes, Confirm", style: .default) { _ in
            if action == "approve" {
                self.approveBooking(bookingIds: bookingIds, status: "1")
            } else if action == "reject" {
                self.rejectBooking(bookingIds: bookingIds, status: "2")
            }
            self.Datalist.remove(at: indexPath.row)
            self.tableview.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "No, Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

   
    
    @IBAction func FilterSubmitBtn(_ sender: UIButton) {
        guard let start_date = DateTxt.text, !start_date.isEmpty,
                 let end_date = DateTxt1.text, !end_date.isEmpty else {
               // Alert if any of the text fields are empty
               showAlert(message: "Please fill in both date fields.")
               return
           }
        filterApi()
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @objc func checkboxTapped(_ sender: UIButton) {
           let rowIndex = sender.tag
           if selectedRows.contains(rowIndex) {
               selectedRows.remove(rowIndex)
           } else {
               selectedRows.insert(rowIndex)
           }
           tableview.reloadData()
       }
    
    @objc func approvOnClick(_ sender: UIButton) {
           let index = sender.tag
           let bookingId = Datalist[index]["Katha_id"] as? String ?? ""
           tableview.reloadData()
           showConfirmationPopup(action: "approve", bookingIds: [bookingId], indexPath: IndexPath(row: index, section: 0))
        Datalist.remove(at: sender.tag)
        tableview.reloadData()
        
       }

       @objc func RejectOnClick(_ sender: UIButton) {
           let index = sender.tag
           let bookingId = Datalist[index]["Katha_id"] as? String ?? ""
           tableview.reloadData()
           showConfirmationPopup(action: "reject", bookingIds: [bookingId], indexPath: IndexPath(row: index, section: 0))
           tableview.reloadData()
       }
    
    @IBAction func datebtn(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.DateTxt.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    @IBAction func datebtn1(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.DateTxt1.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    
    @IBAction func AllApprovBtn(_ sender: UIButton) {
//        var bookingIds = [String]()
//                for dataItem in Datalist {
//                    if let bookingId = dataItem["katha_booking_id"] as? String {
//                        bookingIds.append(bookingId)
//                    }
//                }
//                approveBooking(bookingIds: bookingIds, status: "1")
//                tableview.reloadData()
//        var bookingIds = [String]()
//           for dataItem in Datalist {
//               if let bookingId = dataItem["katha_booking_id"] as? String {
//                   bookingIds.append(bookingId)
//               }
//           }
//           approveBooking(bookingIds: bookingIds, status: "1")
//           // Clear the Datalist and reload the table view
//           Datalist.removeAll()
//           tableview.reloadData()
        var bookingIds = [String]()
          for index in selectedRows {
              if let bookingId = Datalist[index]["Katha_id"] as? String {
                  bookingIds.append(bookingId)
              }
          }
          approveBooking(bookingIds: bookingIds, status: "1")
    }
    
    
    @IBAction func AllRejectBtn(_ sender: UIButton) {
//        var bookingIds = [String]()
//               for dataItem in Datalist {
//                   if let bookingId = dataItem["katha_booking_id"] as? String {
//                       bookingIds.append(bookingId)
//                   }
//               }
//               rejectBooking(bookingIds: bookingIds, status: "2")
//               Datalist.removeAll()
//               tableview.reloadData()
        var bookingIds = [String]()
           for index in selectedRows {
               if let bookingId = Datalist[index]["Katha_id"] as? String {
                   bookingIds.append(bookingId)
               }
           }
           rejectBooking(bookingIds: bookingIds, status: "2")
           }
    }
    


extension BookingApprovalVc: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingApprCell", for: indexPath) as! BookingApprCell
        
        let Name = Datalist[indexPath.row]["Name"] as? String ?? ""
         cell.NameLbl.text = Name
        
        let Amount = Datalist[indexPath.row]["Amount"] as? String ?? ""
         cell.AmountLbl.text = Amount
        
        let Channel = Datalist[indexPath.row]["ChannelName"] as? String ?? ""
         cell.ChannelLbl.text = Channel
        
        let KathaTime = Datalist[indexPath.row]["KathaTiming"] as? String ?? ""
         cell.TimeLbl.text = KathaTime
        
         KathaBookingId = Datalist[indexPath.row]["katha_booking_id"] as? String ?? ""
         cell.VenueLbl.text = KathaBookingId
   
        let Venue = Datalist[indexPath.row]["Venue"] as? String ?? ""
         cell.locationLbl.text = Venue
        
        let fromdate = Datalist[indexPath.row]["Katha_date"] as? String ?? ""
         cell.DateLbl.text = fromdate
        
        let GST = Datalist[indexPath.row]["GST"] as? String ?? ""
         cell.GSTLbl.text = GST
        
        let todate = Datalist[indexPath.row]["Katha_from_Date"] as? String ?? ""
         cell.todateLbl.text = todate
        
//        let data = Datalist[indexPath.row]
//        if let kathaDateDict = data["Katha_date"] as? [String: Any], let dateString = kathaDateDict["date"] as? String {
//            // Formatting the date
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
//            if let date = dateFormatter.date(from: dateString) {
//                dateFormatter.dateFormat = "dd MMMM yyyy"
//                let formattedDate = dateFormatter.string(from: date)
//                cell.DateLbl.text = formattedDate
//            }
//        }
                cell.approvebtn.addTarget(self, action: #selector(approvOnClick(_:)), for: .touchUpInside)
                cell.rejectbtn.addTarget(self, action: #selector(RejectOnClick(_:)), for: .touchUpInside)
                cell.approvebtn.tag = indexPath.row
                cell.rejectbtn.tag = indexPath.row
        
        
        if selectedRows.contains(indexPath.row) {
              cell.checkbtn.setImage(UIImage(named: "check-mark 1"), for: .normal)
          } else {
              cell.checkbtn.setImage(UIImage(named: "checkmark"), for: .normal)
          }
              updateApproveAllButtonTitle()
              cell.checkbtn.tag = indexPath.row
              cell.checkbtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
