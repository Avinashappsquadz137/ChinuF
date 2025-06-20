//
//  NewAllLeaveReqVc.swift
//  SanskarEP
//
//  Created by Surya on 23/08/24.
//

import UIKit

class NewAllLeaveReqVc: UIViewController {
    

    @IBOutlet weak var fullimageview: UIImageView!
    @IBOutlet weak var halfimageview: UIImageView!
    @IBOutlet weak var offimageview: UIImageView!
    @IBOutlet weak var wfhimageview: UIImageView!
    @IBOutlet weak var WFHMainView: UIView!
    @IBOutlet weak var multiselectview: UIView!
    @IBOutlet weak var multibutton: UIButton!
    @IBOutlet weak var multiimageview: UIImageView!    
    @IBOutlet weak var reasonwfh: NSLayoutConstraint!
    @IBOutlet weak var halfdayview: UIView!
    @IBOutlet weak var firstimageview: UIImageView!
    @IBOutlet weak var secondimageview: UIImageView!
    @IBOutlet weak var offdayview: UIView!
    @IBOutlet weak var halfdayformview: UIView!
    @IBOutlet weak var ReasonWFH: UITextView!
    @IBOutlet weak var remarforhalf: UITextView!
    @IBOutlet weak var ReasonOff: UITextView!
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    @IBOutlet weak var enddate: UITextField!
    @IBOutlet weak var halfdate: UITextField!
    @IBOutlet weak var wfhbtn: UIButton!
    @IBOutlet weak var offsendbtn: UIButton!
    @IBOutlet weak var halfsendbtn: UIButton!
    
    
    var wkhome:Bool = false
    var leaveType: String?
    var dayType: String?
    
    var fromDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        WFHMainView.isHidden = true
        multiselectview.isHidden = true
        halfdayview.isHidden = true
        offdayview.isHidden = true
        halfdayformview.isHidden = true
        
