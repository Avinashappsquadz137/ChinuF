//
//  workFromHome.swift
//  SanskarEP
//
//  Created by Warln on 20/01/22.
//

import UIKit

class workFromHome: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var headerLbL: UILabel!
    
    var titleTxt: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
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

        
    }
    
    func setup() {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.layer.borderWidth = 2.0
        profileImg.layer.borderColor = UIColor.lightGray.cgColor
        profileImg.clipsToBounds = true
        headerLbL.text = titleTxt
        
        let img = currentUser.PImg.replacingOccurrences(of: " ", with: "%20")
        profileImg.sd_setImage(with: URL(string:img), placeholderImage: UIImage(systemName: "person.circle.fill"), options: .refreshCached, completed: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton){
        dismiss(animated: true,completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func attendanceBtnPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 32:
            attendance(with: "1")
        case 33:
            attendance(with: "")
        default:
            break
        }
        
    }
    
    func attendance(with time: String) {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["In_time"] = time
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kattend) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true),response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }else{
                print(response?["error"] as Any)
                AlertController.alert(message: "You are not approve")
            }
        }
    }
    
    
}
