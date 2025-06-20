//
//  ApprovalContVc.swift
//  SanskarEP
//
//  Created by Surya on 10/10/23.
//

import UIKit

class ApprovalContVc: UIViewController {

    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    var titleTxt: String?
    var approve = [
        Approve(title: "Leaves Request", image: "Approved 1"),
        Approve(title: "Tour Bill's", image: "Approved 1"),
        Approve(title: "Booking Request", image: "Approved 1")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "ApprCell", bundle: nil), forCellReuseIdentifier: "ApprCell")
        
      
        fetchDataAndUpdateLabels()
       
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchDataAndUpdateLabels()
        }
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        self.fetchDataAndUpdateLabels()
    }
    
    func fetchDataAndUpdateLabels() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        print(dict["EmpCode"])
        APIManager.apiCall(postData: dict as NSDictionary, url: CountApi) { result, response, error, data in
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    if let responseData = JSON["data"] as? [String: Any] {
                        // Extract required data from the response
                        let halfdayCount = responseData["halfday_list"] as? Int ?? 0
                        let fulldayCount = responseData["fullday_list"] as? Int ?? 0
                        let tourCount = responseData["tour_list"] as? Int ?? 0
                        let wfhCount = responseData["wfh_list"] as? Int ?? 0
                        let offCount = responseData["off_list"] as? Int ?? 0

                        // Calculate total count
                        
                        let totalCount = halfdayCount + fulldayCount + tourCount + wfhCount + offCount
                        let kathaBookingCount = responseData["Katha_booking"] as? Int ?? 0
                        let tourBillingRequestCount = responseData["tour_billing_request"] as? Int ?? 0

                        // Update labels in table view cells
                        DispatchQueue.main.async {
                            // Iterate through visible cells and update labels
                            for cell in self.tableview.visibleCells {
                                if let indexPath = self.tableview.indexPath(for: cell) {
                                    let index = indexPath.row
                                    if index == 0 { // "Leaves Request"
                                        if let cell = cell as? ApprCell {
                                            cell.countLabel.text = "(\(totalCount))"
                                        }
                                } else if index == 1 { // "Tour Request"
                                        if let cell = cell as? ApprCell {
                                            cell.countLabel.text = "(\(tourBillingRequestCount))"
                                        }
                                    } else if index == 2 { // "Booking Request"
                                        if let cell = cell as? ApprCell {
                                            cell.countLabel.text = "(\(kathaBookingCount))"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension ApprovalContVc: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        approve.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApprCell", for: indexPath) as! ApprCell
        let index = approve[indexPath.row]

//        if index.title == "Leaves Request" {
//          //     let totalCount = UserDefaults.standard.integer(forKey: "totalCount")
//         //      cell.countLabel.text =   "(" + "\(String(totalCount))" + ")"
//               cell.Label.text = index.title
//               cell.imageA.image = UIImage(named: index.image)
//           } else if index.title == "Tour Request" {
//         //      let tourrequest = UserDefaults.standard.integer(forKey: "tour_billing_request")
//        //       cell.countLabel.text =   "(" + "\(String(tourrequest))" + ")"
//               cell.imageA.image = UIImage(named: index.image)
//               cell.Label.text = index.title
//           } else if index.title == "Booking Request" {
//         //      let BookKatha = UserDefaults.standard.integer(forKey: "Katha_booking")
//         //      cell.countLabel.text =   "(" + "\(String(BookKatha))" + ")"
//               cell.imageA.image = UIImage(named: index.image)
//               cell.Label.text = index.title
//           }
//        return cell

                cell.Label.text = index.title
                cell.imageA.image = UIImage(named: index.image)
                
                return cell
            }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "ApprovalVc") as! ApprovalVc
            vc.titleTxt = approve[indexPath.row].title
            self.present(vc,animated: true,completion: nil)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "HODAllDetailVC") as! HODAllDetailVC
            self.present(vc,animated: true,completion: nil)
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: "BookingApprovalVc") as! BookingApprovalVc
            self.present(vc,animated: true,completion: nil)
        default:
            break
        }
    }
}
