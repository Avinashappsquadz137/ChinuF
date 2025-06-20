//
//  NewBookVc.swift
//  SanskarEP
//
//  Created by Warln on 22/02/22.
//

import UIKit
import iOSDropDown

protocol GetBooking {
    func detail(data: [String: Any])
}

class NewBookVc: UIViewController, GetStatus {
    
    // UItextField
    @IBOutlet weak var nameTxtF: DropDown!
    @IBOutlet weak var startD: UITextField!
    @IBOutlet weak var endD: UITextField!
    @IBOutlet weak var startT: UITextField!
    @IBOutlet weak var endT: UITextField!
    @IBOutlet weak var locatTxtF: UITextField!
    @IBOutlet weak var amountTxtF: UITextField!
    @IBOutlet weak var programList: UITextField!
    @IBOutlet weak var channelList: UITextField!
    // UIView
    @IBOutlet weak var gstView: UIView!
    @IBOutlet weak var confirmV: UIView!
    @IBOutlet weak var propView: UIView!
    // Button
    @IBOutlet weak var gstBtn: UIButton!
    @IBOutlet weak var confirmB: UIButton!
    @IBOutlet weak var proposalB: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    
    // Variable
    fileprivate let pickerView1 = ToolbarPickerView()
    fileprivate let pickerView2 = ToolbarPickerView()
    fileprivate let pickerView3 = ToolbarPickerView()
    
    fileprivate let timePicker = UIDatePicker()
    var chList = ["Sanskar", "Satsang","Shubh"]
    var proList = ["Katha","Slot"]
    var select: Bool?
    var select2: Bool?
    var santData: SantData?
    var santNam: [String] = []
    var gst: Bool = false
    var confirm: Bool = false
    var propose: Bool = false
    var selected: Int = 0
    var titleTxt: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        getSantName()
        pickerSetup()
        timePickerSetup()
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
    
    func setup(){
        self.programList.colorBorder()
        self.channelList.colorBorder()
        self.nameTxtF.colorBorder()
        gstView.circleWithBorder()
        confirmV.circleWithBorder()
        propView.circleWithBorder()
        dateLbl.text = Date().dateToString()
        headerLbl.text = titleTxt
    }
    
    func pickerSetup() {
        // PickerView 1
        self.programList.inputView = self.pickerView1
        self.programList.inputAccessoryView = self.pickerView1.toolbar
        self.pickerView1.dataSource = self
        self.pickerView1.delegate = self
        self.pickerView1.toolbarDelegate = self
        self.pickerView1.reloadAllComponents()
        // PickerView 2
        self.channelList.inputView = self.pickerView2
        self.channelList.inputAccessoryView = self.pickerView2.toolbar
        self.pickerView2.dataSource = self
        self.pickerView2.delegate = self
        self.pickerView2.toolbarDelegate = self
        self.pickerView2.reloadAllComponents()
        self.datepicker()
        self.datepicker2()
        //pickerView 3
        
    }
    
