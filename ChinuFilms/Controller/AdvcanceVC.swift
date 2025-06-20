//
//  AdvcanceVC.swift
//  SanskarEP
//
//  Created by Warln on 17/01/22.
//

import UIKit

class AdvcanceVC: UIViewController {
    
    @IBOutlet weak var amounttft: UITextField!
    @IBOutlet weak var paybackTft: UITextField!
    @IBOutlet weak var resonTft: UITextView!
    @IBOutlet weak var headerLbl: UILabel!
    
    var titleTxt: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resonTft.delegate = self
    //    headerLbl.text = titleTxt
        resonTft.layer.cornerRadius = 10
        resonTft.layer.borderWidth = 1.0
        resonTft.layer.borderColor = UIColor.lightGray.cgColor
        resonTft.clipsToBounds = true
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
  //      self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
//        if let amount = amounttft.text, let payback = paybackTft.text , let reason = resonTft.text {
//            if (amount == "") && (payback == "") && (reason == "") {
//                AlertController.alert(message: "Please enter detail")
//            }else if (amount.isNumeric() == false) && (payback.isNumeric() == false){
//                AlertController.alert(message: "Please enter in digit")
//            }else{
//                requestAd(amount, payback, reason)
//            }
//        }
        guard let amount = amounttft.text, let payback = paybackTft.text, let reason = resonTft.text else {
               // At least one of the fields is empty
               AlertController.alert(message: "Please enter all details")
               return
           }

           if amount.isEmpty || payback.isEmpty || reason.isEmpty {
               // At least one of the fields is empty
               AlertController.alert(message: "Please enter all details")
               return
           }

           if (amount.isNumeric() == false) || (payback.isNumeric() == false) {
               // Amount or payback is not numeric
               AlertController.alert(message: "Please enter valid numeric values for amount and payback")
               return
           }

           // If all checks pass, proceed with the request
           requestAd(amount, payback, reason)
    }
    
    func requestAd(_ amount: String, _ payback: String, _ reason: String){
        var dict = Dictionary<String,Any>()
        dict["RepaymentDuration"] = payback
        dict["RequestedAmount"] = amount
        dict["Reason"] = reason
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kAdvance) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                self.removeData()
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }else{
                print(response?["error"] as Any)
            }
        }
    }
    
    func removeData() {
        amounttft.text?.removeAll()
        paybackTft.text?.removeAll()
        resonTft.text.removeAll()
    }
    


}

extension AdvcanceVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (resonTft.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
}
