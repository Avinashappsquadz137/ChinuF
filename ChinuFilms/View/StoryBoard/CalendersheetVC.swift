//
//  CalendersheetVC.swift
//  SanskarEP
//
//  Created by Surya on 14/07/24.
//

import UIKit

class CalendersheetVC: UIViewController {
    
    
    @IBOutlet weak var LeaveDetailView: UIView!
    @IBOutlet weak var FulldayView: UIView!
    @IBOutlet weak var multiselectview: UIView!
    @IBOutlet weak var reasonview: NSLayoutConstraint!
    @IBOutlet weak var fulldaybtn: UIButton!
    @IBOutlet weak var WFHVIew: UIView!
    @IBOutlet weak var reasonforwfh: NSLayoutConstraint!
    @IBOutlet weak var wfhmview: UIView!
    @IBOutlet weak var imageselect: UIImageView!
    @IBOutlet weak var WFHFromDate: UITextField!
    @IBOutlet weak var WFHTODate: UITextField!
    @IBOutlet weak var ReasonWFH: UITextView!
    @IBOutlet weak var wfhbtnS: UIButton!
    @IBOutlet weak var workfromview: UIView!
    @IBOutlet weak var wfhbuttonb: UIButton!
    
    
    @IBOutlet weak var Halfdaycircleview: UIView!
    @IBOutlet weak var OffCircleview: UIView!
    @IBOutlet weak var wfhcircleview: UIView!
    @IBOutlet weak var halfdaybtn: UIButton!
    @IBOutlet weak var offdaybtn: UIButton!
    
    @IBOutlet weak var fullhalfview: UIView!
    
    
    
    var titleTxt: String?
    var fromDate: String?
    var toDate: String?
    var dayType: String?
    var leaveType: String?
    var wfh:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
                FulldayView.circleWithBorder()
                Halfdaycircleview.circleWithBorder()
                OffCircleview.circleWithBorder()
                wfhcircleview.circleWithBorder()
     
       
        
        self.LeaveDetailView.isHidden = false
        reset()

      
        multiselectview.isHidden = false
        fullhalfview.isHidden = true

        wfhmview.isHidden = true
        imageselect.isHidden = true
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func reset() {
   
      //  FulldayView.circleWithBorder()

        ReasonWFH.text = "Reason...."
        ReasonWFH.textColor = .black
        ReasonWFH.layer.cornerRadius = 10
        ReasonWFH.clipsToBounds = true
        ReasonWFH.layer.borderWidth = 1.0
        ReasonWFH.layer.borderColor = UIColor.black.cgColor
 
//        FulldayView.backgroundColor = .blue
//        leaveType = "full"
//        dayType = "full"
//
//        
    }
    
    
    
    @IBAction func WFHButton(_ sender: UIButton) {
       
        self.imageselect.isHidden = true
       
    }
    

    @IBAction func Offdaybtn(_ sender: UIButton) {
        fullhalfview.isHidden = true

        self.wfhmview.isHidden = !self.wfhmview.isHidden
        self.imageselect.isHidden = !self.imageselect.isHidden

        if self.wfhmview.isHidden {
            self.reasonforwfh.constant = 10
        } else {
            let safeAreaInsetsTop = view.safeAreaInsets.top
            self.reasonforwfh.constant = safeAreaInsetsTop + 70
            
        }
    }
    
    @IBAction func fulldaybtn(_ sender: UIButton) {
        fullhalfview.isHidden = true
       
      
        self.wfhmview.isHidden = !self.wfhmview.isHidden
        self.imageselect.isHidden = !self.imageselect.isHidden

        if self.wfhmview.isHidden {
            self.reasonforwfh.constant = 10
        } else {
            let safeAreaInsetsTop = view.safeAreaInsets.top
            self.reasonforwfh.constant = safeAreaInsetsTop + 70
            
        }
       
    }
    
