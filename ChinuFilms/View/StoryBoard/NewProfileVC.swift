//
//  NewProfileVC.swift
//  SanskarEP
//
//  Created by Surya on 28/10/23.
//

import UIKit

class NewProfileVC: UIViewController {

    @IBOutlet weak var Headerview: UIView!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var empCode: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var plLbl: UILabel!
    @IBOutlet weak var joinDate: UILabel!
    @IBOutlet weak var desgnLbl: UILabel!
    @IBOutlet weak var departLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var reportLbl: UILabel!
    @IBOutlet weak var panLbl: UILabel!
    @IBOutlet weak var aadharLbl: UILabel!
    @IBOutlet weak var bloodLbl: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var notifyLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let noteCount = UserDefaults.standard.value(forKey: "noteCount") as? Int ?? 0
        if noteCount > 0 {
            notifyLbl.isHidden = false
        }else{
            notifyLbl.isHidden = true
        }
    }

    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func Approval(_ sender: UIButton) {
        
    }
    func updateUI() {
        //Mark:- Profile Pic
        profile.circleImg(2.0, UIColor.gray)
        let img = currentUser.PImg.replacingOccurrences(of: " ", with: "%20")
        print(img)
        profile.sd_setImage(with: URL(string: img), placeholderImage: UIImage(systemName: "person.circle.fill"), options: .refreshCached, completed: nil)
        //Mark:- Emp Details
        baseView.layer.cornerRadius = 20
        baseView.clipsToBounds = true
        notifyLbl.circleLbl()
        let noteNo = UserDefaults.standard.value(forKey: "noteCount")
        if let noteNo = noteNo as? Int{
            notifyLbl.text = "\(noteNo)"
        }
        empCode.text = currentUser.EmpCode
        empName.text = currentUser.Name
        plLbl.text = currentUser.pl_balance
        joinDate.text = currentUser.JDate
        desgnLbl.text = currentUser.Designation
        departLbl.text = currentUser.Dept
        addressLbl.text = currentUser.address
        reportLbl.text = currentUser.ReportTo
        panLbl.text = currentUser.PanNo
        aadharLbl.text = currentUser.AadharNo
        bloodLbl.text = currentUser.BloodGroup
        logoutBtn.layer.cornerRadius = 10.0
        logoutBtn.clipsToBounds = true
        
    }
    @IBAction func logoutBtnPressed(_ sender: UIButton) {
        
        currentUser.removeData()
        if #available(iOS 13.0, *) {
            SceneDelegate.shared?.AppFlow()
        }else{
            AppDelegate.shared?.AppFlow()
        }
    }
    @IBAction func noteBtnPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVc") as! NotificationVc
        vc.titleTxt = "Notification"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
