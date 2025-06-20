//
//  ReportAllVc.swift
//  SanskarEP
//
//  Created by Surya on 25/12/24.
//

import UIKit

class ReportAllVc: UIViewController {
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var Empname: UILabel!
    @IBOutlet weak var Empcode: UILabel!
    @IBOutlet weak var EmpDepart: UILabel!
    @IBOutlet weak var Empimage: UIImageView!
    
    
    var staticItems = [
        ["month": "month", "Full": "Full", "Half": "Half", "Tour": "Tour", "WFH": "WFH"]]
    let itemKeys = ["month", "Full", "Half", "Tour", "WFH"]
    var empCode: String?
    var empname: String?
    var empdepart: String?
    var empimage =  String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailApi()
        
        Empname.text = empname
        Empcode.text = empCode
        EmpDepart.text = empdepart
        let img = empimage.replacingOccurrences(of: " ", with: "%20")
        print(img)
        Empimage.sd_setImage(with: URL(string: img))
        Empimage.layer.borderWidth = 1.0
        Empimage.layer.borderColor = UIColor.black.cgColor
        Empimage.layer.cornerRadius = 5.0
        mainview.layer.cornerRadius = 8.0
       
    }
    
//    func detailApi() {
//        var dict = Dictionary<String, Any>()
//        dict["EmpCode"] = empCode
//        DispatchQueue.main.async { Loader.showLoader() }
//        APIManager.apiCall(postData: dict as NSDictionary, url: EmployeeDetailApi) { result, response, error, data in
//            DispatchQueue.main.async { Loader.hideLoader() }
//            if let responseData = response, let dataArray = responseData["data"] as? [[String: Any]] {
//                for item in dataArray {
//                    if let month = item["month"] as? String {
//                        let full = "\(item["F"] ?? "0")"
//                        let half = "\(item["H"] ?? "0")"
//                        let wfh = "\(item["WFH"] ?? "0")"
//                        let tour = "\(item["Tour"] ?? "0")"
//                        let row: [String: String] = [
//                            "month": month,
//                            "Full": full,
//                            "Half": half,
//                            "Tour": tour,
//                            "WFH": wfh
//                        ]
//                        self.staticItems.append(row)
//                    }
//                }
//                self.collectionview.reloadData()
//            } else {
//                print(response?["error"] as Any)
//            }
//        }
//    }
    func detailApi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = empCode
        DispatchQueue.main.async { Loader.showLoader() }
        APIManager.apiCall(postData: dict as NSDictionary, url: EmployeeDetailApi) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }
            if let responseData = response, let dataArray = responseData["data"] as? [[String: Any]] {
                for item in dataArray {
                    if let monthFull = item["month"] as? String {
                        let monthComponents = monthFull.split(separator: " ")
                        let month = String(monthComponents.first ?? "")
                        let full = "\(item["F"] ?? "0")"
                        let half = "\(item["H"] ?? "0")"
                        let wfh = "\(item["WFH"] ?? "0")"
                        let tour = "\(item["Tour"] ?? "0")"
                        let row: [String: String] = [
                            "month": month,
                            "Full": full,
                            "Half": half,
                            "Tour": tour,
                            "WFH": wfh
                        ]
                        self.staticItems.append(row)
                    }
                }
                self.collectionview.reloadData()
            } else {
                print(response?["error"] as Any)
            }
        }
    }
}

extension ReportAllVc: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return staticItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ReportCollectionView else {
            return UICollectionViewCell()
        }
        let sectionKey = itemKeys[indexPath.section]
           let rowData = staticItems[indexPath.item]
           
           if let value = rowData[sectionKey] {
               cell.label.text = " \(value)"
           }
        let width = collectionview.frame.width / CGFloat(itemKeys.count + 1) - 0.8
        let height = 40
        cell.setCellSize(width: width, height: CGFloat(height))
        return cell
    }
}

extension ReportAllVc: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 0.5 * CGFloat(itemKeys.count - 1)
        let width = (collectionView.frame.width - totalSpacing) / CGFloat(itemKeys.count)
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
}
