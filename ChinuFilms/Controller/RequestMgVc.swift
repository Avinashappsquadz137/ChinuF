//
//  RequestMgVc.swift
//  SanskarEP
//
//  Created by Warln on 13/01/22.
//

import UIKit

class RequestMgVc: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //Mark: Variable
    var newTxt: String?
    var titleSt: String?
    var type: String?
    var list = [Booking(title: "New Booking", image: "request-2")]
    var isCome: String?
    var titleTxt: String?
    var leaveTask = [
        //leaveManager(taskName: "Leave Request", taskImg: "Leave"),
        leaveManager(taskName: "OFF Day Request", taskImg: "Schedule"),
        leaveManager(taskName: "Leave Cancellation", taskImg: "Cancelled"),]
    var request:[RequestDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: kCell.requestCell, bundle: nil), forCellReuseIdentifier: kCell.requestCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
     //   titleName.text = titleSt
        if #available(iOS 15.0, *) {
            sheetPresentationController?.prefersGrabberVisible = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            sheetPresentationController?.detents = [.large()]
        } else {
            // Fallback on earlier versions
        }
//        if currentUser.Code == "H"{
//            let data =   RequestDetail(title: "New Booking", image: "report")
//            request.insert(data, at: 7)
//            
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isCome == "leave" {
            request = [        RequestDetail(title: "Full Day Leave Status", image: "report"),
                               RequestDetail(title: "Half Day Leave Status", image: "report"),
                               RequestDetail(title: "Tour Request Status", image: "report"),
                               RequestDetail(title: "Off Day Request Status", image: "report")
            ]
            
        }else{
            request = [
                RequestDetail(title: "Leave Request", image: "Leave"),
                RequestDetail(title: "Tour", image: "traveler-with-a-suitcase"),
                RequestDetail(title: "OFF Day Request", image: "Schedule"),
                RequestDetail(title: "Leave Cancellation", image: "Cancelled"),
                RequestDetail(title: "Work From Home Request", image: "Work-from-home"),
//                RequestDetail(title: "Advance", image: "loan"),
//                RequestDetail(title: "Pay-Slip Request", image: "slip"),
//                RequestDetail(title: "Stationary Request", image: "stationery-container"),
               
                
            ]
//            if currentUser.Code == "H" {
//                let data = RequestDetail(title: "Booking", image: "request-2")
//                request.insert(data, at: 3)
//            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        idenity.isCome = ""
    }
    
    //MARK: - IBOutlet Button Pressed
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
//        switch sender.tag {
//        case 7:
//            self.navigationController?.popViewController(animated: true)
//        case 8:
//            self.performSegue(withIdentifier: idenity.requestToSee, sender: self)
//        default:
//            print("Nothing")
//        }
        
    }
    
    
}

//MARK: - UITavleVIewDataSource

extension RequestMgVc: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return request.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCell.requestCell, for: indexPath) as? RequestMgCell else {
            return UITableViewCell()
        }
        
        let image = request[indexPath.row].image
        cell.titleName.text = request[indexPath.row].title
        cell.imgview.image = UIImage(named: image)
        cell.reqBtn.tag = indexPath.row
        cell.reqBtn.addTarget(self, action: #selector(RequestMgVc.tapRequestCell(_:)), for: .touchUpInside)
        return cell
    }
    
    
}

//MARK: - Hit Api


//MARK: - UITableView Delegate
extension RequestMgVc: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView =  UIView()
        return headerView
    }
    
    
}
//MARK: - Extra Funcationality
extension RequestMgVc {
    
    @objc func tapRequestCell(_ sender: UIButton) {
        
       
        if isCome == "leave"{
          
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.leaveRep) as! leaveReport
            switch sender.tag{
            case 0:
                vc.type = "full"
            case 1:
                vc.type = "half"
            case 2:
                vc.type = "tour"
            case 3:
                vc.type = "off"
            default:
                break
            }
            vc.titleTxt = request[sender.tag].title
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
           
            switch sender.tag{
            case 0:
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.leaveRequestVc) as! LeaveRequestVc
               // navigationController?.pushViewController(vc, animated: true)
                vc.headerTxt = request[sender.tag].title
                self.present(vc,animated: true,completion: nil)
            case 1:
                let vc = storyboard?.instantiateViewController(withIdentifier: "TourVC") as! TourVC
               // navigationController?.pushViewController(vc, animated: true)
                vc.titleTxt = request[sender.tag].title
                self.present(vc,animated: true,completion: nil)
            case 2:
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.offDayVc) as! offDayVc
             
 //              vc.ttitleTxt = leaveTask[index].taskName
                // navigationController?.pushViewController(vc, animated: true)
                vc.ttitleTxt = request[sender.tag].title
                self.present(vc,animated: true,completion: nil)
            case 3:
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.leaveCancel) as! LeaveCancel
                vc.titleTxt = request[sender.tag].title
            //    navigationController?.pushViewController(vc, animated: true)
                self.present(vc,animated: true,completion: nil)
           
//            case 4:
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdvcanceVC" ) as! AdvcanceVC
//         //       vc.titleTxt = newTxt
//                vc.titleTxt = request[sender.tag].title
//           //     self.navigationController?.pushViewController(vc, animated: true)
//                self.present(vc,animated: true,completion: nil)
//            case 5:
//                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.payslip) as! PaySlipVc
//                vc.titleTxt = request[sender.tag].title
// //               navigationController?.pushViewController(vc, animated: true)
//                self.present(vc,animated: true,completion: nil)
//            case 6:
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: idenity.healthVc ) as! HealthVc
//                vc.stat = true
//           //     vc.titleTxt = newTxt
//                vc.titleTxt = request[sender.tag].title
//                self.present(vc,animated: true,completion: nil)
            case 4:
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.payslip) as! PaySlipVc
                vc.titleTxt = request[sender.tag].title
                vc.wkhome = true
              //  navigationController?.pushViewController(vc, animated: true)
                self.present(vc,animated: true,completion: nil)
//            case 8:
//                let vc = storyboard?.instantiateViewController(withIdentifier: "KathaVC") as! KathaVC
//                //navigationController?.pushViewController(vc, animated: true)
//          //      vc.titleTxt = request[sender.tag].title
//                self.present(vc,animated: true,completion: nil)
            default:
                print(sender.tag)
            }
            
            
        }
        
    }
}