    @IBAction func halfdaybtn(_ sender: UIButton) {
     
//        WFHVIew.isHidden = true
//
//        multiselectview.isHidden = true
//        self.fulldayformview.isHidden = false
//        if self.multiselectview.isHidden {
//            self.reasonview.constant = 8
//        } else {
//            let safeAreaInsetsTop = view.safeAreaInsets.top
//            self.reasonview.constant = safeAreaInsetsTop + 70
//        }
        self.wfhmview.isHidden = !self.wfhmview.isHidden
        fullhalfview.isHidden = false
        wfhmview.isHidden = true
    }
    
    
    @IBAction func wfhSelectd(_ sender: UIButton) {
        fullhalfview.isHidden = true

        
        self.wfhmview.isHidden = !self.wfhmview.isHidden
        self.imageselect.isHidden = !self.imageselect.isHidden

        if self.wfhmview.isHidden {
            self.reasonforwfh.constant = 10
        } else {
            let safeAreaInsetsTop = view.safeAreaInsets.top
            self.reasonforwfh.constant = safeAreaInsetsTop + 70
            
        }
    }
    
    
    @IBAction func selectchbutton(_ sender: UIButton) {
        switch sender {
        case fulldaybtn:
            if FulldayView.backgroundColor == .blue {
                FulldayView.backgroundColor = .clear
               
            } else {
                clearAllChannelSelection()
                FulldayView.backgroundColor = .blue
                
            }
        case halfdaybtn:
            if Halfdaycircleview.backgroundColor == .blue {
                Halfdaycircleview.backgroundColor = .clear
            } else {
                clearAllChannelSelection()
                Halfdaycircleview.backgroundColor = .blue
                
            }
        case offdaybtn:
            if OffCircleview.backgroundColor == .blue {
                OffCircleview.backgroundColor = .clear
                
            } else {
                clearAllChannelSelection()
                OffCircleview.backgroundColor = .blue
                
            }
        case wfhbuttonb:
            if wfhcircleview.backgroundColor == .blue {
                wfhcircleview.backgroundColor = .clear
                
            } else {
                clearAllChannelSelection()
                wfhcircleview.backgroundColor = .blue
                
            }
        default:
            break
        }
    }
    
    func clearAllChannelSelection() {
      
        FulldayView.backgroundColor = .clear
        Halfdaycircleview.backgroundColor = .clear
        OffCircleview.backgroundColor = .clear
        wfhcircleview.backgroundColor = .clear

    }
    
//    @IBAction func daysbtnselect(_ sender: UIButton) {
//        switch sender {
//        case halfdaybtn:
//            if Halfdayview.backgroundColor == .blue {
//                Halfdayview.backgroundColor = .clear
//        
//                leaveType = "half"
//                dayType = "half"
//            } else {
//                clearAllChannelSelection()
//                Halfdayview.backgroundColor = .blue
//           
//                leaveType = "half"
//                dayType = "half"
//            }
//        case fulldaybtn:
//            if FulldayView.backgroundColor == .blue {
//                FulldayView.backgroundColor = .clear
//             
//                leaveType = "full"
//                dayType = "full"
//            } else {
//                clearAllChannelSelection()
//                FulldayView.backgroundColor = .blue
//             
//                leaveType = "full"
//                dayType = "full"
//            }
//        case wfhbuttonb:
//            if workfromview.backgroundColor == .blue {
//                workfromview.backgroundColor = .clear
//          
//          //      leaveType = "full"
//        //        dayType = "full"
//            } else {
//                clearAllChannelSelection()
//                workfromview.backgroundColor = .blue
//            
//       //         leaveType = "full"
//      //          dayType = "full"
//            }
//        default:
//            break
//        }
//        
//        
//    }
//    
//    @IBAction func dateclick(_ sender: UIButton) {
//        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
//            self.fromdate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
//        }
//    }
//    
//    
//    @IBAction func Enddateclick(_ sender: UIButton) {
//        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
//            self.todate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
//        }
//    }
    
//    @IBAction func TTodate(_ sender: UIButton) {
//        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
//            self.toDate = Utils.dateString(date: date, format: "yyyy-MM-dd")
//            self.TTodate.text! = self.toDate!
//        }
//    }
//    
//    @IBAction func TFromDate(_ sender: UIButton) {
//        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
//            self.fromDate = Utils.dateString(date: date, format: "yyyy-MM-dd")
//            self.TFromDate.text! = self.fromDate!
//        }
//    }
//    
//    @IBAction func WFHToDate(_ sender: UIButton) {
//        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
//            self.WFHFromDate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
//        }
//    }
//    
//    @IBAction func WFHFrom(_ sender: UIButton) {
//        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
//            self.WFHTODate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
//        }
    }
    
    
  
    
  
    
    

    
    
   
    
//    func wfHAPi(){
//        var dict = Dictionary<String,Any>()
//        dict["from_date"] = WFHFromDate.text!
//        dict["to_date"] = WFHTODate.text!
//        dict["reason"] = ReasonWFH.text
//        dict["EmpCode"] = currentUser.EmpCode
//        DispatchQueue.main.async(execute: {Loader.showLoader()})
//        APIManager.apiCall(postData: dict as NSDictionary, url: kWfhome) { result, response, error, data in
//            DispatchQueue.main.async(execute: {Loader.hideLoader()})
//            if let _ = data,(response?["status"] as? Bool == true), response != nil {
//                self.removeData()
//                AlertController.alert(message: (response?.validatedValue("message"))!)
//            }else{
//                print(response?["error"] as Any)
//                AlertController.alert(message: (response?.validatedValue("message"))!)
//            }
//        }
        
 //   }
    
