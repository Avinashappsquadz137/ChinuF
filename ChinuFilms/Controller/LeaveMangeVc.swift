//
//  LeaveMangeVc.swift
//  SanskarEP
//
//  Created by Warln on 12/01/22.
//

import UIKit

class LeaveMangeVc: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
   
    
    
    //Mark:- Variable
    var titletext: String?
   
//    var rew: String?
    var leaveTask = [
        leaveManager(taskName: "PL Summary", taskImg: "request-2"),
        leaveManager(taskName: "Full Day Leave Status", taskImg: "request-2"),
        leaveManager(taskName: "Half Day Leave Status", taskImg: "request-2"),
        leaveManager(taskName: "Off Day Request Status", taskImg: "request-2"),
        leaveManager(taskName: "Tour Request Status", taskImg: "request-2"),
    //    leaveManager(taskName: "Work From Home Attendance", taskImg: "Work-from-home"),
        leaveManager(taskName: "Tour Detail's", taskImg: "traveler-with-a-suitcase")
       
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        //   tourdata()
        titleLbl.text = titletext
        tableView.register(UINib(nibName: kCell.leaveCell, bundle: nil), forCellReuseIdentifier: kCell.leaveCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.reloadData()
//        if #available(iOS 15.0, *) {
//            sheetPresentationController?.prefersGrabberVisible = true
//        } else {
//            // Fallback on earlier versions
//        }
//        if #available(iOS 15.0, *) {
//            sheetPresentationController?.detents = [.large()]
//        } else {
//            // Fallback on earlier versions
//        }
        if currentUser.Code == "H"{
            let data =  leaveManager(taskName: "Booking Detail's", taskImg: "request-2")
            leaveTask.insert(data, at: 6)
//            let vc =  leaveManager(taskName: "All Booking", taskImg: "Schedule")
//            leaveTask.insert(vc, at: 7)
        }
    }
        

    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    //MARK: - IBAction Button Pressed
    
                    func btnActionPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1 :
            self.navigationController?.popViewController(animated: true)
        case 2 :
            self.performSegue(withIdentifier: idenity.ltSearch, sender: self)
        default:
            print("Nothing")
        }
    }
    func check(status: String ) -> String {
        
        switch status {
        case "A":
            return " Approve"
        case "R":
            return " Pending"
        case "XA":
            return " Declined"
        case "X":
            return " Cancel"
        default:
            return ""
        }
    }
    
    func sColor(status: String ) -> UIColor {
        
        switch status {
        case "A":
            return .green
        case "R":
            return .yellow
        case "XA":
            return .red
        case "X":
            return .purple
        default:
            return .black
        }
    }
}

//MARK: - UITableView Datasource

extension LeaveMangeVc: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaveTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCell.leaveCell, for: indexPath) as? leaveMgCell else {
            return UITableViewCell()
        }
        
        let image = UIImage(named: leaveTask[indexPath.row].taskImg)
        cell.imgView.image = image
        cell.titleLbl.text = leaveTask[indexPath.row].taskName
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    
    
}
//MARK: - UITableView Delegate

extension LeaveMangeVc: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let index = indexPath.row
        switch index {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "PLVc") as! PLVc
            vc.titleTxt = leaveTask[index].taskName
            navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "fulldayStatusVC") as! fulldayStatusVC
            self.present(vc,animated: true,completion: nil)
//
       case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: "halfdayStatusVc") as! halfdayStatusVc
            self.present(vc,animated: true,completion: nil)
       case 3:
            let vc = storyboard?.instantiateViewController(withIdentifier: "offDaySVC") as! offDaySVC
            self.present(vc,animated: true,completion: nil)
        case 4:
            let vc = storyboard?.instantiateViewController(withIdentifier: "TourStatusVc") as! TourStatusVc
            self.present(vc,animated: true,completion: nil)
//        case 5:
//            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kWFHVC) as! workFromHome
//            vc.titleTxt = leaveTask[index].taskName
//            navigationController?.pushViewController(vc, animated: true)
//            self.present(vc,animated: true,completion: nil)
        case 5:
            let vc = storyboard?.instantiateViewController(withIdentifier: "TourDetail_sVc") as! TourDetail_sVc
            vc.titletext = leaveTask[index].taskName
            self.present(vc,animated: true,completion: nil)
      
        case 6:
            let vc = storyboard?.instantiateViewController(withIdentifier: "BookingDetailsVc") as! BookingDetailsVc
      //      vc.titleTxt = leaveTask[index].taskName
            self.present(vc,animated: true,completion: nil)
//        case 7:
//            let AllTour = storyboard?.instantiateViewController(withIdentifier: "AllBookingVC") as! AllBookingVC
//            AllTour.titleTxt = leaveTask[index].taskName
//            self.present(AllTour,animated: true,completion: nil)
        default:
            print(index)
        }
    }
    
}
