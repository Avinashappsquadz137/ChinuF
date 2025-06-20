//
//  TerminateAccVc.swift
//  SanskarEP
//
//  Created by Surya on 20/12/24.
//

import UIKit

class TerminateAccVc: UIViewController {
    

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    var DetailData = [[String:Any]]()
    var filteredDetailData: [[String: Any]] = []
    var empcode : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EmployeeDetailAPi()
        filteredDetailData = DetailData
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: "bdayviewcell", bundle: nil), forCellReuseIdentifier: "bdayviewcell")
    }
    
    func EmployeeDetailAPi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: EmployeeListApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if  let responseData = response, responseData["status"] as? Bool == true {
                if let JSON = responseData["data"] as? [[String: Any]] {
                    self.DetailData = JSON
                    self.filteredDetailData = JSON
                 
                    DispatchQueue.main.async {
                      
                    }
                    self.tableview.reloadData()
                }
            } else {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                print(response?["error"] as Any)
            }
            
        }
    }
    
    func TerminatedApi() {
        var dict = Dictionary<String, Any>()
        dict["terminetedBy"] = currentUser.EmpCode
        dict["EmpCode"] = empcode
       
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: deleteaccountAPi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if  let responseData = response, responseData["status"] as? Bool == true {
                if let JSON = responseData["data"] as? [[String: Any]] {
                    DispatchQueue.main.async {
                      
                    }
                    self.tableview.reloadData()
                }
            } else {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                print(response?["error"] as Any)
            }
            
        }
    }
    
    @objc func Checkboxtapped(_ sender: UIButton) {
        let empCode = filteredDetailData[sender.tag]["EmpCode"] as? String ?? ""
        let alertController = UIAlertController(
            title: "Confirm Delete",
            message: "Are you sure you want to delete this account?",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            self.empcode = empCode
            self.TerminatedApi()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
      
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
  
        self.present(alertController, animated: true, completion: nil)
    }
}

extension TerminateAccVc: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDetailData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bdayviewcell", for: indexPath) as? bdayviewcell else {
            return UITableViewCell()
        }
        let index = filteredDetailData[indexPath.row]
        cell.MyLbl.text = "\(index["name"] as? String ?? "")"
        cell.MyLbl2.text = "\(index["EmpCode"] as? String ?? "")"
        cell.mylbl3.text = "\(index["Dept"] as? String ?? "")"
        let imageData = index["EmpImage"] as? String ?? ""
        let imgURL = imageData.replacingOccurrences(of: " ", with: "%20")
        cell.MyImage.image = nil
        cell.MyImage.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "placeholder"))
   //     cell.message.isHidden = true
        cell.msgbtn.isHidden = true
        
         empcode = filteredDetailData[indexPath.row]["EmpCode"] as? String ?? ""
        cell.terminatedbtn.tag = indexPath.row
        cell.terminatedbtn.addTarget(self, action: #selector(Checkboxtapped(_:)), for: .touchUpInside)
        return cell
        
     }
}
extension TerminateAccVc: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.isEmpty {
               filteredDetailData = DetailData
           } else {
               filteredDetailData = DetailData.filter { data in
                   let empCode = (data["EmpCode"] as? String ?? "").lowercased()
                   let name = (data["name"] as? String ?? "").lowercased()
                   return empCode.contains(searchText.lowercased()) || name.contains(searchText.lowercased())
               }
           }
           tableview.reloadData()
       }
}
