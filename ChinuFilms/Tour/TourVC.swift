//
//  TourVC.swift
//  SanskarEP
//
//  Created by Surya on 17/10/23.
//

import UIKit

class TourVC: UIViewController {
    

    @IBOutlet weak var Header: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
   
    var titleTxt: String?
    var Tourid = [String]()
    var tourloc = [String]()
    var Serial   = [Int]()
    var SaveList  = [[String:Any]]()
    var SubList  = [[String:Any]]()
    var tours = [tour]()
    var tourtask = [
        RequestDetail(title: "New Tour", image: "world-map"),
        RequestDetail(title: "Saved Tour Billing Request", image: "traveler-with-a-suitcase"),
    //    RequestDetail(title: "My Submited Tour's", image: "approve"),
    //    RequestDetail(title: "Approved / Rejected Tour's ", image: "Approved 1"),
       // RequestDetail(title: "Rejected Tours ", image: "remove"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tourdata()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "MaintourCell", bundle: nil), forCellReuseIdentifier: "MaintourCell")
      
    }
    

    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    

    
    func tourdata() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] =  currentUser.EmpCode
       
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: ktourApi) { [self] result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
                   
//                if let JSON = response as? NSDictionary {
//                    if JSON.value(forKey: "status") as? Bool == true {
//                        print(JSON)
//                        let data = (JSON["data"] as? [String] ?? [])
//                        print(data)
//                       self.Tourid = data
//                        print(self.Tourid)
//                    }
//                }
            if let jsonResponse = response as? [String: Any] {
                if let status = jsonResponse["status"] as? Bool, status {
                    print(jsonResponse)
                    
                    if let jsonDataArray = jsonResponse["data"] as? [[String: Any]] {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: jsonDataArray, options: [])
                            let decoder = JSONDecoder()
                            
                            self.tours = try decoder.decode([tour].self, from: jsonData)
                            for i in self.tours{
                               
                               self.Tourid.append(i.ID )
                            }
                            print(tours)
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }
            }
            
        }
    }

}
extension TourVC: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tourtask.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaintourCell", for: indexPath) as? MaintourCell else {
            return UITableViewCell()
        }
        let image = UIImage(named: tourtask[indexPath.row].image)
        cell.imageview.image = image
        cell.Label.text = tourtask[indexPath.row].title
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        switch index {
        case 0:
            
            let vc = storyboard!.instantiateViewController(withIdentifier: "TourManageVc") as! TourManageVc
            if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
            var customDetent: UISheetPresentationController.Detent?
                if #available(iOS 16.0, *) {
                customDetent = UISheetPresentationController.Detent.custom { context in
                    return 520
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
            
            
            
            
           
        case 1:    
            let vc = storyboard!.instantiateViewController(withIdentifier: "TourAllDetailsVC") as! TourAllDetailsVC
            if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
            var customDetent: UISheetPresentationController.Detent?
                if #available(iOS 16.0, *) {
                customDetent = UISheetPresentationController.Detent.custom { context in
                    return 520
                }
                sheet.detents = [customDetent!]
                sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                    }
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 12
                                }
   
                vc.type = "0"
                            }
                self.present(vc, animated: true)
            
            
            
            
//            let vc = storyboard?.instantiateViewController(withIdentifier: "TourAllDetailsVC") as! TourAllDetailsVC
//          
//            vc.type = "0"
//       
////            if Tourid .isEmpty{
////                AlertController.alert(message: "Not Tour Active.")
////
////           }else {
////                vc.TourId = tours
//               self.present(vc,animated: true,completion: nil)
            
//        case 2:
//            let vc = storyboard?.instantiateViewController(withIdentifier: "AllDetail2VC") as! AllDetail2VC
//            vc.type = "1"
//            self.present(vc,animated: true,completion: nil)
//        case 3:
//            let vc = storyboard?.instantiateViewController(withIdentifier: "ApprovedTourVC") as! ApprovedTourVC
//            vc.type = "4"
//            self.present(vc,animated: true,completion: nil)
        default:
            print(index)
        }
    }
}
