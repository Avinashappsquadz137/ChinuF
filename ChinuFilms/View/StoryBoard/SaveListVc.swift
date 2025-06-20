//
//  SaveListVc.swift
//  SanskarEP
//
//  Created by Surya on 26/03/24.
//

import UIKit

class SaveListVc: UIViewController {
    

    @IBOutlet weak var tableview: UITableView!
    
    var datalist: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "TableBookCell", bundle: nil), forCellReuseIdentifier: "TableBookCell")
        boookingApi()
    }
    

    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
   
    
    func boookingApi() {
        var dict = Dictionary<String, Any>()
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: kathabookingdetailApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                if let dataArray = responseData["data"] as? [[String: Any]] {
                    // Parse and update your datalist here
                    self.datalist = dataArray
                    // Reload the tableview
                    self.tableview.reloadData()
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }


}
extension SaveListVc: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableBookCell", for: indexPath) as! TableBookCell


    
        
        if let rowData = datalist[indexPath.row] as? [String: Any] {
            cell.Namelbl.text = rowData["Name"] as? String ?? ""
            cell.amountlbl.text = rowData["Amount"] as? String ?? ""
            cell.Location.text = rowData["Venue"] as? String ?? ""
            cell.venuelbl.text = rowData["Venue"] as? String ?? ""
            cell.channellbl.text = rowData["ChannelName"] as? String ?? ""
            //     cell.DateLbl.text = rowData["Date"] as? String ?? ""
                cell.timelbl.text = rowData["KathaTiming"] as? String ?? ""
            cell.bookingidlbl.text = rowData["Katha_Booking_Id"] as? String ?? ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
        
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
