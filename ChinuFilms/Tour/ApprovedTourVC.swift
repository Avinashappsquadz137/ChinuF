//
//  ApprovedTourVC.swift
//  SanskarEP
//
//  Created by Surya on 20/11/23.
//

import UIKit

class ApprovedTourVC: UIViewController {
    
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tabview: UIView!
    @IBOutlet weak var Label1: UILabel!
    
    
    var datalist  = [[String:Any]]()
    var DataList  = [[String:Any]]()
    var alldata   = [[String:Any]]()
    var imageData = String()
    var Serial    = [Int]()
    var tour      = String()
    var TourId    = [String]()
    var editTour  = String()
    var tourd     =  ""
    var reqAmnt   =  ""
    var statud    =  ""
    var AppAmnt   =  ""
    var date1     =  ""
    var date2     =  ""
    var type      = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "TourfullDetailsCell", bundle: nil), forCellReuseIdentifier: "TourfullDetailsCell")
        newDetailApi()
        
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    

    func newDetailApi(){
        var dict = Dictionary<String,Any>()
        dict["Emp_Code"] = currentUser.EmpCode
        print(dict["Emp_Code"])
        dict["type"] = type
        print(dict["type"])
        APIManager.apiCall(postData: dict as NSDictionary, url: DetailList) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary {
                        if JSON.value(forKey: "status") as? Bool == true {
                            print(JSON)
                            
                            let data = (JSON["data"] as? [[String: Any]] ?? [[:]])
                            print(data)
                            
                            self.DataList = data
                            print(self.DataList)
                            
                            for i in 0..<self.DataList.count {
                                let season_thumbnails = self.DataList[i]["Sno"] as? Int ?? 0
                                self.Serial.append(season_thumbnails)
                            }
                            print(self.Serial)
                            
                            DispatchQueue.main.async {
                                self.tabview.isHidden = true
                                self.tableview.reloadData()
                            }
                            
                        } else {
                            print(response?["error"] as Any)
                            // Display the error message on a label
                            DispatchQueue.main.async {
                                self.Label1.text = response?.validatedValue("message")
                                self.tableview.isHidden = true
                            }
                        }
                    }
                }
        }
    }


extension ApprovedTourVC: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourfullDetailsCell", for: indexPath) as! TourfullDetailsCell
        
        let requestAmount = DataList[indexPath.row]["Amount"] as? String ?? ""
        cell.Amount.text = requestAmount
        
        let tour = DataList[indexPath.row]["TourID"] as? String ?? ""
        cell.TourId.text = tour
        
        let location = DataList[indexPath.row]["Location"] as? String ?? ""
        cell.Locationlbl.text = location
        
        let date = DataList[indexPath.row]["Date1"] as?  String ?? ""
        cell.Date.text = date
        
        
        let date1 = DataList[indexPath.row]["Date2"] as?  String ?? ""
        cell.date2.text = date1
        
        
        let ApprovedAmount = DataList[indexPath.row]["Approval_Amount"] as? String ?? ""
        cell.AAmount.text = ApprovedAmount
        print(ApprovedAmount)
        
        
        let status = DataList[indexPath.row]["Status"] as? String ?? ""
        print(status)
        if status == "1" {
            cell.StatusL.text = "Approved"
            cell.StatusL.textColor = UIColor.blue
        } else if status == "2" {
            cell.StatusL.text = "Reject"
            cell.StatusL.textColor = UIColor.red
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let vc = storyboard?.instantiateViewController(withIdentifier: "ImageController") as! ImageController
                vc.sourceViewController = "ApprovedTourVC"
                navigationController?.pushViewController(vc, animated: true)
        
        tourd = DataList[indexPath.row]["TourID"] as? String ?? ""
       
        vc.tourbac = tourd
        let location = DataList[indexPath.row]["Location"] as? String ?? ""
        vc.location = location
        
        reqAmnt = DataList[indexPath.row]["Amount"] as? String ?? ""
        vc.requAmnt = reqAmnt
        statud = DataList[indexPath.row]["Status"] as? String ?? ""
        vc.statusDe = statud
      //  if statud == "1" {
          //  print("Submit")
        //    vc.statusDe = "Submit"
     //   }
      
       
        AppAmnt = DataList[indexPath.row]["Approval_Amount"] as? String ?? ""
        vc.AAMnt = AppAmnt
        date1 = DataList[indexPath.row]["Date1"] as? String ?? ""
        vc.dat = date1
        date2 = DataList[indexPath.row]["Date2"] as? String ?? ""
        vc.dat2 = date2
        vc.type1 = type
        
        alldata = (self.DataList[indexPath.row]["alldata"] as? [[String: Any]] ?? [[:]])
            print(alldata)
        vc.alldata1 = alldata
        
        self.present(vc,animated: true,completion: nil)
    }
}
