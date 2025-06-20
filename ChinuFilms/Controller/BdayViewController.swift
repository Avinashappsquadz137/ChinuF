//
//  BdayViewController.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 28/04/23.
//

import UIKit
import SDWebImage

class BdayViewController: UIViewController {
    
    @IBOutlet var Table: UITableView!
    @IBOutlet weak var tabview: UIView!
    @IBOutlet weak var tabLabel: UILabel!
    
    						
    var datalist = [[String:Any]]()
    var imageData = String()
    var EmpData = String()
    
    var name = String()
   
     var imageurl = "https://ep.sanskargroup.in/uploads/"
   // "https://employee.sanskargroup.in/EmpImage/"
    
    override func viewDidLoad() {
        
        Table.register(UINib(nibName: "bdayviewcell", bundle: nil), forCellReuseIdentifier: "bdayviewcell")
        
        super.viewDidLoad()
        Table.delegate = self
        Table.dataSource = self
        bdaydata()
    }
    
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    
    
    func bdaydata() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kbdayApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            //            if let json = data, (response?["status"] as? Bool == true), response != nil {
            ////                let json = response?["data"] as? [String:Any] ?? [:]
            //                print(json)
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                    
                    self.datalist = data
                    print(self.datalist)
//                    for i in 0..<self.datalist.count{
//                        let na = (self.datalist[i]["Name"] as? String ?? "" )
//                        print(na)
//                        self.name.append(na)
//                        print(self.name)
//
//                    }
                    self.Table.reloadData()
                }
            }
            
        }
    }
    
}

extension BdayViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Table.dequeueReusableCell(withIdentifier: "bdayviewcell", for: indexPath) as! bdayviewcell
        print(datalist)
        
        let bdayData = datalist[indexPath.row]["BDay"] as? String ?? ""
        let nameData = datalist[indexPath.row]["Name"] as? String ?? ""
      //  imageData = datalist[indexPath.row]["PImg"] as? String ?? ""
        EmpData = datalist[indexPath.row]["EmpCode"] as? String ?? ""
        if let imageUrl = datalist[indexPath.row]["PImg"] as? String {
            // Remove leading and trailing whitespaces, including extra spaces after the file extension
            imageData = imageUrl.trimmingCharacters(in: .whitespaces)
        }
     //   let date = bdayData["date"] as? String ?? ""
 //       let dateString = bdayData["date"] as? String ?? ""
        
//        let dateFormatter = DateFormatter()
//
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
//            if let date = dateFormatter.date(from: dateString) {
//
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                let formattedDate = dateFormatter.string(from: date)
//                print(formattedDate)
                cell.MyLbl2.text = bdayData
//            } else {
//                print("Invalid date format")
//                cell.MyLbl2.text = "Invalid date"
//            }
        
        print(bdayData)
        print(nameData)
        print(imageData)
        print(EmpData)
        cell.MyLbl.text = nameData
        cell.mylbl3.isHidden = true
        cell.terminatedbtn.isHidden = true
        
        if imageData.isEmpty {
               cell.MyImage.image = UIImage(named: "download")
           } else {
               let img = imageData.replacingOccurrences(of: " ", with: "%20")
               print(img)
               cell.MyImage.sd_setImage(with: URL(string:  img))
               
           }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BirthPViewController") as! BirthPViewController
        if #available(iOS 15.0, *) {
        if let sheet = vc.sheetPresentationController {
        var customDetent: UISheetPresentationController.Detent?
            if #available(iOS 16.0, *) {
            customDetent = UISheetPresentationController.Detent.custom { context in
                return 590
        
            }
            sheet.detents = [customDetent!]
            sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 12
                            }
                        }
        vc.datal = datalist
     //   imageData = datalist[indexPath.row]["PImg"] as? String ?? ""
        if let imageUrl = datalist[indexPath.row]["PImg"] as? String {
            imageData = imageUrl.trimmingCharacters(in: .whitespaces)
        }
        EmpData = datalist[indexPath.row]["EmpCode"] as? String ?? ""
        vc.imaged = imageData
        print(vc.imaged)
        vc.empCode = EmpData
        print(vc.empCode)
        present(vc, animated: true)
         
        }
    
}
