//
//  PaySlipVc.swift
//  SanskarEP
//
//  Created by Warln on 18/01/22.
//

import UIKit

class PaySlipVc: UIViewController {
    
    @IBOutlet weak var fromTxt: UITextField!
    @IBOutlet weak var toTxt: UITextField!
    @IBOutlet weak var reasnT: UITextView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    
    var toMnth: String?
    var toYear: String?
    var fromMnth: String?
    var fromYear: String?
    var titleTxt: String?
    var wkhome:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
//        if #available(iOS 15.0, *) {
//            sheetPresentationController?.prefersGrabberVisible = true
//        } else {
//            // Fallback on earlier versions
//        }
//        if #available(iOS 15.0, *) {
//            sheetPresentationController?.detents = [.()]
//        } else {
//            // Fallback on earlier versions
//        }

        
    }
    
    //MARK: - setip functionality
    
    func setup(){
        
        reasnT.layer.cornerRadius = 10
        reasnT.layer.borderWidth = 1.0
        reasnT.layer.borderColor = UIColor.lightGray.cgColor
        reasnT.clipsToBounds = true
        
   //     headerLbl.text = titleTxt
        
        if wkhome == true {
            fromLbl.text = "Period From"
            toLbl.text = "Period To"
        }else{
            fromLbl.text = "From Month"
            toLbl.text = "To Month"
        }
        
    }
    
    //MARK: - IBACtion Button Pressed
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dateBtnPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 30:
            if wkhome !=  true{
                IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
                    var to = ""
                    to = Utils.dateString(date: date, format: "MMM, yyyy")
                    self.fromTxt.text = to
                    self.fromMnth = to.subString(from: 0, to: 3)
                    self.fromYear = to.subString(from: 5, to: 9)
                    
                }
            }else{
                IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
                    self.fromTxt.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
                }
            }
            
        case 31:
            if wkhome != true {
                IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
                    var to = ""
                    to = Utils.dateString(date: date, format: "MMM, yyyy")
                    self.toTxt.text = to
                    self.toMnth = to.subString(from: 0, to: 3)
                    self.toYear = to.subString(from: 5, to: 9)
                    
                }
            }else{
                IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
                    self.toTxt.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
                }
            }
            
        default:
            break
        }
        
    }
    
    @IBAction func requestBtnPressed(_ sender: UIButton) {
        
//        if toTxt.text! == "" && fromTxt.text! == "" && reasnT.text == ""{
        if toTxt.text!.isEmpty || fromTxt.text!.isEmpty || reasnT.text.isEmpty {
            AlertController.alert(message: "Please select the required field")
        }else{
            if wkhome == true {
                wfHAPi()
            }else{
                payslip()
                removeData()
            }
        }
        
    }
    
    //MARK: - Work from Home Request
    
    func wfHAPi(){
        var dict = Dictionary<String,Any>()
        dict["from_date"] = fromTxt.text!
        dict["to_date"] = toTxt.text!
        dict["reason"] = reasnT.text
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kWfhome) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                self.removeData()
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }else{
                print(response?["error"] as Any)
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
        }
        
    }
    
    //MARK: - Payslip request

    func payslip() {
        var dict = Dictionary<String,Any>()
        dict["EmpRemarks"] = reasnT.text
        dict["MonthFrom"] = fromMnth
        dict["frm_year"] = fromYear
        dict["MonthTo"] = toMnth
        dict["to_year"] = toYear
        dict["EmpCode"] = currentUser.EmpCode
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kPayslip) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let responseData = response {
                if let status = responseData["status"] as? Bool {
                    let message = responseData["message"] as? String ?? ""
                    if status {
                        // Status is true
                        print("API Response Message:", message)
                    } else {
                        // Status is false
                        print("API Response Error:", message)
                    }
                    AlertController.alert(message: message)
                } else {
                    // Status key is missing in response
                    print("Invalid response format")
                }
            } else {
                // Response is nil
                print("No response from server")
            }
        }
    }



    
    func removeData() {
        toTxt.text?.removeAll()
        fromYear?.removeAll()
        toMnth?.removeAll()
        fromMnth?.removeAll()
        reasnT.text.removeAll()
        fromTxt.text?.removeAll()
    }
    
}
