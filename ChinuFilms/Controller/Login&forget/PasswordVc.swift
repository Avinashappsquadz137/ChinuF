//
//  PasswordVc.swift
//  SanskarEP
//
//  Created by Warln on 17/01/22.
//

import UIKit

typealias vCB = () ->()
typealias vCB2 = () ->()

class PasswordVc: UIViewController {
    
    @IBOutlet weak var firstTxt: UITextField!
    @IBOutlet weak var secondTxt: UITextField!
    @IBOutlet weak var thirdTxt: UITextField!
    @IBOutlet weak var fourhtTxt: UITextField!
    @IBOutlet weak var passHolder: UIView!
    @IBOutlet weak var newPassTxt: UITextField!
    @IBOutlet weak var confirmTxt: UITextField!
    @IBOutlet weak var resetLbl: UILabel!
    @IBOutlet weak var first1Txt: UITextField!
    @IBOutlet weak var Second1Txt: UITextField!
    @IBOutlet weak var Third1Txt: UITextField!
    @IBOutlet weak var Fourth1Txt: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    var otpValue: String?
    var otpData: [String:Any]?
    var completionBlock:vCB?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.layer.cornerRadius = image.frame.size.width / 2
            image.clipsToBounds = true
        setup()
        setUp()
    }
    
    //MARK: - setup Functionality
    
    func setup() {
        
        firstTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        secondTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        thirdTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        fourhtTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        firstTxt.delegate = self
        secondTxt.delegate = self
        thirdTxt.delegate = self
        fourhtTxt.delegate = self
        
        fieldColor(firstTxt)
        fieldColor(secondTxt)
        fieldColor(thirdTxt)
        fieldColor(fourhtTxt)
        passHolder.isHidden = true
        
        let stringValue = "Didn't receive the code ?  Resend"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: "Resend", withColor: UIColor.red)
        resetLbl.attributedText = attributedString
        
    }
    //MARK: -  @IBAction Button Pressed
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        
        let otp = "\(firstTxt.text!)" + "\(secondTxt.text!)" + "\(thirdTxt.text!)" + "\(fourhtTxt.text!)"
        
        if otp.isNumeric() != true {
            AlertController.alert(message: "Please enter correct format")
        }else{
            otpValue = otp
            createNew()
        }
        
        
    }
    func setUp() {

        first1Txt.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: UIControl.Event.editingChanged)
        Second1Txt.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: UIControl.Event.editingChanged)
        Third1Txt.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: UIControl.Event.editingChanged)
        Fourth1Txt.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: UIControl.Event.editingChanged)

        first1Txt.delegate = self
        Second1Txt.delegate = self
        Third1Txt.delegate = self
        Fourth1Txt.delegate = self

        fieldColor(first1Txt)
        fieldColor(Second1Txt)
        fieldColor(Third1Txt)
        fieldColor(Fourth1Txt)
        passHolder.isHidden = true

        let stringValue = "Didn't receive the code ?  Resend"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: "Resend", withColor: UIColor.red)
    resetLbl.attributedText = attributedString

    }
    @IBAction func PassSubmitBtnPressed(_ sender: UIButton) {
        
     //   if let newPass = newPassTxt.text,
    //   let confirm = confirmTxt.text {
//            if newPass != confirm {
//                AlertController.alert(message: "Your Password not match")
//            }
               let confirm = "\(first1Txt.text!)" + "\(Second1Txt.text!)" + "\(Third1Txt.text!)" + "\(Fourth1Txt.text!)"
               
                if (confirm.isNumeric() != true) && confirm.count < 4 {
                AlertController.alert(message: "Please enter 4 Digit only")
            }else if confirm.count > 4 {
                AlertController.alert(message: "Please enter 4 Digit")
            }else if confirm.count == 4{
                createPass(with: confirm)
            }
        }
        
   // }
    
    @IBAction func resendBtnPressed(_ sender: UIButton) {
        resendOpt()
    }
    
    func fieldColor(_ txtField: UITextField) {
        txtField.layer.cornerRadius = 10
        txtField.layer.borderWidth = 2.0
        txtField.layer.borderColor = UIColor.orange.cgColor
        txtField.clipsToBounds = true
    }
    
}

