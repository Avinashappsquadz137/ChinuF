
//  SecondnewApprovalVc.swift
//  SanskarEP
//
//  Created by Surya on 05/02/25.
//

import UIKit

class SecondnewApprovalVc: UIViewController {
    
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    
    var ReqType  = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SideBarApi()
        collectionview.register(UINib(nibName: "ApprvlCollCell" , bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionview.delegate = self
        collectionview.dataSource = self
        
    }
    
    
    func SideBarApi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        
        if currentUser.Code == "H" {
            dict["id"] = "1"
        }
        DispatchQueue.main.async { Loader.showLoader() }
        APIManager.apiCall(postData: dict as NSDictionary, url: sidebarapi) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }
            if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true,
               let data = JSON["data"] as? [[String: Any]] {
                self.ReqType = data
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                    
                }
            } else {
                if let message = response?.validatedValue("message") as? String {
                    AlertController.alert(message: message)
                } else {
                    AlertController.alert(message: "An unexpected error occurred.")
                }
            }
        }
    }
    
    @objc func onClickedMapButton(_ sender: UIButton) {
        print(sender.tag)
        let index = sender.tag
        switch sender.tag {
        case 0 :
            let vc = storyboard?.instantiateViewController(withIdentifier: "LeaveTypeVc") as! LeaveTypeVc
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    var customDetent: UISheetPresentationController.Detent?
                    if #available(iOS 16.0, *) {
                        customDetent = UISheetPresentationController.Detent.custom { context in
                            return 540
                        }
                        sheet.detents = [customDetent!]
                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                    }
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 12
                }
            }
            //  present(vc, animated: true, completion: nil)
            self.present(vc,animated: true,completion: nil)
        case 1 :
            let vc = storyboard?.instantiateViewController(withIdentifier: "BookingtypeVc") as! BookingtypeVc
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    var customDetent: UISheetPresentationController.Detent?
                    if #available(iOS 16.0, *) {
                        customDetent = UISheetPresentationController.Detent.custom { context in
                            return 540
                        }
                        sheet.detents = [customDetent!]
                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                    }
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 12
                }
            }
            self.present(vc,animated: true,completion: nil)
            //        case 2 :
            //            let vc = storyboard?.instantiateViewController(withIdentifier: "TourReqtypeVC") as! TourReqtypeVC
            //            if #available(iOS 15.0, *) {
            //                if let sheet = vc.sheetPresentationController {
            //                    var customDetent: UISheetPresentationController.Detent?
            //                    if #available(iOS 16.0, *) {
            //                        customDetent = UISheetPresentationController.Detent.custom { context in
            //                            return 540
            //                        }
            //                        sheet.detents = [customDetent!]
            //                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
            //                    }
            //                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            //                    sheet.prefersGrabberVisible = true
            //                    sheet.preferredCornerRadius = 12
            //                }
            //            }
            //            self.present(vc,animated: true,completion: nil)
        default:
            break
        }
    }
}

extension SecondnewApprovalVc: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ReqType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ApprvlCollCell else {
            return UICollectionViewCell()
        }
        cell.namelabel.text = ReqType[indexPath.row]["name"] as? String ?? ""
        
        
        cell.actionbtn.tag = indexPath.row
        cell.actionbtn.addTarget(self, action: #selector(SecondnewApprovalVc.onClickedMapButton(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: 120, height: 130)
    }
}
