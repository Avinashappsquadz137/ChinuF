//
//  Requestvc.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 03/08/24.
//

import UIKit

class Requestvc: UIViewController {
    
    @IBOutlet weak var tableview:UITableView!
    
    var dataList = [ChallanData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "datatablecell", bundle: nil), forCellReuseIdentifier: "datatablecell")
        tableview.delegate = self
        tableview.dataSource = self
        getRequestDetail()
    }
    
    func getRequestDetail() {
            var dict = [String: Any]()
            dict["emp_code"] = "SANS-00290"
            
            APIManager.apiCall(postData: dict as NSDictionary, url: requestdetailapi) { result, response, error, data in
                DispatchQueue.main.async {
                    Loader.hideLoader()
                }
                if let JSONData = data {
                    print(JSONData)
                    do {
                        let response = try JSONDecoder().decode(ChallanResponse.self, from: JSONData)
                        if response.status {
                            self.dataList = response.data
                            DispatchQueue.main.async {
                                self.tableview.reloadData()
                            }
                        } else {
                            print(response.message)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else if let error = error {
                    print("API call error: \(error)")
                }
            }
        }
    
    
    @IBAction func backbtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }


}
extension Requestvc: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datatablecell", for: indexPath) as! datatablecell
        let datum = dataList[indexPath.section]
        cell.dateLbl.text = datum.name
        cell.locationlbl.text = datum.mobileNo
        cell.openbtn.setTitle("Open", for: .normal)
        
        
        
//        cell.buttonAction = { [weak self] in
//                   self?.openPDF(for: indexPath.section)
//               }
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        if #available(iOS 15.0, *) {
            view.backgroundColor = UIColor.clear
        } else {
        }
        return view
    }
    
//    func openPDF(for section: Int) {
//           let pdfData = dataList[section].challanDetail
//           let pdfBaseURL = "https://sap.sanskargroup.in/Files/"
//           let pdfURLString = pdfBaseURL + pdfData
//
//           if let pdfURL = URL(string: pdfURLString) {
//               let vc = self.storyboard?.instantiateViewController(withIdentifier: "openpdfvc") as! openpdfvc
//               vc.pdfURL = pdfURL
//               self.navigationController?.pushViewController(vc, animated: true)
//           } else {
//               // Handle invalid URL case
//               print("Invalid URL string: \(pdfURLString)")
//           }
//       }

    
}
