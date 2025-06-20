//
//  SheetViewController2.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 22/04/23.
//

import UIKit

class SheetViewController2: UIViewController,UISheetPresentationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    var titleSt: String?
    var status: Int?
    var text: String?
    var list = [Booking(title: "New Booking", image: "request-2"),Booking(title: "My Booking", image: "Schedule")]
    
    @available(iOS 15.0, *)
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "BookingCell", bundle: nil), forCellReuseIdentifier: "booking")
        //titleLbl.text = text
        setup()
        view.layer.cornerRadius = 15
        
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
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
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

extension SheetViewController2: UITableViewDataSource {
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

extension SheetViewController2: UITableViewDelegate {
    
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewBookVc") as! NewBookVc
            vc.titleTxt = "New Booking"
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "myBooking") as! myBooking
            vc.titleTxt = "My Booking"
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllBookingVC") as! AllBookingVC
            vc.titleTxt = "Show All Booking"
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
    
    }