        reset()
        fullbtn(UIButton())
    }
    
    func resettext(){
        
        fromdate.text?.removeAll()
        enddate.text?.removeAll()
        todate.text?.removeAll()
        ReasonWFH.text?.removeAll()
        halfdate.text?.removeAll()
        ReasonOff.text?.removeAll()
        remarforhalf.text?.removeAll()
    }

    func reset() {
        
        halfdate.layer.cornerRadius = 10
        halfdate.clipsToBounds = true
        halfdate.layer.borderWidth = 1.0
        halfdate.layer.borderColor = UIColor.darkGray.cgColor
        
        enddate.layer.cornerRadius = 10
        enddate.clipsToBounds = true
        enddate.layer.borderWidth = 1.0
        enddate.layer.borderColor = UIColor.darkGray.cgColor
        
        fromdate.layer.cornerRadius = 10
        fromdate.clipsToBounds = true
        fromdate.layer.borderWidth = 1.0
        fromdate.layer.borderColor = UIColor.darkGray.cgColor
        
        todate.layer.cornerRadius = 10
        todate.clipsToBounds = true
        todate.layer.borderWidth = 1.0
        todate.layer.borderColor = UIColor.darkGray.cgColor
        
        WFHMainView.layer.cornerRadius = 10
        offdayview.layer.cornerRadius = 10
        halfdayformview.layer.cornerRadius = 10
        
        wfhbtn.layer.cornerRadius = 10
        offsendbtn.layer.cornerRadius = 10
        halfsendbtn.layer.cornerRadius = 10
        
  //      ReasonWFH.text = "Reason...."
        ReasonWFH.textColor = .black
        ReasonWFH.layer.cornerRadius = 10
        ReasonWFH.clipsToBounds = true
        ReasonWFH.layer.borderWidth = 1.0
        ReasonWFH.layer.borderColor = UIColor.darkGray.cgColor
        
        
   //     remarforhalf.text = "Reason...."
        remarforhalf.textColor = .black
        remarforhalf.layer.cornerRadius = 10
        remarforhalf.clipsToBounds = true
        remarforhalf.layer.borderWidth = 1.0
        remarforhalf.layer.borderColor = UIColor.darkGray.cgColor
        
   //     ReasonOff.text = "Reason...."
        ReasonOff.textColor = .black
        ReasonOff.layer.cornerRadius = 10
        ReasonOff.clipsToBounds = true
        ReasonOff.layer.borderWidth = 1.0
        ReasonOff.layer.borderColor = UIColor.darkGray.cgColor

    }
    
    
    @IBAction func fullbtn(_ sender: UIButton) {
        fullimageview.image = UIImage(named : "radioimage")
        halfimageview.image = UIImage(named : "radio")
        offimageview.image = UIImage(named : "radio")
        wfhimageview.image = UIImage(named : "radio")
        
        halfdayformview.isHidden = true
        offdayview.isHidden = true
        WFHMainView.isHidden = false
        leaveType = "full"
        dayType = "full"
        wkhome = false
        resettext()
    }
    
    @IBAction func halfbtn(_ sender: UIButton) {
      
        fullimageview.image = UIImage(named : "radio")
        halfimageview.image = UIImage(named : "radioimage")
        offimageview.image = UIImage(named : "radio")
        wfhimageview.image = UIImage(named : "radio")
        
        halfdayformview.isHidden = false
        WFHMainView.isHidden = true
        offdayview.isHidden = true
        halfdayview.isHidden = false
        leaveType = "half"
        
    }
    @IBAction func offbtn(_ sender: UIButton) {
     
        fullimageview.image = UIImage(named : "radio")
        halfimageview.image = UIImage(named : "radio")
        offimageview.image = UIImage(named : "radioimage")
        wfhimageview.image = UIImage(named : "radio")
        
        WFHMainView.isHidden = true
        halfdayformview.isHidden = true
        offdayview.isHidden = false
        
    }
    @IBAction func wfhbtn(_ sender: UIButton) {
    
        fullimageview.image = UIImage(named : "radio")
        halfimageview.image = UIImage(named : "radio")
        offimageview.image = UIImage(named : "radio")
        wfhimageview.image = UIImage(named : "radioimage")
        
        halfdayformview.isHidden = true
        offdayview.isHidden = true
        WFHMainView.isHidden = false
        wkhome = true
        resettext()
    }
    
    @IBAction func firstbtn(_ sender: UIButton) {
        firstimageview.image = UIImage(named : "radioimage")
        secondimageview.image = UIImage(named : "radio")
        dayType = "first half"
    }
    
    @IBAction func secondbtn(_ sender: UIButton) {
        secondimageview.image = UIImage(named : "radioimage")
        firstimageview.image = UIImage(named : "radio")
        dayType = "second half"
    }
    
    @IBAction func mutlibutton(_ sender: UIButton) {
        
        if multiimageview.image == UIImage(named: "check") {
                multiimageview.image = UIImage(named: "Uncheck")
            } else {
                multiimageview.image = UIImage(named: "check")
            }
        self.multiselectview.isHidden = !self.multiselectview.isHidden
        
        if self.multiselectview.isHidden {
            self.reasonwfh.constant = 10
        } else {
            let safeAreaInsetsTop = view.safeAreaInsets.top
            self.reasonwfh.constant = safeAreaInsetsTop + 75
            
        }
    }
    
    @IBAction func dateclick(_ sender: UIButton) {
        view.endEditing(true)
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
               self.fromDate = date
               self.fromdate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
           }
    }
    
    
    @IBAction func Enddateclick(_ sender: UIButton) {
        view.endEditing(true)
        guard let fromDateText = self.fromdate.text, !fromDateText.isEmpty else {
            AlertController.alert(message: "Please select From Date first.")
            return
        }
          guard let fromDate = self.fromDate else {
              IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
                  self.todate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
              }
              return
          }
          let datePicker = IosDatePicker()
          minimumData = fromDate
          isMinimumDate = true

          datePicker.showDate(animation: .zoomIn, pickerMode: .date) { date in
              self.todate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
          }
    }
    
    @IBAction func enddateclick(_ sender: UIButton) {
        view.endEditing(true)
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.enddate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    @IBAction func halfdate(_ sender: UIButton) {
        view.endEditing(true)
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.halfdate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    func offdayApi() {
        var dict = Dictionary<String,Any>()
        dict["from_date"] = enddate.text!
        dict["leave_res"] = ReasonOff.text
        dict["EmpCode"] = currentUser.EmpCode
    
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kDayOff) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                self.resettext()
            }else{
                AlertController.alert(message: (response?.validatedValue("message"))!)
                print(response?["error"] as Any)
            }
        }
    }
    
    @IBAction func submitbtn(_ sender: UIButton) {
        
        if fromdate.text!.isEmpty || ReasonWFH.text.isEmpty {
               AlertController.alert(message: "Please select the required field")
           } else {
               if wkhome == true {
                   wfHAPi()
                   resettext()
               } else {
                   fullrequest()
                   resettext()
               }
           }
    }
    
    func wfHAPi() {
        var dict = Dictionary<String,Any>()
        dict["from_date"] = fromdate.text!
        dict["to_date"] = todate.text!
        dict["leave_res"] = ReasonWFH.text
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kWfhome) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                self.resettext()
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }else{
                print(response?["error"] as Any)
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
        }
        
    }
    
    func fullrequest() {
        var dict = Dictionary<String,Any>()
        dict["leave_type"] = leaveType
        dict["from_date"] = fromdate.text!
        dict["to_date"] = todate.text!
        dict["day_type"] = dayType
        dict["leave_res"] = ReasonWFH.text!
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kLeaveApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                self.resettext()
                AlertController.alert(message: (response?.validatedValue("message"))!)
               
            }else{
                print(response?["error"] as Any)
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
        }
    }
    
    func Halfrequest() {
        var dict = Dictionary<String,Any>()
        dict["leave_type"] = leaveType
        dict["from_date"]  = halfdate.text!
        dict["to_date"]    = todate.text!
        dict["day_type"]   = dayType
        dict["leave_res"]  = remarforhalf.text!
        dict["EmpCode"]    = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kLeaveApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                self.resettext()
                AlertController.alert(message: (response?.validatedValue("message"))!)
               
            }else{
                print(response?["error"] as Any)
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
        }
    }
    @IBAction func offsubmitbtn(_ sender: UIButton) {
        guard let selectedDate = enddate.text, !selectedDate.isEmpty else {
                AlertController.alert(message: "Please Enter the Date")
                return
            }
            guard ReasonOff.text != "Reason For Leave..." && !ReasonOff.text.isEmpty else {
                AlertController.alert(message: "Please Enter the Reason")
                return
            }
        offdayApi()
        resettext()
        
    }
    
    @IBAction func halfsubmitbtn(_ sender: UIButton) {
        Halfrequest()
        resettext()
    }

}

extension NewAllLeaveReqVc: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
       
        if textView.textColor == UIColor.darkGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
      
        if textView.text.isEmpty {
            if textView == remarforhalf {
                textView.text = "Reason For Leave..."
            } else if textView == ReasonOff {
                textView.text = "Reason For Tour..."
            } else if textView == ReasonWFH {
                textView.text = "Reason For WFH..."
            }
            textView.textColor = UIColor.darkGray
        }
    }
}

