//
//  TourAllDetailsVC.swift
//  SanskarEP
//
//  Created by Surya on 19/09/23.
//

import UIKit

class TourAllDetailsVC: UIViewController {
    
    @IBOutlet weak var Header: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var tabview: UIView!
    
    
    var datalist  = [[String:Any]]()
    var DataList  = [[String:Any]]()
    var SaveList  = [[String:Any]]()
    var SubList   = [[String:Any]]()
    var imageData = String()
    var Serial    = [Int]()
    // var tour      = String()
    var TourId = [tour]()
    var editTour  = String()
    var tourd     = ""
    var tourloc   = [String]()
    var type      = ""
    var rejtour   = ""
    var location1 = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.delegate = self
        TableView.dataSource = self
        TableView.register(UINib(nibName: "TourfullDetailsCell", bundle: nil), forCellReuseIdentifier: "TourfullDetailsCell")
        
        
        
        newDetailApi()
        
    }
    func setData(tou: String){
        
        //     Header.text = tou
    }
    
    @IBAction func Backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    
    
    func newDetailApi(){
        var dict = Dictionary<String,Any>()
        dict["Emp_Code"] = currentUser.EmpCode
        dict["type"] =  type
        print( dict["type"])
        APIManager.apiCall(postData: dict as NSDictionary, url: DetailList) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                    
                    self.DataList = data
                    print(self.DataList)
                    
                    for i in 0..<self.DataList.count{
                        let season_thumbnails = self.DataList[i]["Sno"] as? Int ?? 0
                        self.Serial.append(season_thumbnails)
                        
                    }
                    print(self.Serial)
                    //    AlertController.alert(message: (response?.validatedValue("message"))!)
                    //    DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        self.tabview.isHidden = true
                        self.TableView.reloadData()
                    }
                }else{
                    print(response?["error"] as Any)
                    DispatchQueue.main.async {
                        self.Label1.text = response?.validatedValue("message")
                        self.TableView.isHidden = true
                    }
                    
                }
               
            }
        }
    }
    
  
}
  
extension TourAllDetailsVC: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return DataList.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourfullDetailsCell", for: indexPath) as! TourfullDetailsCell
      
        let requestAmount = DataList[indexPath.row]["Amount"] as? String ?? ""
        print(requestAmount)
        
        cell.Amount.text = requestAmount

        let location = DataList[indexPath.row]["TourID"] as? String ?? ""
        
        cell.TourId.text = location
        
        let tour = DataList[indexPath.row]["Location"] as? String ?? ""
        
        cell.Locationlbl.text = tour

        let date = DataList[indexPath.row]["Date1"] as?  String ?? ""
        cell.Date.text = date
      
        
        let date1 = DataList[indexPath.row]["Date2"] as?  String ?? ""
        cell.date2.text = date1
       
        
        let ApprovedAmount = DataList[indexPath.row]["Approval_Amount"] as? String ?? ""
        cell.AAmount.text = ApprovedAmount
      

        var rowdata = DataList[indexPath.row]["Status"] as? String ?? ""
     
        if rowdata == "-1" {
               cell.StatusL.text = "Saved"
               cell.StatusL.textColor = UIColor.blue
//           } else if rowdata == "1" {
//               cell.StatusL.text = "Submit"
//               cell.StatusL.textColor = UIColor.green
//           } else if rowdata == "2" {
//               cell.StatusL.text = "approve"
//               cell.StatusL.textColor = UIColor.green
//           } else if rowdata == "3" {
//               cell.StatusL.text = "Reject"
//               cell.StatusL.textColor = UIColor.green
           }

       return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "TourAppVC") as! TourAppVC
        
        tourd = DataList[indexPath.row]["TourID"] as? String ?? ""
         location1 = DataList[indexPath.row]["Location"] as? String ?? ""
        vc.tourback = tourd
        vc.location = location1
        if #available(iOS 15.0, *) {
        if let sheet = vc.sheetPresentationController {
        var customDetent: UISheetPresentationController.Detent?
            if #available(iOS 16.0, *) {
            customDetent = UISheetPresentationController.Detent.custom { context in
                return 600
                
            }
            sheet.detents = [customDetent!]
            sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 12
                            }
                        }
                        self.present(vc, animated: true)
    
       
  //      self.present(vc,animated: true,completion: nil)
   //     editTour = datalist[indexPath.row]["Tour_id"] as? String ?? ""
  //   setData(tou: editTour)
    
    }
}


