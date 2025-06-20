//
//  HealthVc.swift
//  SanskarEP
//
//  Created by Warln on 13/01/22.
//

import UIKit
import iOSDropDown

class HealthVc: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var reuestDate: UILabel!
    @IBOutlet weak var reasonTxtView : UITextView!
    @IBOutlet weak var menuTxtf: DropDown!
    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var policyTxt: UILabel!
    @IBOutlet weak var amounttxt: UILabel!
    @IBOutlet weak var expireydate: UILabel!
    
    
    var stat: Bool = false
    var item: String?
    var titleTxt: String?

    fileprivate let pickerView = ToolbarPickerView()
    var eventName = ["I-Card","Notebook","Pen","Water Bottle","Other"]

    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        
      //  headerLbl.text = titleTxt
  //      policyTxt.text = currentUser.PolicyNumber
  //      amounttxt.text = currentUser.PolicyAmount
    //    expireydate.text = currentUser.Name
        
        setup()
    }
    
    //MARK: - Setup functionality
    
    func setup() {
        
        reuestDate.text = Date().dateToString()
        //    cardView.isHidden = false
        reasonTxtView.layer.cornerRadius = 10
        reasonTxtView.layer.borderWidth = 1.0
        reasonTxtView.layer.borderColor = UIColor.lightGray.cgColor
        reasonTxtView.clipsToBounds = true
        
        menuTxtf.optionArray = eventName
        menuTxtf.isSearchEnable = true
        menuTxtf.listHeight = 150
        menuTxtf.didSelect { selectedText, index, id in
            self.menuTxtf.text = selectedText
            self.item = selectedText
            
            
            
            
            
            
        }
    }
    
    //MARK: - IBAction Button Pressed
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func detailBtnPressed(_ sender: UIButton){
        
        
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        
      //  statRequest()
        guard let selectedEventType = item, !selectedEventType.isEmpty else {
               AlertController.alert(message: "Please select an Request type")
               return
           }

           guard let reason = reasonTxtView.text, !reason.isEmpty else {
               AlertController.alert(message: "Please provide a Reason")
               return
           }

           statRequest()
        
    }
    
    func statRequest() {
        var dict = Dictionary<String,Any>()
        dict["RequestType"] = item
        dict["reason"] = reasonTxtView.text
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kStat) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data ,(response?["status"] as? Bool == true), response != nil {
                self.removeData()
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }else{
                print(response?["error"] as Any)
            }
            
        }
    }
    
    func removeData() {
        
        item?.removeAll()
        reasonTxtView.text.removeAll()
        menuTxtf.text?.removeAll()
    }

    @IBAction func buttonon(_ sender: UIButton) {
    }
    
}

//MARK: - PickerView Delegate

extension HealthVc: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.eventName.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.eventName[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.menuTxtf.text = self.eventName[row]
    }
}

extension HealthVc: ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.menuTxtf.text = self.eventName[row]
        self.item = self.eventName[row]
        self.menuTxtf.resignFirstResponder()
    }
 
    func didTapCancel() {
        self.menuTxtf.text = nil
        self.menuTxtf.resignFirstResponder()
    }
}
