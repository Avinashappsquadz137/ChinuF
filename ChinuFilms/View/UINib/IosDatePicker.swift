//
//  IosDatePicker.swift
//  SanskarEP
//
//  Created by Warln on 12/01/22.
//

import UIKit

enum AnimationType{
    case scale
    case rotate
    case bounceUp
    case zoomIn
}
enum ButtonsType:String{
    case positiveBtn = "OK"
    case ngativeBtn = "CANCEL"
}

var currentDate = Date()
var maxiMumDate = Date()
var minimumData = Date()
var isDisableFutureDate = false
var isMinimumDate = false


class IosDatePicker: UIViewController {
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var title_lbl: UILabel!
    
    var userAction:((_ callback: Date) -> Void)? = nil
    var animationType: AnimationType = .scale
    var pickerMode = UIDatePicker.Mode.date
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        self.view.alpha = 0
        datePicker.datePickerMode = pickerMode
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        if pickerMode == .date{
            title_lbl.text = "Select Date"
            
            
        }
        else if pickerMode == .dateAndTime{
            title_lbl.text = "Select Date and Time"
        }
        else if pickerMode == .time{
            title_lbl.text = "Select Time"
        }else{
            title_lbl.text = "Select count down timer"
        }
       datePicker.date = currentDate
        
        if isDisableFutureDate{
            datePicker.maximumDate = maxiMumDate
            isDisableFutureDate = false
        }
        if isMinimumDate{
            datePicker.minimumDate = minimumData
            isMinimumDate = false
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimating(type: self.animationType)
    }
    
    @IBAction func cancelAction(_ sender:UIButton){
        
        closeWithAnimation()
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func doneAction(_ sender:UIButton){
        
        currentDate = datePicker.date
        if userAction != nil{
            userAction!(datePicker.date)
        }
        
        closeWithAnimation()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func showDate(animation: AnimationType, pickerMode:UIDatePicker.Mode, action: ((_ value: Date) -> Void)? = nil) {
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        
        self.pickerMode = pickerMode
        self.animationType = animation
        userAction = action
        
        guard let viewController = Utils.topViewController()else{return}
        viewController.present(self, animated: true, completion: nil)
        
    }
    
    
    private func startAnimating(type: AnimationType) {
        switch type {
        case .rotate:
            datePickerView.transform = CGAffineTransform(rotationAngle: 1.5)
        case .bounceUp:
            let screenHeight = UIScreen.main.bounds.height/2 + datePickerView.frame.height/2
            datePickerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        case .zoomIn:
            datePickerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        default:
            datePickerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            print("use new animation ")
        }
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.view.alpha = 1
            self.datePickerView.transform = .identity
        }, completion: nil)
        
    }
    
    func closeWithAnimation(){
        datePicker.maximumDate = Date()
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.view.alpha = 0
            if self.animationType == .bounceUp{
                let screenHeight = (UIScreen.main.bounds.height/2 + self.datePickerView.frame.height/2)
                self.datePickerView.transform =  CGAffineTransform(translationX: 0, y: screenHeight)
            }else if self.animationType == .zoomIn{
                self.datePickerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }else{
                self.datePickerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
            
        }, completion: nil)
        
    }
  
}

class Utils {
    
    static func dateString(date:Date,format:String) -> String {
       let calendar = Calendar.current
       let dateComponents = calendar.component(.day, from: date)
       let numberFormatter = NumberFormatter()
       numberFormatter.numberStyle = .ordinal
       let day = numberFormatter.string(from: dateComponents as NSNumber)
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = format
       return  dateFormatter.string(from: date)
    }
    
    static func differentbetWeenDate(previousDate:Date,nowDate:Date) -> String{
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year,.month]
        formatter.maximumUnitCount = 2   // often, you don't care about seconds if the elapsed time is in months, so you'll set max unit to whatever is appropriate in your case

        let string = formatter.string(from: previousDate, to: nowDate)
        
        return string ?? ""
        
    }
    

    static func timeStampToString(str:String,format:String) -> String {
    
    if str == ""{
        return ""
    }
        let timestapm = TimeInterval(Double(str)!)
        let date = Date(timeIntervalSince1970: timestapm)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
        
    }
    
    
    static func timeStampToExpected(str:String,format:String) -> String {
    
    if str == ""{
        return ""
    }
        var date = Date()
        if str.count == 13{
            let timestapm = TimeInterval(Double(str)!/1000)
             date = Date(timeIntervalSince1970: timestapm)
        }else{
            let timestapm = TimeInterval(Double(str)!)
             date = Date(timeIntervalSince1970: timestapm)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
        
    }
    
    
    static func stringFromDate(date:Date,format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from: date)
        return dateStr
        
    }
    
    static func topViewController() -> UIViewController? {
        return topViewController(vc: UIApplication.shared.windows.last?.rootViewController)
    }
    
    private static func topViewController(vc:UIViewController?) -> UIViewController? {
        if let rootVC = vc {
            guard let presentedVC = rootVC.presentedViewController else {
                return rootVC
            }
            if let presentedNavVC = presentedVC as? UINavigationController {
                let lastVC = presentedNavVC.viewControllers.last
                return topViewController(vc: lastVC)
            }
            return topViewController(vc: presentedVC)
        }
        return nil
    }
    
    static func previousDate()-> [String]{
        let current = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        currentDate = current
        
         //ordinal date
       //  return [Utils.stringFromDate(date: current, format: "EEEE"),Utils.dateString(date:current,format:" MMM , yyyy")]
        
        return [Utils.stringFromDate(date: current, format: "EEEE"),Utils.stringFromDate(date: current, format: "dd MMM yyyy")]
    }
    
    static func nextDate() -> [String]{
        
        let current = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        currentDate = current
        
        //ordinal date
       //   return [Utils.stringFromDate(date: current, format: "EEEE"),Utils.dateString(date:current,format:" MMM , yyyy")]
        
        return [Utils.stringFromDate(date: current, format: "EEEE"),Utils.stringFromDate(date: current, format: "dd MMM yyyy")]
    }

}



