//
//  TourManageVc.swift
//  SanskarEP
//
//  Created by Warln on 12/01/22.
//

import UIKit

class TourManageVc: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var toTxtField: UITextField!
    @IBOutlet weak var fromTxtField: UITextField!
    @IBOutlet weak var locatTxtField: UITextField!
    @IBOutlet weak var reqTxtField: UITextField!
    @IBOutlet weak var remarkTxtView: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    //Mark:- Variable
    var titleTxt: String?
    var fromDate: String?
    var toDate: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitBtn.layer.cornerRadius = 10
        submitBtn.clipsToBounds = true
      //  titleLbl.text = titleTxt
        remarkTxtView.delegate = self
        remarkTxtView.layer.cornerRadius = 10
        remarkTxtView.clipsToBounds = true
        remarkTxtView.text = "Remark ..."
        remarkTxtView.textColor = UIColor.lightGray
        
//        if #available(iOS 15.0, *) {
//            sheetPresentationController?.prefersGrabberVisible = true
//        } else {
//            // Fallback on earlier versions
//        }
//        if #available(iOS 15.0, *) {
//            sheetPresentationController?.detents = [.large()]
//        } else {
//            // Fallback on earlier versions
//        }

    }
    
    //MARK: - IBAction Button Pressed
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        tourData()
        removeData()
     //   self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        switch sender.tag {
        case 3:
            self.navigationController?.popViewController(animated: true)
        case 4:
            self.performSegue(withIdentifier: idenity.tourToSee, sender: self)
        default:
            print("Nothing")
        }
    }
    
    @IBAction func dateBtnPressed(_ sender: UIButton ) {
        switch sender.tag {
        case 5:
            IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
                self.fromDate = Utils.dateString(date: date, format: "yyyy-MM-dd")
                self.fromTxtField.text! = self.fromDate!
            }
        case 6:
            print(sender.tag)
            IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
                self.toDate = Utils.dateString(date: date, format: "yyyy-MM-dd")
                self.toTxtField.text! = self.toDate!
            }
        default:
            print("Nothing")
        }
    }
    

}

//MARK: - TextView Delegate

extension TourManageVc : UITextViewDelegate {
    
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

            remarkTxtView.text = "Remark ..."
            remarkTxtView.textColor = UIColor.lightGray
        }
    }
}

//MARK: - Extra functionality

extension TourManageVc {
    
    func tourData() {
        var dict = Dictionary<String,Any>()
        dict["Date1"] = fromDate
        dict["Date2"] = toDate
        dict["Requirement"] = reqTxtField.text!
        dict["Remarks"] = remarkTxtView.text!
        dict["Location"] = locatTxtField.text!
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: tourApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                self.removeData()
            }else{
                print(response?["error"] as Any)
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
            
        }
        
    }
    
    
    func removeData() {
        fromTxtField.text?.removeAll()
        toTxtField.text?.removeAll()
        remarkTxtView.text?.removeAll()
        locatTxtField.text?.removeAll()
        reqTxtField.text?.removeAll()
        fromDate?.removeAll()
        toDate?.removeAll()
    }
    
}