    func timePickerSetup() {
        let toolBar = UIToolbar()
        let toolBar2 = UIToolbar()
        toolBar.sizeToFit()
        toolBar2.sizeToFit()
        let doneBtn1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnClicK))
        let doneBtn2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnClicK1))
        toolBar.items = [doneBtn1]
        toolBar2.items = [doneBtn2]
        startT.inputAccessoryView = toolBar
        startT.inputView = timePicker
        endT.inputAccessoryView = toolBar2
        endT.inputView = timePicker
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setDrop() {
        nameTxtF.optionArray = santNam
        nameTxtF.isSearchEnable = true
        nameTxtF.listHeight = 150
        nameTxtF.didSelect { selectedText, index, id in
            self.nameTxtF.text = selectedText
            self.selected = index
        }
    }
    
    @IBAction func backBtnPressed (_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func doneBtnClicK() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        startT.text = "\(formatter.string(from: timePicker.date)):00"
        self.view.endEditing(true)
    }
    
    @objc
    func doneBtnClicK1() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm"
        endT.text = "\(formatter.string(from: timePicker.date)):00"
        self.view.endEditing(true)
    }
    
    
    func datepicker () {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.addTarget(self, action: #selector(datePickerValue(_:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 250)
        startD.inputView = datePicker
    }
    
    @objc
    func datePickerValue(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        startD.text = dateFormatter.string(from: sender.date)
    }
    
    func datepicker2 () {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.addTarget(self, action: #selector(datePickerValue2(_:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 250)
        endD.inputView = datePicker
    }
    
    @objc
    func datePickerValue2(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        endD.text = dateFormatter.string(from: sender.date)
    }
    
    
    @IBAction func gstDetailPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 72:
            if gst == false {
                sender.backgroundColor = .lightGray
                gst = true
            }else{
                sender.backgroundColor = .white
                gst = false
            }
        case 73:
            if confirm == false {
                sender.backgroundColor = .lightGray
                proposalB.backgroundColor = .white
                propose = false
                confirm = true
            }else{
                sender.backgroundColor = .white
                confirm = false
            }
        case 74:
            if propose == false {
                sender.backgroundColor = .lightGray
                confirmB.backgroundColor = .white
                confirm = false
                propose = true
            }else{
                sender.backgroundColor = .white
                propose = false
            }
        default:
            break
        }
        
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        if (programList.text?.isEmpty == false) && (channelList.text?.isEmpty == false) && (nameTxtF.text?.isEmpty == false) && (startD.text?.isEmpty == false) && (endD.text?.isEmpty == false) && (startT.text?.isEmpty == false) && (endT.text?.isEmpty == false) && (locatTxtF.text?.isEmpty == false) && (endT.text?.isEmpty == false){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "submitBook") as! submitBook
            guard let name = nameTxtF.text else {return}
            vc.progTxt = programList.text!
            vc.channelTxt = channelList.text!
            vc.name = name
            vc.fromdate = startD.text!
            vc.toDate = endD.text!
            vc.fromTime = startT.text!
            vc.toTime = endT.text!
            vc.locate = locatTxtF.text!
            vc.total = amountTxtF.text!
            vc.id = santData?.santName[selected].sc
            vc.gst = gst
            vc.confirm = confirm
            vc.prop = propose
            vc.delegate = self
            vc.titleText = "Submit Details"
            self.present(vc, animated: true, completion: nil)
        }else{
            AlertController.alert(message: "Please Fill the details")
        }

    }
    
    
    
    func getSantName() {
        if let url = URL(string: bookingBase + santName ) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                if let safeData = data {
                    if let json = String(data: safeData, encoding: .utf8){
                        var newValue = json.replacingOccurrences(of: "callback(", with: "")
                        newValue = newValue.replacingOccurrences(of: ")", with: "")
                        let newData = newValue.data(using: .utf8)!
                        do {
                            let decoder = JSONDecoder()
                            self.santData = try decoder.decode(SantData.self, from: newData)
                            for sant in self.santData?.santName ?? [] {
                                self.santNam.append(sant.sn)
                            }
                            DispatchQueue.main.async {
                                self.setDrop()
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                    }

                }
            }
            task.resume()
        }
    }
    
    func getStatus(_ state: Bool) {
        if state == true {
            programList.text?.removeAll()
            channelList.text?.removeAll()
            nameTxtF.text?.removeAll()
            startD.text?.removeAll()
            endD.text?.removeAll()
            startT.text?.removeAll()
            endT.text?.removeAll()
            locatTxtF.text?.removeAll()
            amountTxtF.text?.removeAll()
            proposalB.backgroundColor = .white
            confirmB.backgroundColor = .white
            gstBtn.backgroundColor = .white
        }
    }
    
    
}

//MARK: - PickerView Delegate
extension NewBookVc: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerView1 {
            return self.proList.count
        }else{
            return self.chList.count
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1 {
            return self.proList[row]
        }else {
            return self.chList[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1 {
            self.programList.text = self.proList[row]
            select = false
        }else {
            self.channelList.text = self.chList[row]
            select = true
        }
        
    }
    
    
}

//MARK: - ToolBarDelegate
extension NewBookVc: ToolbarPickerViewDelegate {
    func didTapDone() {
        if select == true {
            let row = self.pickerView2.selectedRow(inComponent: 0)
            self.pickerView2.selectRow(row, inComponent: 0, animated: false)
            self.channelList.text = self.chList[row]
            self.channelList.resignFirstResponder()
        }else{
            let row = self.pickerView1.selectedRow(inComponent: 0)
            self.pickerView1.selectRow(row, inComponent: 0, animated: false)
            self.programList.text = self.proList[row]
            self.programList.resignFirstResponder()
        }
        
    }
    
    func didTapCancel() {
        if select == true {
            self.channelList.text = nil
            self.channelList.resignFirstResponder()
        }else{
            self.programList.text = nil
            self.programList.resignFirstResponder()

        }
        
    }
    
}
