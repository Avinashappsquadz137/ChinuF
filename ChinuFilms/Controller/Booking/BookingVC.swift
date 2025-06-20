//
//  BookingVC.swift
//  SanskarEP
//
//  Created by Warln on 21/02/22.
//

import UIKit

class BookingVC: UIViewController,UISheetPresentationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var status: Int?
    var text: String?
    var list = [Booking(title: "My Booking", image: "request-2"),Booking(title: "Show All Booking", image: "Schedule")]
    
    
    @available(iOS 15.0, *)
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "BookingCell", bundle: nil), forCellReuseIdentifier: "booking")
        titleLbl.text = text
        setup()
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
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setup() {
        switch status{
        case 1:
            break
        case 2:
            let data = Booking(title: "Show All Booking", image: "Report")
            list.append(data)
            tableView.reloadData()
            break
            
        default:
            break
        }
    }
    
    
    
}

//MARK: - UITableViewDataSource

extension BookingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "booking", for: indexPath) as? BookingCell else {
            return UITableViewCell()
        }
        let data = list[indexPath.row]
        cell.titleLbl.text = data.title
        cell.img.image = UIImage(named: data.image)
        cell.selectionStyle = .none
        return cell
    }
}

extension BookingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView =  UIView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index{
            
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "myBooking") as! myBooking
            vc.titleTxt = "My Booking"
            self.present(vc,animated: true,completion: nil)
            //  self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllBookingVC") as! AllBookingVC
            vc.titleTxt = "Show All Booking"
            self.present(vc,animated: true,completion: nil)
            //self.navigationController?.pushViewController(vc, animated: true)
            
            
//        case 0:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewBookVc") as! NewBookVc
//            vc.titleTxt = "New Booking"
//            self.navigationController?.pushViewController(vc, animated: true)
        
       
       
            
        default:
            break
        }
    }
    
}

