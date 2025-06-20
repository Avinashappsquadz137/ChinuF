//
//  ApprovalVc.swift
//  SanskarEP
//
//  Created by Warln on 18/01/22.
//

import UIKit

class ApprovalVc: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLbl: UILabel!
    
    var titleTxt: String?
    
    //  var Datalist  = [[String:Any]]()
    var approve = [
        Approve(title: "Full Day  Request",   image: "Approved 1"),
        Approve(title: "Half Day  Request",   image: "Approved 1"),
        Approve(title: "Off  Day  Request",   image: "Approved 1"),
        Approve(title: "Tour Day  Request",   image: "Approved 1"),
        Approve(title: "WHF Day Request",   image: "Approved 1")
        // Approve(title: "Tour Bill Request",   image: "Approved 1")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //     approvalpending()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: kCell.appCell, bundle: nil), forCellReuseIdentifier: kCell.appCell)
        headerLbl.text = titleTxt
        if #available(iOS 15.0, *) {
            sheetPresentationController?.prefersGrabberVisible = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            sheetPresentationController?.detents = [.large()]
        } else {
            // Fallback on earlier versions
        }
    //    fetchDataAndUpdateLabels()
//        let defaulta = UserDefaults.standard
//        let savedHalfDayCount = defaulta.integer(forKey: "halfDayCount")
//        let savedFullDayCount = defaulta.integer(forKey: "fullDayCount")
//        let savedWfhlist = defaulta.integer(forKey: "wfhlist")
//        let savedOfflist = defaulta.integer(forKey: "offlist")
        
        fetchDataAndUpdateLabels()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        navigationController?.popViewController(animated: true)
        
    }
    

//    func fetchDataAndUpdateLabels() {
//        var dict = Dictionary<String, Any>()
//        dict["EmpCode"] = currentUser.EmpCode
//        print(dict["EmpCode"])
//        APIManager.apiCall(postData: dict as NSDictionary, url: CountApi) { result, response, error, data in
//            if let JSON = response as? NSDictionary {
//                if JSON.value(forKey: "status") as? Bool == true {
//                    print(JSON)
//                    let data = JSON["data"] as? [String:Any] ?? [:]
//                    DispatchQueue.main.async {
//                        if let halfDayCount = data["halfday_list"] as? Int {
//                            UserDefaults.standard.set(halfDayCount, forKey: "halfDayCount")
//                        }
//                        if let fullDayCount = data["fullday_list"] as? Int {
//                            UserDefaults.standard.set(fullDayCount, forKey: "fullDayCount")
//                        }
//                        if let wfhCount = data["wfh_list"] as? Int {
//                            UserDefaults.standard.set(wfhCount, forKey: "wfhlist")
//                        }
//                        if let offCount = data["off_list"] as? Int {
//                            UserDefaults.standard.set(offCount, forKey: "offlist")
//                        }
//                        // Update other counts in a similar manner
//
//                        // Reload table view data to reflect the changes
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }
//    }
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
                        
             //           let totalCount = halfdayCount + fulldayCount + tourCount + wfhCount + offCount
                        let kathaBookingCount = responseData["Katha_booking"] as? Int ?? 0
                        let tourBillingRequestCount = responseData["tour_billing_request"] as? Int ?? 0

                        // Update labels in table view cells
                        DispatchQueue.main.async {
                            // Iterate through visible cells and update labels
                            for cell in self.tableView.visibleCells {
                                if let indexPath = self.tableView.indexPath(for: cell) {
                                    let index = indexPath.row
                                    if index == 0 { // "FullDay Request"
                                        if let cell = cell as? ApprovalCell {
                                            cell.countLabel.text = "(\(fulldayCount))"
                                        }
                                } else if index == 1 { // "HalfDay Request"
                                        if let cell = cell as? ApprovalCell {
                                            cell.countLabel.text = "(\(halfdayCount))"
                                        }
                                    } else if index == 2 { // "tour Request"
                                        if let cell = cell as? ApprovalCell {
                                            cell.countLabel.text = "(\(offCount))"
                                        }
                                    } else if index == 3 { // "wfh Request"
                                        if let cell = cell as? ApprovalCell {
                                            cell.countLabel.text = "(\(tourCount))"
                                        }
                                    } else if index == 4 { // "off Request"
                                        if let cell = cell as? ApprovalCell {
                                            cell.countLabel.text = "(\(wfhCount))"
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


//MARK: - Extension UITableView Datasource
extension ApprovalVc: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approve.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCell.appCell, for: indexPath) as? ApprovalCell else {
            return UITableViewCell()
        }
        
        let index = approve[indexPath.row]
           cell.titleLbl.text = index.title
           cell.imgView.image = UIImage(named: index.image)
           
           // Update countLabel based on the type of request
//           switch index.title {
//           case "Full Day  Request":
//               cell.countLabel.text = "(\(UserDefaults.standard.integer(forKey: "fullDayCount")))"
//           case "Half Day  Request":
//               cell.countLabel.text = "(\(UserDefaults.standard.integer(forKey: "halfDayCount")))"
//           case "WHF  Day  Request":
//               cell.countLabel.text = "(\(UserDefaults.standard.integer(forKey: "wfhlist")))"
//           case "Off  Day  Request":
//               cell.countLabel.text = "(\(UserDefaults.standard.integer(forKey: "offlist")))"
//           case "Tour Day  Request":
//               cell.countLabel.text = "(\(UserDefaults.standard.integer(forKey: "tourlist")))"
//           default:
//               cell.countLabel.text = ""
//           }
           
        
            cell.selectionStyle = .none
            return cell
        }
    }

//MARK: - Extension UITableView Delegate

extension ApprovalVc: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView =  UIView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kAPPList) as! AppListVc
            vc.titleTxt = approve[indexPath.row].title
            vc.type = "full"
            self.present(vc,animated: true,completion: nil)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kAPPList) as! AppListVc
            vc.titleTxt = approve[indexPath.row].title
            vc.type = "half"
            self.present(vc,animated: true,completion: nil)
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kAPPList) as! AppListVc
            vc.titleTxt = approve[indexPath.row].title
            vc.type = "off"
          //  navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        case 3:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kAPPList) as! AppListVc
            vc.titleTxt = approve[indexPath.row].title
            vc.type = "tour"
         //   navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        case 4:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kAPPList) as! AppListVc
            vc.titleTxt = approve[indexPath.row].title
            vc.type = "WFH"
         //   navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        case 5:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kAPPList) as! AppListVc
            
            vc.titleTxt = approve[indexPath.row].title
            vc.type = "tour_request"
         //   navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        default:
            break
        }
    }
    
}
