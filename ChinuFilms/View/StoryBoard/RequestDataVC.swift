//
//  RequestDataVC.swift
//  SanskarEP
//
//  Created by Surya on 03/10/24.
//

import UIKit

class RequestDataVC: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    var datalist = [[String:Any]]()
    var kathaid: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        SalesRequestAPi()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: "RequestCell", bundle: nil), forCellReuseIdentifier: "RequestCell")
        tableview.register(UINib(nibName: "Request2Cell", bundle: nil), forCellReuseIdentifier: "Request2Cell")
        
    }
    
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    func SalesRequestAPi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"]  = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: RequestListApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if  let responseData = response, responseData["status"] as? Bool == true {
                if let JSON = responseData["data"] as? [[String: Any]] {
                    self.datalist = JSON
                          AlertController.alert(message: (response?.validatedValue("message"))!)
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                }
            } else {
               
//                let roleID = Int(currentUser.booking_role_id)
//                roleID == 1 ? () : AlertController.alert(message: (response?.validatedValue("message") as? String) ?? "An error occurred")
//
//                print(response?["error"] as Any)
            }
        }
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        if let roleID = Int(currentUser.booking_role_id),  roleID == 3 {
            let vc = storyboard!.instantiateViewController(withIdentifier: "BookingKathaVc") as! BookingKathaVc
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    var customDetent: UISheetPresentationController.Detent?
                    if #available(iOS 16.0, *) {
                        customDetent = UISheetPresentationController.Detent.custom { context in
                            return 560
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
        }
    }
    @objc func fordwardcheckboxTapped(_ sender: UIButton) {
        let roleID = Int(currentUser.booking_role_id)
        if  roleID == 2 {
            let indexPath = IndexPath(row: sender.tag, section: sender.superview?.superview?.tag ?? 0)
            let vc = storyboard!.instantiateViewController(withIdentifier: "KathaAssignVc") as! KathaAssignVc
            vc.Datalist = datalist[indexPath.row]
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    var customDetent: UISheetPresentationController.Detent?
                    if #available(iOS 16.0, *) {
                        customDetent = UISheetPresentationController.Detent.custom { context in
                            return 560
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
        } else if   roleID == 5 {
            let indexPath = IndexPath(row: sender.tag, section: sender.superview?.superview?.tag ?? 0)
            let vc = storyboard!.instantiateViewController(withIdentifier: "HODAssignVC") as! HODAssignVC
            vc.Datalist = datalist[indexPath.row]
         //   vc.kathaId = kathaid
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    var customDetent: UISheetPresentationController.Detent?
                    if #available(iOS 16.0, *) {
                        customDetent = UISheetPresentationController.Detent.custom { context in
                            return 560
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
        }
    }
}
extension RequestDataVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let roleID = Int(currentUser.booking_role_id) else { return UITableViewCell() }
        if roleID == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as? RequestCell {
                cell.callerName.text = datalist[indexPath.row]["caller_name"] as? String ?? ""
                cell.CallerContact.text = datalist[indexPath.row]["caller_mobile"] as? String ?? ""
                cell.Venue.text = datalist[indexPath.row]["location"] as? String ?? ""
                cell.remarks.text = datalist[indexPath.row]["remarks"] as? String ?? ""
                cell.Name.text = datalist[indexPath.row]["name"] as? String ?? ""
                if  let roleID = Int(currentUser.booking_role_id), roleID == 3 {
                    cell.newbookingbtn.isHidden = false
                    cell.callbtn.isHidden = false
                } else {
                    cell.newbookingbtn.isHidden = true
                    cell.callbtn.isHidden = true
                }
                cell.newbookingbtn.tag = indexPath.row
                cell.newbookingbtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
                return cell
            }
        } else if roleID == 2 || roleID == 5 || roleID == 6 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "Request2Cell", for: indexPath) as? Request2Cell {
                let index = datalist[indexPath.row]
                cell.name.text = datalist[indexPath.row]["Name"] as? String ?? ""
                cell.chhanel.text = datalist[indexPath.row]["ChannelName"] as? String ?? ""
                cell.venue.text = datalist[indexPath.row]["Venue"] as? String ?? ""
                cell.Date.text = " \(index["Katha_from_Date"] as? String ?? "") to \(index["Katha_date"] as? String ?? "")"
                cell.time.text = datalist[indexPath.row]["SlotTiming"] as? String ?? ""
                kathaid = datalist[indexPath.row]["Katha_id"] as? Int ?? 0
                cell.forwardbtn.tag = indexPath.row
                cell.forwardbtn.addTarget(self, action: #selector(fordwardcheckboxTapped(_:)), for: .touchUpInside)
                if roleID == 5 || roleID == 6 {
                    cell.typesLbl.isHidden = false
                    cell.type.isHidden = false
                } else {
                    cell.typesLbl.isHidden = true
                    cell.type.isHidden = true
                }
                cell.statsuLbl.text = datalist[indexPath.row]["Status"] as? String ?? ""
                cell.typesLbl.text = datalist[indexPath.row]["Promo_Name"] as? String ?? ""
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let roleID = Int(currentUser.booking_role_id)
        if  roleID == 2 || roleID == 3 {
            return 190
        } else if  roleID == 5 ||  roleID == 6 {
            return 230
        }
        return 0
    }
}
