//
//  createchallanvc.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 30/07/24.
//

import UIKit

class createchallanvc: UIViewController {
    
    @IBOutlet weak var Datatxt: UITextField!
    @IBOutlet weak var Nametxt: UITextField!
    @IBOutlet weak var Locationtxt: UITextField!
    @IBOutlet weak var Remarktxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        
         setPlaceholderColor(textField: Datatxt, placeholderText: "Enter Date", color: UIColor.black)
           setPlaceholderColor(textField: Nametxt, placeholderText: "Enter Name", color: UIColor.black)
           setPlaceholderColor(textField: Locationtxt, placeholderText: "Enter Location", color: UIColor.black)
           setPlaceholderColor(textField: Remarktxt, placeholderText: "Enter Remark", color: UIColor.black)
    }
    
    func setPlaceholderColor(textField: UITextField, placeholderText: String, color: UIColor) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setup Date Picker
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        Datatxt.inputAccessoryView = toolbar
        Datatxt.inputView = datePicker
    }
    
    @objc private func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        Datatxt.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func donePressed() {
        self.view.endEditing(true)
    }
    
    @IBAction func Nextbtnaction(_ sender: UIButton) {
//        if validateFields() {
//            let name = Nametxt.text ?? ""
//            let date = Datatxt.text ?? ""
//            let location = Locationtxt.text ?? ""
//            let remark = Remarktxt.text ?? ""
//            
//            let challanData: [String: String] = ["name": name, "date": date, "location": location, "remark": remark]
            
   //         UserDefaults.standard.set(challanData, forKey: "challanData")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Additemvc") as! Additemvc
            self.navigationController?.pushViewController(vc, animated: true)
     //   }
    }
    
    // MARK: - Validation
    private func validateFields() -> Bool {
        var isValid = true
        var message = ""
        
        if Nametxt.text?.isEmpty ?? true {
            message += ""
            isValid = false
        }
        if Datatxt.text?.isEmpty ?? true {
            message += ""
            isValid = false
        }
        if Locationtxt.text?.isEmpty ?? true {
            message += ""
            isValid = false
        }
        if Remarktxt.text?.isEmpty ?? true {
            message += ""
            isValid = false
        }
        
        if !isValid {
            let alert = UIAlertController(title: "Validation Error", message: "Please fill all fileds", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        return isValid
    }
}
