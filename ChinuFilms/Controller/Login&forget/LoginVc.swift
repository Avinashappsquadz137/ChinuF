//
//  ViewController.swift
//  SanskarEP
//
//  Created by Warln on 10/01/22.
//

import UIKit

class LoginVc: UIViewController {
    //mark:- Mobile number and Label
    @IBOutlet weak var openLbl: UILabel!
    @IBOutlet weak var mobileTxtF: UITextField!
    //mark:- Password
    @IBOutlet weak var passText1: UITextField!
    @IBOutlet weak var passText2: UITextField!
    @IBOutlet weak var passText3: UITextField!
    @IBOutlet weak var passText4: UITextField!
    //mark:- Button
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var Registerbtn: UIButton!
    
    //Mark: Variable
    var password: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI()
        navigationController?.isNavigationBarHidden = true
        Registerbtn.isHidden = true
    }
    
    //MARK: - Update UI
    
    func updateUI () {
        loginBtn.layer.cornerRadius = 20
        loginBtn.clipsToBounds = true
        Registerbtn.layer.cornerRadius = 20
        Registerbtn.clipsToBounds = true
        
        //Mark:- multi color text
        let stringValue = "Employee Portal"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: "Portal", withColor: UIColor.red)
        openLbl.attributedText = attributedString
        passText1.delegate = self
        passText2.delegate = self
        passText3.delegate = self
        passText4.delegate = self
        //Mark:- Add Target Password TextField
        passText1.addTarget(self, action:  #selector (textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        passText2.addTarget(self, action:  #selector (textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        passText3.addTarget(self, action:  #selector (textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        passText4.addTarget(self, action:  #selector (textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    //MARK: - IBAction
    
    @IBAction func forgetPassBtnPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: idenity.forget, sender: self)
        
    }
    
    
    @IBAction func registerbtn(_ sender: UIButton) {
        let Employee = storyboard?.instantiateViewController(withIdentifier: "AddNewEmployeeVc") as! AddNewEmployeeVc
      present(Employee, animated: true)
    }
    
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
            password = "\(passText1.text!)\(passText2.text!)\(passText3.text!)\(passText4.text!)"
            guard let mobileNumber = mobileTxtF.text, !mobileNumber.isEmpty else {
                AlertController.alert(message: "Please enter Mobile number.")
                return
            }
            
            if mobileNumber.count < 10 || !mobileNumber.isNumeric() {
                AlertController.alert(message: "Please enter a valid 10-digit Mobile number.")
                return
            }
           if mobileNumber.count > 10 {
                AlertController.alert(message: "Mobile number should not be greater than 10 digits.")
                return
            }
            if password?.isNumeric() == false {
                AlertController.alert(message: "Please enter numeric values for the Password.")
                return
            }
            if password!.count < 4 {
                AlertController.alert(message: "Password must be at least 4 digits.")
                return
            }
            loginApi()
        
    }
    
    //MARK: - Login Api
    
    func loginApi() {
        idenity.kDeviceToken = UserDefaults.standard.value(forKey: "token") as? String ?? "123456"
        var dict = Dictionary<String,Any>()
        dict["CntNo"] = mobileTxtF.text!
        dict["pin"] = password!
        dict["Device-Id"] = currentUser.DeviceId
        dict["User-Type"] = currentUser.device_type
        dict["Device-Model"] = currentUser.deviceModel
        dict["device_token"] = idenity.kDeviceToken
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: getLogin) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data, (response?["status"] as? Bool) == true, response != nil {
                currentUser.saveData(Login_Data: response ?? [:])
          //  AlertController.alert(message: (response?.validatedValue("message"))!)
                if #available(iOS 13.0, *) {
                    SceneDelegate.shared?.AppFlow()
                }else{
                    AppDelegate.shared?.AppFlow()
                }

            }else{
                print(response?["error"]  as Any)
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
        }
    }

    }
    


extension LoginVc: UITextFieldDelegate {
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if text?.utf16.count == 1 {
            switch textField{
            case passText1:
                passText2.becomeFirstResponder()
            case passText2:
                passText3.becomeFirstResponder()
            case passText3:
                passText4.becomeFirstResponder()
            case passText4:
                passText4.resignFirstResponder()
            default:
                break
            }
        }else if text?.utf16.count == 0 {
            switch textField{
            case passText4:
                passText3.becomeFirstResponder()
            case passText3:
                passText2.becomeFirstResponder()
            case passText2:
                passText1.becomeFirstResponder()
            case passText1: break
            // forthTF.resignFirstResponder()
            default:
                break
            }
        }
    }

    
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




