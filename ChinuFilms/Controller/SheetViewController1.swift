//
//  SheetViewController1.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 15/04/23.
//

import UIKit

class SheetViewController1: UIViewController ,UISheetPresentationControllerDelegate {
    
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var headerlbl: UILabel!
    
    var titleTxt: String?
    
    var approve = [
        Approve(title: "Full Day Request", image: "monitor"),
        Approve(title: "Half Day Request", image: "monitor"),
        Approve(title: "Off Day Request", image: "monitor"),
        Approve(title: "Tour Day Request", image: "monitor"),
        Approve(title: "WHF Day Request", image: "monitor")
    ]

    @available(iOS 15.0, *)
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.register(UINib(nibName: "approveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "approveCollectionViewCell")
      //  headerlbl.text = titleTxt
    
        view.layer.cornerRadius = 60
       // view.backgroundColor = .
        
        
        if #available(iOS 15.0, *) {
            sheetPresentationController.delegate = self
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            sheetPresentationController.selectedDetentIdentifier = .medium
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            sheetPresentationController.prefersGrabberVisible = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            sheetPresentationController.detents = [.medium(),.large()]
        } else {
            // Fallback on earlier versions
        }
    }
    


}
extension SheetViewController1: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return approve.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier:"approveCollectionViewCell", for: indexPath) as? approveCollectionViewCell else {
            return UICollectionViewCell()
        }
        let index = approve[indexPath.row]
        cell.image.image = UIImage(named: index.image)
        cell.title.text = index.title
 //       cell.selectionStyle = .none
        return cell
    }
}
extension SheetViewController1: UICollectionViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView:UIView =  UIView()
//        return headerView
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
        let index = indexPath.row
        switch index {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kAPPList) as! AppListVc
            vc.titleTxt = approve[indexPath.row].title
            vc.type = "full"
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kAPPList) as! AppListVc
            vc.titleTxt = approve[indexPath.row].title
            vc.type = "half"
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kAPPList) as! AppListVc
            vc.titleTxt = approve[indexPath.row].title
            vc.type = "off"
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kAPPList) as! AppListVc
            vc.titleTxt = approve[indexPath.row].title
            vc.type = "tour"
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kAPPList) as! AppListVc
            vc.titleTxt = approve[indexPath.row].title
            vc.type = "WFH"
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}

extension SheetViewController1 : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.size.width / 3 - 2, height: collectionView.frame.size.height / 5 - 2)
    }
}
