//
//  OthersVC.swift
//  SanskarEP
//
//  Created by Surya on 25/06/24.
//

import UIKit

class OthersVC: UIViewController {

    @IBOutlet weak var tablrview: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var Datalist = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LeddetailApi()
        tablrview.dataSource = self
        tablrview.delegate = self
        tablrview.register(UINib(nibName: "ReceptionListCell", bundle: nil), forCellReuseIdentifier: "ReceptionListCell")
    }
    

   

    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    func LeddetailApi() {
      
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: leddetailapi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true {
                print(JSON)
                if let data = JSON["data"] as? [[String:Any]] {
                    print(data)
                    self.Datalist = data
                    print(self.Datalist)
                    DispatchQueue.main.async {
                       self.tablrview.reloadData()
                    }
                }
            }  else {
                
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
            self.tablrview.reloadData()
        }
    }
}
extension OthersVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReceptionListCell", for: indexPath) as? ReceptionListCell else {
                return UITableViewCell()
            }
        let index = Datalist[indexPath.row]
        cell.namelbl.text = "\(index["caller_name"] as? String ?? "")"
        cell.citylbl.text = "\(index["location"] as? String ?? "")"
        cell.assignlbl.text = "\(index["sales_person"] as? String ?? "")"
        cell.remarkslbl.text = "\(index["remarks"] as? String ?? "")"
        cell.contactlbl.text = "\(index["caller_mobile"] as? String ?? "")"
        
     //   cell.contactlbl.text = "+911234567890"
           
            return cell
        }
    }

extension OthersVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}
