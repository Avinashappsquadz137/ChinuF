//
//  PieChartVC.swift
//  SanskarEP
//
//  Created by Surya on 28/09/24.
//

import UIKit

class PieChartVC: UIViewController {
    
    
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pieChartView = PieChartView(frame: CGRect(x: 100, y: 80, width: 180, height: 180))
           view.addSubview(pieChartView)
  //      let LeavePieChartView = LeavePieChartView(frame: CGRect(x: 20, y: 300, width: 170, height: 170))
  //         view.addSubview(LeavePieChartView)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: "employeedetailCell", bundle: nil), forCellReuseIdentifier: "employeedetailCell")
        EmployeedetailsApi()
    }
    
    func EmployeedetailsApi() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kLeaveCancel) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                
            }else{
                print(response?["error"] as Any)
            }
            self.tableview.reloadData()
        }
    }
    
    
}

extension PieChartVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeedetailCell", for: indexPath) as! employeedetailCell
        
            return cell
        
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
    }
    
}

