//
//  SheetViewController3.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 27/04/23.
//

import UIKit

class SheetViewController3: UIViewController,UISheetPresentationControllerDelegate {

    
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //Mark: Variable
    var titleSt: String?
    var type: String?
    var list = [Booking(title: "New Booking", image: "request-2")]
    var isCome: String?
    var leaveTask = [
        //leaveManager(taskName: "Leave Request", taskImg: "Leave"),
        leaveManager(taskName: "OFF Day Request", taskImg: "Schedule"),
        leaveManager(taskName: "Leave Cancellation", taskImg: "Cancelled"),]
    var request:[RequestDetail] = []
    
    @available(iOS 15.0, *)
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: kCell.requestCell, bundle: nil), forCellReuseIdentifier: kCell.requestCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
       titleName.text = titleSt
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isCome == "leave" {
            request = [        RequestDetail(title: "Full Day Leave Status", image: "report"),
                               RequestDetail(title: "Half Day Leave Status", image: "report"),
                               RequestDetail(title: "Tour Request Status", image: "report"),
                               RequestDetail(title: "Off Day Request Status", image: "report")
            ]
            
        }else{
            request = [     RequestDetail(title: "Advance Request", image: "loan"),
                            RequestDetail(title: "Pay-Slip Request", image: "slip"),
                            RequestDetail(title: "Stationary Request", image: "stationery-container"),
                            RequestDetail(title: "Work From Home Request", image: "Work-from-home"),
                            RequestDetail(title: "OFF Day Request", image: "Schedule"),
                          RequestDetail(title: "Leave Cancellation", image: "Cancelled"),
                            RequestDetail(title: "Leave Request", image: "Leave"),
                            RequestDetail(title: "Tour", image: "traveler-with-a-suitcase"),
                            RequestDetail(title: "New Booking", image: "request-2")
            ]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        idenity.isCome = ""
    }
    
    //MARK: - IBOutlet Button Pressed
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 7:
            self.navigationController?.popViewController(animated: true)
        case 8:
            self.performSegue(withIdentifier: idenity.requestToSee, sender: self)
        default:
            print("Nothing")
        }
        
    }
    
}

//MARK: - UITavleVIewDataSource

extension SheetViewController3: UITableViewDataSource {
    
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
extension SheetViewController3: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView =  UIView()
        return headerView
    }
    
    
}
//MARK: - Extra Funcationality
extension SheetViewController3 {
    
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
                let vc = storyboard?.instantiateViewController(withIdentifier: "ReuestTypeVc") as! ReuestTypeVc
                vc.reportTxt = "Advance Report"
                vc.newTxt = "New Advance Request"
                vc.type = "Ad"
                vc.titleTxt = request[sender.tag].title
                navigationController?.pushViewController(vc, animated: true)
//                let index = indexPath.row
            case 1:
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.payslip) as! PaySlipVc
                vc.titleTxt = request[sender.tag].title
                navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = storyboard?.instantiateViewController(withIdentifier: "ReuestTypeVc") as! ReuestTypeVc
                vc.reportTxt = "All Report"
                vc.newTxt = "New Stationary Request"
                vc.titleTxt = request[sender.tag].title
                navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.payslip) as! PaySlipVc
                vc.titleTxt = request[sender.tag].title
                vc.wkhome = true
                navigationController?.pushViewController(vc, animated: true)
            case 4:
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.offDayVc) as! offDayVc
             
 //              vc.ttitleTxt = leaveTask[index].taskName
                navigationController?.pushViewController(vc, animated: true)
            case 5:
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.leaveCancel) as! LeaveCancel
//                vc.titleTxt = leaveTask[index].taskName
                navigationController?.pushViewController(vc, animated: true)
            case 6:
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.leaveRequestVc) as! LeaveRequestVc
                navigationController?.pushViewController(vc, animated: true)
            case 7:
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.tour) as! TourManageVc
                navigationController?.pushViewController(vc, animated: true)
            case 8:
                let vc = storyboard?.instantiateViewController(withIdentifier: "NewBookVc") as! NewBookVc;                 navigationController?.pushViewController(vc, animated: true)
            default:
                print(sender.tag)
            }
            
            
        }
        
    }
}
