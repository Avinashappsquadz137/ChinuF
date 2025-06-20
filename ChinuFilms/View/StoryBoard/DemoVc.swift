//
//  DemoVc.swift
//  SanskarEP
//
//  Created by Vaibhav on 04/04/25.
//

import UIKit

class DemoVc: UIViewController {

    @IBOutlet weak var Democolloction: UICollectionView!
    
    var ReqType  = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SideBarApi()
        Democolloction.register(UINib(nibName: "MainHeaderCell" , bundle: nil), forCellWithReuseIdentifier: "Cell")
        Democolloction.delegate = self
        Democolloction.dataSource = self
        
    }
    
    func SideBarApi() {
            var dict = Dictionary<String, Any>()
            dict["EmpCode"] = currentUser.EmpCode
          //  dict["id"] = "1"
            DispatchQueue.main.async { Loader.showLoader() }
            APIManager.apiCall(postData: dict as NSDictionary, url: sidebarapi) { result, response, error, data in
                DispatchQueue.main.async { Loader.hideLoader() }
                if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true,
                   let data = JSON["data"] as? [[String: Any]] {
                    self.ReqType = data
                    DispatchQueue.main.async {
                        self.Democolloction.reloadData()
                       
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
  

}
extension DemoVc: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return ReqType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MainHeaderCell else {
            return UICollectionViewCell()
        }
        cell.namelable.text = ReqType[indexPath.row]["name"] as? String ?? ""
   
    
      
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


