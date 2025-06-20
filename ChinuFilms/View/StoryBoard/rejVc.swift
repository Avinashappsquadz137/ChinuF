//
//  rejVc.swift
//  SanskarEP
//
//  Created by Surya on 06/12/23.
//

import UIKit

class rejVc: UIViewController {

    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var tabview: UIView!
    
    var datalist = [[String:Any]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "rejcell", bundle: nil), forCellReuseIdentifier: "rejcell")
        bdaydata()
    }
    

    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    func bdaydata() {
        var dict = Dictionary<String,Any>()
        dict["TourID"] = "TR/2023/IT/8483"
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: rejapi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
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
                    DispatchQueue.main.async {
                        self.tabview.isHidden = true
                    self.tableview.reloadData()
                }
                    
                } else {
                    print(response?["error"] as Any)
                 
                    DispatchQueue.main.async {
                        self.Label1.text = response?.validatedValue("message")
                        self.tableview.isHidden = true
                    }
                }
                
                }
            }
            
        }
    }

extension rejVc:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rejcell", for: indexPath) as! rejcell
        print(datalist)
        
        let bdayData = datalist[indexPath.row]["CreationOn"] as? [String:Any] ?? [:]
        let nameData = datalist[indexPath.row]["TourID"] as? String ?? ""
        let  EmpData = datalist[indexPath.row]["Remarks"] as? String ?? ""
        let  EmpData1 = datalist[indexPath.row]["Status"] as? String ?? ""
        
        let date = bdayData["date"] as? String ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"

        if let dateTime = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: dateTime)
            cell.date.text = formattedDate
        } else {
            cell.date.text = "Invalid Date"
        }
//
        cell.tourid.text = nameData
        cell.remark.text = EmpData
      //  cell.date.text = date
        cell.status.text = EmpData1
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
