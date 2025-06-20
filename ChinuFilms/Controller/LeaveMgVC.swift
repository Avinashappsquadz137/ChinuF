//
//  LeaveMgVC.swift
//  SanskarEP
//
//  Created by Warln on 19/04/22.
//

import UIKit

class LeaveMgVC: UIViewController {
    
    @IBOutlet weak var holderLbl: UILabel!
    
    var titleTxt: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        holderLbl.text = titleTxt
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton ) {
        self.navigationController?.popViewController(animated: true)
    
            dismiss(animated: true,completion: nil)
    }
    
    @IBAction func leaveRequestAction(_ sender: UIButton) {
        switch sender.tag{
        case 80:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.requestVc) as! RequestMgVc
            vc.titleSt = "All Report"
            vc.isCome = "leave"
           // navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        case 81:
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.leaveRequestVc) as! LeaveRequestVc
            vc.headerTxt = "New Request"
           // navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        default:
            break
        }
    }
    
    

}
