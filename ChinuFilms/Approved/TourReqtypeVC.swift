//
//  TourReqtypeVC.swift
//  SanskarEP
//
//  Created by Surya on 14/02/25.
//

import UIKit

class TourReqtypeVC: UIViewController {
    
    
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
    
    
  
    var filterList = ["7 Days","15 Days","30 Days","3 months","6 months"]
    var BookDetails: [BookingDetails] = []
    var filteredLeaveDetails: [BookingDetails] = []
    var isSearching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectbtn.isHidden = true
        filterbtn.isHidden = true
        tabletop.constant = -45
        selected.selectedSegmentIndex = 0
        selectedbtn(selected)
        
        approveall.layer.cornerRadius = 8
        rejectall.layer.cornerRadius = 8
        
        tableview.register(UINib(nibName: "NewApprovalBookingCell", bundle: nil), forCellReuseIdentifier: "NewApprovalBookingCell")
        BookingAPi()
        
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectedbtn(_ sender: UISegmentedControl) {
        if selected.selectedSegmentIndex == 0 {
            selectbtn.isHidden = true
            filterbtn.isHidden = true
            searchview.isHidden = false
            oneview.isHidden = true
            tabletop.constant = -50
          
            tableview.reloadData()
            
        } else if selected.selectedSegmentIndex == 1 {
            selectbtn.isHidden = false
            filterbtn.isHidden = true
            searchview.isHidden = false
            tabletop.constant = -50
            tableview.reloadData()
            BookingAPi()
        } else if selected.selectedSegmentIndex == 2 {
            selectbtn.isHidden = true
            filterbtn.isHidden = false
            searchview.isHidden = true
            tabletop.constant = -100
          
            
            tableview.reloadData()
            
        }
        // updateNoNotificationLabel()
    }
    
    @IBAction func filteronclick(_ sender: UIButton) {
        self.filtertable.isHidden = !self.filtertable.isHidden
        
    }
    
    func BookingAPi() {
        var dict = [String: Any]()
        DispatchQueue.main.async {Loader.showLoader()}
        APIManager.apiCall(postData: dict as NSDictionary, url: katha_booking_detailApi) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }
            guard let responseData = data else {
                print("Error: No data received")
                return
            }
            do {
                let decoder = JSONDecoder()
                let monthWiseDetail = try decoder.decode(BookingDetailsModel.self, from: responseData)
                
                if monthWiseDetail.status == true, let details = monthWiseDetail.data {
                    DispatchQueue.main.async {
                        self.BookDetails = details
                        
                        self.tableview.reloadData()
                      
                    }
                } else {
                    print("Error: \(monthWiseDetail.message ?? "Unknown error")")
                }
            } catch {
                print("Decoding Error:", error.localizedDescription)
            }
        }
    }
    
}
extension TourReqtypeVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableview {
            switch selected.selectedSegmentIndex {
            case 0, 2:
                return 10
            case 1:
                return isSearching ? filteredLeaveDetails.count : BookDetails.count
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
            return NewApprovalBookingCell()
        }
            switch selected.selectedSegmentIndex {
            case 0, 2: break
              
            case 1:
                let item = isSearching ? filteredLeaveDetails[indexPath.row] : BookDetails[indexPath.row]
                
                cell.ChannelLbl.text = item.ChannelName
                cell.Amountlbl.text = item.Amount
                cell.Locationlbl.text = item.Venue
                cell.fromdate.text = item.KathafromDate
                cell.todate.text = item.Kathadate
                cell.NameLbl.text = item.Name
                cell.TimeLbl.text = item.KathaTiming
                
                


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
            if selected.selectedSegmentIndex == 1 {
                return 200
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
