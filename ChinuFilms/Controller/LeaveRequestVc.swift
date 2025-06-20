//
//  LeaveRequestVc.swift
//  SanskarEP
//
//  Created by Warln on 13/01/22.
//

import UIKit

class LeaveRequestVc: UIViewController {
    
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var fDayView: UIView!
    @IBOutlet weak var fHalfView: UIView!
    @IBOutlet weak var hDayView: UIView!
    @IBOutlet weak var hHalfView: UIView!
    @IBOutlet weak var fDayTxtField: UITextField!
    @IBOutlet weak var tDayTxtField: UITextField!
    @IBOutlet weak var remarkTxtView: UITextView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondeView: UIView!
    @IBOutlet weak var toTheView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    
    //Mark:- Variable
    var fromDate: String?
    var toDate: String?
    var headerTxt: String?
    var leaveType: String?
    var dayType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        remarkTxtView.delegate = self
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
           fDayView.backgroundColor = .lightGray
           hDayView.backgroundColor = .white
           firstView.isHidden = true
           toTheView.isHidden = false
           leaveType = "full"
           dayType = "full"

    }
    
    //MARK: - Update UI
    
    func setup() {
        
        let now = Date()
        currentDate.text = "Date Of Application: \(now.dateToString())"
        titleLbl.text = headerTxt
        fDayView.circleWithBorder()
        hDayView.circleWithBorder()
        firstView.isHidden = true
        fHalfView.circleWithBorder()
        hHalfView.circleWithBorder()
        
        remarkTxtView.text = "Reason For Leave..."
        remarkTxtView.textColor = .lightGray
        remarkTxtView.layer.cornerRadius = 10
        remarkTxtView.clipsToBounds = true
        remarkTxtView.layer.borderWidth = 1.0
        remarkTxtView.layer.borderColor = UIColor.lightGray.cgColor
        
        submitBtn.layer.cornerRadius = 10
        submitBtn.clipsToBounds = true
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        switch sender.tag {
        case 9:
            self.navigationController?.popViewController(animated: true)
        case 10:
            self.performSegue(withIdentifier: idenity.leaveToSee, sender: self)
        default:
            break
        }
        
    }
    
    @IBAction func daySelectBtnPressed(_ sender: UIButton) {
        switch sender.tag {
           case 11:
               fDayView.backgroundColor = .lightGray
               hDayView.backgroundColor = .white
               firstView.isHidden = true
               toTheView.isHidden = false
               leaveType = "full"
               dayType = "full"
           case 12:
               fDayView.backgroundColor = .white
               hDayView.backgroundColor = .lightGray
               toTheView.isHidden = true
               firstView.isHidden = false
               leaveType = "half"
           case 13:
               IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
                   self.fromDate = Utils.dateString(date: date, format: "yyyy-MM-dd")
                   self.fDayTxtField.text! = self.fromDate!
               }
           case 14:
               fHalfView.backgroundColor = .lightGray
               hHalfView.backgroundColor = .white
               dayType = "first half"
           case 15:
               fHalfView.backgroundColor = .white
               hHalfView.backgroundColor = .lightGray
               dayType = "second half"
           case 16:
               IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
                   self.toDate = Utils.dateString(date: date, format: "yyyy-MM-dd")
                   self.tDayTxtField.text! = self.toDate!
               }
           default:
               break
           }
    }
    
    func isFormValid() -> Bool {
        if leaveType == "full" {
            // Check for full day leave validation
            guard let fromDate = fromDate, !fromDate.isEmpty,
                  let toDate = toDate, !toDate.isEmpty,
                  let leaveRes = remarkTxtView.text, !leaveRes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return false
            }
        } else if leaveType == "half" {
            // Check for half day leave validation
            guard let fromDate = fromDate, !fromDate.isEmpty,
                  let dayType = dayType, !dayType.isEmpty,
                  let leaveRes = remarkTxtView.text, !leaveRes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return false
            }
        }
        return true
    }
    @IBAction func submitBtnPressed(_ sender: UIButton) {
//     //   remarkTxtView.endEditing(true)
//     //   requestLeave()
//    //    self.dismiss(animated: true, completion: nil)
//        remarkTxtView.endEditing(true)
//            if isFormValid() {
//                requestLeave()
//                // self.dismiss(animated: true, completion: nil)
//            } else {
//                // Display an alert because some fields are empty
//                AlertController.alert(message: "Please fill in all the fields.")
//            }
        remarkTxtView.endEditing(true)
           if isFormValid() {
               requestLeave()
           } else {
               // Display an alert because some fields are empty
               AlertController.alert(message: "Please fill in all required fields.")
           }
     }
    }
    



//MARK: - Extra funcationality

extension LeaveRequestVc {
    func requestLeave() {
        var dict = Dictionary<String,Any>()
        dict["leave_type"] = leaveType
        dict["from_date"] = fromDate
        dict["to_date"] = toDate
        dict["to_date"] = dayType
        dict["leave_res"] = remarkTxtView.text
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kLeaveApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                self.removeAll()
                AlertController.alert(message: (response?.validatedValue("message"))!)
               
            }else{
                print(response?["error"] as Any)
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
        }
    }
    
    func removeAll() {
        
        fDayTxtField.text?.removeAll()
        tDayTxtField.text?.removeAll()
        toDate?.removeAll()
        fromDate?.removeAll()
        dayType?.removeAll()
        leaveType?.removeAll()
        remarkTxtView.text.removeAll()
        hDayView.backgroundColor = .white
        fDayView.backgroundColor = .white
        hHalfView.backgroundColor = .white
        fHalfView.backgroundColor = .white
        firstView.isHidden = true
    }
}

//MARK: -  UITextView Extension

extension LeaveRequestVc: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (remarkTxtView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if remarkTxtView.textColor == UIColor.lightGray {
            remarkTxtView.text = ""
            remarkTxtView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if remarkTxtView.text == "" {

            remarkTxtView.text = "Reason For Leave..."
            remarkTxtView.textColor = UIColor.lightGray
        }
    }
}
