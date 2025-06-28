//
//  forgetVc.swift
//  SanskarEP
//
//  Created by Warln on 15/01/22.
//

import UIKit

class forgetVc: UIViewController {
    
    @IBOutlet weak var mobileTxt: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    var otpModel: [String:Any]?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
    }
    
    //MARK: - setup UI
    
    func setup() {
        
        mobileTxt.delegate = self
        mobileTxt.layer.borderColor = UIColor.orange.cgColor
        mobileTxt.layer.borderWidth = 2.0
        mobileTxt.layer.cornerRadius = 10
        mobileTxt.clipsToBounds = true
        
    }
    
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        mobileTxt.endEditing(true)
        
    }

}

//MARK: - UITextField Delegate

extension forgetVc: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mobileTxt.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else{
            AlertController.alert(message: "Please Enter Mobile Number")
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let number = mobileTxt.text {
            sendOpt(with: number)
        }
        mobileTxt.text = ""
    }
}

//MARK: - Override segue

extension forgetVc {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == idenity.forgetTo {
            let destination = segue.destination as! PasswordVc
            destination.otpData = otpModel
            destination.completionBlock = {() -> ()in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
}

//MARK: - Extra Functionality

extension forgetVc {
    
    func sendOpt(with number: String) {
        idenity.kDeviceToken = UserDefaults.standard.value(forKey: "token") as? String ?? "123456"
        var dict = Dictionary<String,Any>()
        dict["CntNo"] = number
        dict["Device-Id"] = currentUser.DeviceId
        dict["User-Type"] = currentUser.device_type
        dict["Device-Model"] = currentUser.deviceModel
        dict["device_token"] = idenity.kDeviceToken
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: getLogin) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                let json = response?["data"] as? [String:Any] ?? [:]
                self.otpModel = json
                self.performSegue(withIdentifier: idenity.forgetTo, sender: self)
                AlertController.alert(message: "Successfully sent message")
            }else{
                print(response?["error"] as Any)
            }
            
        }
    }
    
}
