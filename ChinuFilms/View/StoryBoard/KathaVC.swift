//
//  KathaVC.swift
//  SanskarEP
//
//  Created by Surya on 04/04/24.
//

import UIKit

class KathaVC: UIViewController {
    

    @IBOutlet weak var tableview: UITableView!
    
    var titleText: String?
    var KathaTask = [
        KathaManage(title: "New Booking", image: "booking1"),
        KathaManage(title: "Approved List", image: "Approved 1"),
   //     KathaManage(title: "Submit Katha List ", image: "Guest"),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()

      
        tableview.register(UINib(nibName: "KathaCell", bundle: nil), forCellReuseIdentifier: "KathaCell")
   //     tittleLbl.text = titleText
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = .clear
        tableview.reloadData()

    }
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
   
    
}
extension KathaVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KathaTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "KathaCell", for: indexPath) as! KathaCell
            
            let image = UIImage(named: KathaTask[indexPath.row].image)
            cell.imagev.image = image
            cell.Labelu.text = KathaTask[indexPath.row].title
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .clear
            return cell
        }
    }
extension KathaVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let index = indexPath.row
        switch index {
        case 0:
          
            let vc = storyboard!.instantiateViewController(withIdentifier: "BookingKathaVc") as! BookingKathaVc
            
            if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
            var customDetent: UISheetPresentationController.Detent?
                if #available(iOS 16.0, *) {
                customDetent = UISheetPresentationController.Detent.custom { context in
                    return 600
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
            
            let vc = storyboard!.instantiateViewController(withIdentifier: "BookingPageVc") as! BookingPageVc
            
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
            
//        case 2:
//            let vc = storyboard?.instantiateViewController(withIdentifier: "SaveListVc") as! SaveListVc
//    //        vc.titleText = KathaTask[index].title
//            navigationController?.pushViewController(vc, animated: true)
//            self.present(vc,animated: true,completion: nil)
        default:
            print(index)
        }
    }
}
