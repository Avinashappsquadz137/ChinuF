//
//  NewPasswordVc.swift
//  SanskarEP
//
//  Created by Surya on 30/01/24.
//

import UIKit

class NewPasswordVc: UIViewController {

    @IBOutlet weak var firstTxt: UITextField!
    @IBOutlet weak var SecondTxt: UITextField!
    @IBOutlet weak var ThirdTxt: UITextField!
    @IBOutlet weak var FourthTxt: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp() 
        
    }
    func fieldColor(_ txtField: UITextField) {
        txtField.layer.cornerRadius = 10
        txtField.layer.borderWidth = 2.0
        txtField.layer.borderColor = UIColor.orange.cgColor
        txtField.clipsToBounds = true
    }

    @IBAction func Submitbtn(_ sender: UIButton) {
        
    }
    func setUp() {
        
        firstTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        SecondTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        ThirdTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        FourthTxt.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        firstTxt.delegate = self
        SecondTxt.delegate = self
        ThirdTxt.delegate = self
        FourthTxt.delegate = self
        
        fieldColor(firstTxt)
        fieldColor(SecondTxt)
        fieldColor(ThirdTxt)
        fieldColor(FourthTxt)
   //     passHolder.isHidden = true
        
  //      let stringValue = "Didn't receive the code ?  Resend"
  //      let attributedString: NSMutableAttributedString = //NSMutableAttributedString(string: stringValue)
  //      attributedString.setColorForText(textForAttribute: //"Resend", withColor: UIColor.red)
  
        
    }
//    func createPass(with pass: String) {
//        var dict = Dictionary<String,Any>()
//        dict["EmpCode"] = otpData?["EmpCode"] as? String ?? ""
//        dict["CntNo"] = otpData?["CntNo"] as? String ?? ""
//        dict["pin"] = pass
//
//        DispatchQueue.main.async(execute: {Loader.showLoader()})
//        APIManager.apiCall(postData: dict as NSDictionary, url: kNewPin) { result, response, error, data in
//            DispatchQueue.main.async(execute: {Loader.hideLoader()})
//            if let _ = data, (response?["status"] as? Bool == true), response != nil {
//                AlertController.alert(message: (response?.validatedValue("message"))!)
//            //    self.passHolder.isHidden = true
//                guard let cb = self.completionBlock else {return}
//                self.dismiss(animated: true, completion: {
//                    self.removeData()
//                    cb()
//                })
//            }else{
//                print(response?["error"] as Any)
//
//            }
//        }
//    }
}
extension NewPasswordVc: UITextFieldDelegate  {
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case firstTxt:
                SecondTxt.becomeFirstResponder()
            case SecondTxt:
                ThirdTxt.becomeFirstResponder()
            case ThirdTxt:
                FourthTxt.becomeFirstResponder()
            case FourthTxt:
                FourthTxt.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
            switch textField{
            case FourthTxt:
                ThirdTxt.becomeFirstResponder()
            case ThirdTxt:
                SecondTxt.becomeFirstResponder()
            case SecondTxt:
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
    
//}
//extension NewPasswordVc: UITextFieldDelegate {
    
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