//MARK: - Submit and Resend otp

extension PasswordVc {
    //Mark: Resend Otp
    func resendOpt() {
        
        idenity.kDeviceToken = UserDefaults.standard.value(forKey: "token") as? String ?? "123456"
        var dict = Dictionary<String,Any>()
        dict["CntNo"] = otpData?["CntNo"] as? String ?? ""
        dict["Device-Id"] = currentUser.DeviceId
        dict["User-Type"] = currentUser.device_type
        dict["Device-Model"] = currentUser.deviceModel
        dict["device_token"] = idenity.kDeviceToken
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: getLogin) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: "Successfully resend sent message")
            }else{
                print(response?["error"] as Any)
            }
            
        }
    }
    
    //Mark: - OTP Request
    func createNew() {
        
        var dict = Dictionary<String,Any>()
        dict["CntNo"] = otpData?["CntNo"] as? String ?? ""
        dict["otp"] = "\(otpValue ?? "")"
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kVerifyOtp) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data ,(response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                self.passHolder.isHidden = false
             //   let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordVc") as! NewPasswordVc
             //   self.present(vc, animated: true)
            }else{
                print(response?["error"] as Any)
                AlertController.alert(message: "Please enter correct otp")
            }
        }
        
    }
    //Mark:- Set Pin
    func createPass(with pass: String) {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = otpData?["EmpCode"] as? String ?? ""
        dict["CntNo"] = otpData?["CntNo"] as? String ?? ""
        dict["pin"] = pass
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kNewPin) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                self.passHolder.isHidden = true
                guard let cb = self.completionBlock else {return}
                self.dismiss(animated: true, completion: {
                    self.removeData()
                    cb()
                })
            }else{
                print(response?["error"] as Any)
                
            }
        }
    }
    
    func removeData() {
        firstTxt.text?.removeAll()
        secondTxt.text?.removeAll()
        thirdTxt.text?.removeAll()
        fourhtTxt.text?.removeAll()
        first1Txt.text?.removeAll()
        Second1Txt.text?.removeAll()
        Third1Txt.text?.removeAll()
        Fourth1Txt.text?.removeAll()
    }
    
}

//MARK: - UITextField Delegate

extension PasswordVc: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool  {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 1
//        return false
    }
}

//MARK: - Additional Functionality

extension PasswordVc {
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case firstTxt:
                secondTxt.becomeFirstResponder()
            case secondTxt:
                thirdTxt.becomeFirstResponder()
            case thirdTxt:
                fourhtTxt.becomeFirstResponder()
            case fourhtTxt:
                fourhtTxt.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case fourhtTxt:
                thirdTxt.becomeFirstResponder()
            case thirdTxt:
                secondTxt.becomeFirstResponder()
            case secondTxt:
                firstTxt.becomeFirstResponder()
            case firstTxt:
                firstTxt.becomeFirstResponder()
            default:
                break
            }
        }
        else{
            
        }
    }
    
}
extension PasswordVc {

    @objc func textFieldDidChanged(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case first1Txt:
                Second1Txt.becomeFirstResponder()
            case Second1Txt:
                Third1Txt.becomeFirstResponder()
            case Third1Txt:
                Fourth1Txt.becomeFirstResponder()
            case Fourth1Txt:
                Fourth1Txt.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case Fourth1Txt:
                Third1Txt.becomeFirstResponder()
            case Third1Txt:
                Second1Txt.becomeFirstResponder()
            case Second1Txt:
                first1Txt.becomeFirstResponder()
            case first1Txt:
                first1Txt.becomeFirstResponder()
            default:
                break
            }
        }
        else{

        }
    }

}
