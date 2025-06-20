//
//  Savedchallanvc.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 03/08/24.
//

import UIKit

class Savedchallanvc: UIViewController {
    
    @IBOutlet weak var tableview:UITableView!
    
    var dataList: [Datum] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "datatablecell", bundle: nil), forCellReuseIdentifier: "datatablecell")
        tableview.delegate = self
        tableview.dataSource = self
        getsavedddetail()
        
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func getsavedddetail() {
        var dict = [String: Any]()
        dict["emp_code"] = "SANS-00290" // Use the correct key as per the API error message
        dict["type"] = "0"
        
        APIManager.apiCall(postData: dict as NSDictionary, url: submitedlistapi) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }
            if let JSONData = data {
                print(JSONData)
                do {
                    let welcome = try JSONDecoder().decode(Welcome.self, from: JSONData)
                    if welcome.status {
                        self.dataList = welcome.data
                        DispatchQueue.main.async {
                            self.tableview.reloadData() // Assuming you have an IBOutlet for the table view
                        }
                    } else {
                        print(welcome.message)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("API call error: \(error)")
            }
        }
    }

}

extension Savedchallanvc:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datatablecell", for: indexPath) as! datatablecell
        
        let datum = dataList[indexPath.section]
        cell.dateLbl.text = datum.challanDate
        cell.locationlbl.text = datum.fromLocation + " To " + datum.toLocation
        
        cell.openbtn.tag = indexPath.section
        cell.openbtn.addTarget(self, action: #selector(opendata(_:)), for: .touchUpInside)
        
        return cell
    }
    @objc func opendata(_ sender: UIButton) {
        let section = sender.tag
                let datum = dataList[section]
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Addinventordetailvc") as! Addinventordetailvc
                vc.data = datum
                
                self.navigationController?.pushViewController(vc, animated: true)
        }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        if #available(iOS 15.0, *) {
            view.backgroundColor = UIColor.clear
        } else {
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
}