//    func WFHremoveData() {
//        WFHFromDate.text?.removeAll()
//        WFHTODate.text?.removeAll()
//        ReasonWFH.text?.removeAll()
//    }
//    
//    func requestLeave() {
//        var dict = Dictionary<String,Any>()
//        dict["leave_type"] = leaveType
//        dict["from_date"] = fromdate.text!
//        dict["to_date"] = todate.text!
//        dict["day_type"] = dayType
//        dict["leave_res"] = remarkTxtView.text
//        dict["EmpCode"] = currentUser.EmpCode
//        DispatchQueue.main.async(execute: {Loader.showLoader()})
//        APIManager.apiCall(postData: dict as NSDictionary, url: kLeaveApi) { result, response, error, data in
//            DispatchQueue.main.async(execute: {Loader.hideLoader()})
//            if let _ = data,(response?["status"] as? Bool == true), response != nil {
//                self.removeAll()
//                AlertController.alert(message: (response?.validatedValue("message"))!)
//               
//            }else{
//                print(response?["error"] as Any)
//                AlertController.alert(message: (response?.validatedValue("message"))!)
//            }
//        }
//    }
    
//    func removeAll() {
//        
//        toDate?.removeAll()
//        fromDate?.removeAll()
//        dayType?.removeAll()
//        leaveType?.removeAll()
//        remarkTxtView.text.removeAll()
////        hDayView.backgroundColor = .white
////        fDayView.backgroundColor = .white
////        hHalfView.backgroundColor = .white
////        fHalfView.backgroundColor = .white
////        firstView.isHidden = true
//    }
    
//    @IBAction func wfhsendbtn(_ sender: UIButton) {
////            requestLeave()
////           removeAll()
//        
//        }
//    
//    @IBAction func WFHSUbmitBtn(_ sender: UIButton) {
////        wfHAPi()
////        WFHremoveData()
//    }
    
    
//    @IBAction func newbookingbtn(_ sender: UIButton) {
//        
//        let vc = storyboard!.instantiateViewController(withIdentifier: "BookingKathaVc") as! BookingKathaVc
//        
//        if #available(iOS 15.0, *) {
//        if let sheet = vc.sheetPresentationController {
//        var customDetent: UISheetPresentationController.Detent?
//            if #available(iOS 16.0, *) {
//            customDetent = UISheetPresentationController.Detent.custom { context in
//                return 600
//                
//            }
//            sheet.detents = [customDetent!]
//            sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
//                }
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//            sheet.prefersGrabberVisible = true
//            sheet.preferredCornerRadius = 12
//                            }
//                        }
//                        self.present(vc, animated: true)
//        
//                
////        let vc = storyboard?.instantiateViewController(withIdentifier: "BookingKathaVc") as! BookingKathaVc
////        self.present(vc, animated: true, completion: nil)
//        
//    }
    
    
//    @IBAction func yourbookinglist(_ sender: UIButton) {
//        
//        
//    }
//    @IBAction func firstsecondbtn(_ sender: UIButton) {
//            switch sender {
//            case firsthalfbtn:
//                if firstcircleview.backgroundColor == .blue {
//                    firstcircleview.backgroundColor = .clear
//                    Halfdayview.backgroundColor = .clear
//                    LeaveCircleView.backgroundColor = .clear
//                    dayType = "first half"
//                } else {
//                    clearAllChannelSelection()
//                    firstcircleview.backgroundColor = .blue
//                    Halfdayview.backgroundColor = .blue
//                    LeaveCircleView.backgroundColor = .blue
//                    dayType = "first half"
//                }
//            case secondhalfBtn:
//                if secondcircleview.backgroundColor == .blue {
//                    secondcircleview.backgroundColor = .clear
//                    Halfdayview.backgroundColor = .clear
//                    LeaveCircleView.backgroundColor = .clear
//                    dayType = "second half"
//        
//                } else {
//                    clearAllChannelSelection()
//                    secondcircleview.backgroundColor = .blue
//                    Halfdayview.backgroundColor = .blue
//                    LeaveCircleView.backgroundColor = .blue
//                    dayType = "second half"
//                }
//        
//            default:
//                break
//            }
//    }
    

//}

extension CalendersheetVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == ReasonWFH  {
            if textView.textColor == UIColor.black {
                textView.text = ""
           //     textView.text = (textView == ReasonWFH) ? "Reason For WFH..." : "Reason..."
                textView.textColor = UIColor.black
            }
        }
    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView == remarkTxtView || textView == ReasonText || textView == ReasonWFH {
//            if textView.text == "" {
//                textView.text = (textView == remarkTxtView) ? "Reason For Leave..." : "Reason..."
//                textView.textColor = UIColor.black
//            }
//            else if textView.text == "" {
//                textView.text = (textView == ReasonText) ? "Reason For Tour..." : "Reason..."
//                textView.textColor = UIColor.black
//            }
//            else if textView.text == "" {
//                textView.text = (textView == ReasonWFH) ? "Reason For WFH..." : "Reason..."
//                textView.textColor = UIColor.black
//            }
//        }
//    }
}


    


