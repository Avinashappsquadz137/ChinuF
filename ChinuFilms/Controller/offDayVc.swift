//
//  offDayVc.swift
//  SanskarEP
//
//  Created by Warln on 14/01/22.
//

import UIKit

class offDayVc: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var headerLbl: UILabel!
    
    var ttitleTxt: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        headerLbl.text = ttitleTxt
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
    
    //MARK: -  Steup functionality
    
    func setup() {
        reasonTextView.layer.borderWidth = 1.0
        reasonTextView.layer.borderColor = UIColor.lightGray.cgColor
        reasonTextView.layer.cornerRadius = 10
        reasonTextView.clipsToBounds = true
        reasonTextView.text = "Reason For Leave..."
        reasonTextView.textColor = .lightGray
        reasonTextView.delegate = self
        
    }
    
    //MARK: - IBAction Button Pressed
    
    @IBAction func dateBtnPressed(_ sender: UIButton) {
        
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.dateTextField.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil) 
        switch sender.tag {
        case 20:
            navigationController?.popViewController(animated: true)
        case 21:
            self.performSegue(withIdentifier: idenity.offToSee , sender: self)
        default:
            break
        }
        
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        
//        if dateTextField.text! == "" {
//            AlertController.alert(message: "Please Enter the Date")
//        }else if reasonTextView.text == ""  {
//            AlertController.alert(message: "Please Enter the Reason")
//        }else {
//            hitApi()
//        }
        guard let selectedDate = dateTextField.text, !selectedDate.isEmpty else {
                AlertController.alert(message: "Please Enter the Date")
                return
            }
            guard reasonTextView.text != "Reason For Leave..." && !reasonTextView.text.isEmpty else {
                AlertController.alert(message: "Please Enter the Reason")
                return
            }
            hitApi()
    }

}

//MARK: -  Hit API

extension offDayVc {
    
    func hitApi() {
        var dict = Dictionary<String,Any>()
        dict["Date1"] = dateTextField.text!
        dict["Requirement"] = reasonTextView.text
        dict["EmpCode"] = currentUser.EmpCode
    
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kDayOff) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                self.removeData()
            }else{
                AlertController.alert(message: (response?.validatedValue("message"))!)
                print(response?["error"] as Any)
            }
        }
    }
    
    func removeData() {
        reasonTextView.text.removeAll()
        dateTextField.text?.removeAll()
    }
}

//MARK: - UITextView Delegate

extension offDayVc : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (reasonTextView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if reasonTextView.textColor == UIColor.lightGray {
            reasonTextView.text = ""
            reasonTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if reasonTextView.text == "" {

            reasonTextView.text = "Reason For Leave..."
            reasonTextView.textColor = UIColor.lightGray
        }
    }
}
