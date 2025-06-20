//
//  HODAllDetailVC.swift
//  SanskarEP
//
//  Created by Surya on 21/10/23.
//

import UIKit

class HODAllDetailVC: UIViewController {

    @IBOutlet weak var HeaderL: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tabview: UIView!
    @IBOutlet weak var messageL: UILabel!
    
    var Datalist  = [[String:Any]]()
    var Serial    = [Int]()
    var reqamt    = ""
    var empna     = ""
    var emco      = ""
    var emtour    = ""
    var emdat     = ""
    var emdate    = ""
    var empamt    = ""
    var emst      = ""
    var empsno    = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "HodDetailCell", bundle: nil), forCellReuseIdentifier: "HodDetailCell")
        
        HODdetail()
    }
    
    @IBAction func backlbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    func HODdetail(){
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        APIManager.apiCall(postData: dict as NSDictionary, url: HODdetails) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                    
                    self.Datalist = data
                    print(self.Datalist)
                    for i in 0..<self.Datalist.count{
                        let season_thumbnails = self.Datalist[i]["Sno"] as? Int ?? 0
                        self.Serial.append(season_thumbnails)
                    }
                    print(self.Serial)
                    
                    DispatchQueue.main.async {
                        
                        
                        self.tabview.isHidden = true
                        self.tableview.reloadData()
                    }
                }else {
                        print(response?["error"] as Any)
                        // Display the error message on a label
                        DispatchQueue.main.async {
                            self.messageL.text = response?.validatedValue("message")
                            self.tableview.isHidden = true
                        }
                    }
                }
            }
        }
}
extension HODAllDetailVC: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Datalist.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HodDetailCell", for: indexPath) as! HodDetailCell
        
        let requestAmount = Datalist[indexPath.row]["Amount"] as? String ?? ""
        print(requestAmount)
        cell.ReqAmnt.text = requestAmount
        
        if let requestAmount = Datalist[indexPath.row]["Amount"] as? String {
            cell.ReqAmnt.text =  requestAmount + ".00"
        } else {
            cell.ReqAmnt.text = "₹ 0" // or handle the case where the amount is not found
        }
        
        let empcode = Datalist[indexPath.row]["EmpCode"] as? String ?? ""
        print(empcode)
        cell.EmpCode.text = empcode
        
        let empname = Datalist[indexPath.row]["Name"] as? String ?? ""
        print(empname)
        cell.EmpName.text = empname
        
        let tour = Datalist[indexPath.row]["TourID"] as? String ?? ""
        print(tour)
          cell.tourid.text = tour

        let date = Datalist[indexPath.row]["Date1"] as?  String ?? ""
        cell.Date.text = date
        print(date)
        
        let date1 = Datalist[indexPath.row]["Date2"] as?  String ?? ""
        cell.date2.text = date1
        print(date1)
        
        let Sno = Datalist[indexPath.row]["Sno"] as?  Int ?? 0
        print(Sno)
        
       let  Tour = Datalist[indexPath.row]["Location"] as? String ?? ""
        print(Tour)
          cell.location.text = Tour

        
//        let ApprovedAmount = Datalist[indexPath.row]["Approval_Amount"] as? String ?? ""
//        cell.AppAmnt.text = ApprovedAmount
//        print(ApprovedAmount)
        
        if let requestAmount = Datalist[indexPath.row]["Approval_Amount"] as? String {
            cell.AppAmnt.text =  requestAmount + ".00"
        } else {
            cell.AppAmnt.text = "₹ 0" // or handle the case where the amount is not found
        }
        
        var rowdata = Datalist[indexPath.row]["Status"] as? String ?? ""
        if rowdata == "1" {
               cell.Status.text = "Pending"
               cell.Status.textColor = UIColor.red
           } else {
               cell.Status.text = "Approved"
               cell.Status.textColor = UIColor.green
           }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
           let sno = Datalist[indexPath.row]["Sno"] as?  Int ?? 0
           let requestAmount = Datalist[indexPath.row]["Amount"] as? String ?? ""
           let empcode = Datalist[indexPath.row]["EmpCode"] as? String ?? ""
           let empname = Datalist[indexPath.row]["Name"] as? String ?? ""
           let tour = Datalist[indexPath.row]["TourID"] as? String ?? ""
           let Location = Datalist[indexPath.row]["Location"] as? String ?? ""
           let date = Datalist[indexPath.row]["Date1"] as?  String ?? ""
           let date1 = Datalist[indexPath.row]["Date2"] as?  String ?? ""
           let ApprovedAmount = Datalist[indexPath.row]["Approval_Amount"] as? String ?? ""
           let status = Datalist[indexPath.row]["Status"] as? String ?? ""
        
           let vc = storyboard?.instantiateViewController(withIdentifier: "HODAllDetail2VC") as! HODAllDetail2VC
        
              vc.heamt = requestAmount
              vc.hemn  = empname
              vc.hemco = empcode
              vc.htour = tour
              vc.location = Location
              vc.hdat1 = date
              vc.hdat2 = date1
              vc.hsno  = String(sno)
              vc.haamt = ApprovedAmount
              vc.hst   = status
//                 if emst == "0" {
//                 print("Pending")
//                 vc.hst = "Pending"
//                } else if emst == "1" {
//                  print("Approved")
//                 vc.hst = "Approved"
//                 }
        
              self.present(vc,animated: true,completion: nil)
  
    
    }
}
