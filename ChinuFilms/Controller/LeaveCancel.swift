//
//  LeaveCancel.swift
//  SanskarEP
//
//  Created by Warln on 15/01/22.
//

import UIKit

class LeaveCancel: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var halfView: UIView!
    @IBOutlet weak var offView: UIView!
    @IBOutlet weak var tourView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var requestId: UITextField!
    
    var type: String?
    var reqNo: String?
    var isSelect: Bool = false
    var titleTxt: String?
    fileprivate let pickerView = ToolbarPickerView()
    var report : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    //MARK: - Setup Functionality
    
    func setup() {
        fullView.circleWithBorder1()
        halfView.circleWithBorder1()
        offView.circleWithBorder1()
        tourView.circleWithBorder1()
        headerLbl.text = titleTxt
        
        self.requestId.inputView = self.pickerView
        self.requestId.inputAccessoryView = self.pickerView.toolbar
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self
        
        self.pickerView.reloadAllComponents()
        self.requestId.isEnabled = false
    }
    
    //MARK: - IBAction Button Pressed
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseBtnPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        
        //        if reqNo == nil {
        //            AlertController.alert(message: "Please select Request No")
        //        }else if isSelect != true {
        //       //     AlertController.alert(message: "Please select leave type")
        //        }else{
        //            getReport()
        //        }
        //
        //
        //        isSelect = false
        //        cancelApi()
        //        removeData()
        guard let reqNo = reqNo, !reqNo.isEmpty else {
            AlertController.alert(message: "Please select Request No")
            return
        }
        
        guard isSelect else {
            AlertController.alert(message: "Please select leave type")
            return
        }
        
        getReport()
        cancelApi()
        removeData()
    }
    
    @IBAction func dayBtnPressed(_ sender: UIButton) {
        //        let day = sender.tag
        //        switch  day {
        //        case 22:
        //            type = "full"
        //            fullView.backgroundColor = .red
        //            halfView.backgroundColor = .white
        //            offView.backgroundColor  = .white
        //            tourView.backgroundColor = .white
        //        case 23:
        //            type = "half"
        //            fullView.backgroundColor = .white
        //            halfView.backgroundColor = .red
        //            offView.backgroundColor  = .white
        //            tourView.backgroundColor = .white
        //        case 24:
        //            type = "off"
        //            fullView.backgroundColor = .white
        //            halfView.backgroundColor = .white
        //            offView.backgroundColor  = .red
        //            tourView.backgroundColor = .white
        //            isSelect = true
        //        case 25:
        //            type = "tour"
        //            fullView.backgroundColor = .white
        //            halfView.backgroundColor = .white
        //            offView.backgroundColor  = .white
        //            tourView.backgroundColor = .red
        //        default:
        //            break
        //        }
        //
        //        getReport()
        //
        
        let day = sender.tag
        self.requestId.text = nil
            self.reqNo = nil
        switch day {
        case 22:
            if type == "full" && fullView.backgroundColor == .blue {
                type = ""
                fullView.backgroundColor = .clear
            } else {
                type = "full"
                fullView.backgroundColor = .blue
                halfView.backgroundColor = .clear
                offView.backgroundColor = .clear
                tourView.backgroundColor = .clear
                isSelect = true
            }
        case 23:
            if type == "half" && halfView.backgroundColor == .blue {
                type = ""
                halfView.backgroundColor = .clear
            } else {
                type = "half"
                fullView.backgroundColor = .clear
                halfView.backgroundColor = .blue
                offView.backgroundColor = .clear
                tourView.backgroundColor = .clear
                isSelect = true
            }
        case 24:
            if type == "off" && offView.backgroundColor == .blue {
                type = ""
                offView.backgroundColor = .clear
            } else {
                type = "off"
                fullView.backgroundColor = .clear
                halfView.backgroundColor = .clear
                offView.backgroundColor = .blue
                tourView.backgroundColor = .clear
                isSelect = true
            }
        case 25:
            if type == "tour" && tourView.backgroundColor == .blue {
                type = ""
                tourView.backgroundColor = .clear
            } else {
                type = "tour"
                fullView.backgroundColor = .clear
                halfView.backgroundColor = .clear
                offView.backgroundColor = .clear
                tourView.backgroundColor = .blue
                isSelect = true
            }
        default:
            break
        }
        self.requestId.isEnabled = isSelect
        getReport()
    }
}
//MARK: - Get Data From Api

extension LeaveCancel {
    //Mark: Report Api
    func getReport() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["leave_type"] = type
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: kleaveReport) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let response = response, let status = response["status"] as? Bool, status == true {
                self.report.removeAll()
                let rep = response["data"] as? [Any] ?? []
                if rep.isEmpty {
                    self.report.append("No Data Found")
                } else {
                    let reqID = (rep[0] as? [Any] ?? [])
                    for id in reqID {
                        switch self.type {
                        case "full":
                            let rep = (id as? [String: Any] ?? [:])["Emp_Req_No"] as? String ?? ""
                            let status = (id as? [String: Any] ?? [:])["HOD_Approval"] as? String ?? ""
                            if status == "R" {
                                self.report.append(rep)
                               
                            }
                        case "half":
                            let rep = (id as? [String: Any] ?? [:])["ID"] as? String ?? ""
                            let statu = (id as? [String: Any] ?? [:])["Status"] as? String ?? ""
                            if statu == "R" {
                                self.report.append(rep)
                               
                            }
                        case "off":
                            let rep = (id as? [String: Any] ?? [:])["Emp_Req_No"] as? String ?? ""
                            let statu = (id as? [String: Any] ?? [:])["Status"] as? String ?? ""
                            if statu == "R" {
                                self.report.append(rep)
                            }
                        case "tour":
                            let rep = (id as? [String: Any] ?? [:])["ID"] as? String ?? ""
                            let statu = (id as? [String: Any] ?? [:])["Status"] as? String ?? ""
                            if statu == "R" {
                                self.report.append(rep)
                            }
                        case .none:
                            break
                        case .some(_):
                            break
                        }
                    }
                }
                self.pickerView.reloadAllComponents()
            } else {
                print(response?["error"] as Any)
                self.report = ["No Data Found"]
                self.pickerView.reloadAllComponents()
            }
        }
    }

    
    //Mark: Cancel Request Leave
    func cancelApi() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        print(dict["EmpCode"])
        dict["RequestId"] = reqNo
        print(dict["RequestId"])
        dict["leave_type"] = type
        print(dict["leave_type"])
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kLeaveCancel) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                
            }else{
                print(response?["error"] as Any)
            }
            self.removeData()
        }
    }
    
    func removeData() {
        fullView.backgroundColor = .white
        halfView.backgroundColor = .white
        tourView.backgroundColor = .white
        offView.backgroundColor = .white
        reqNo?.removeAll()
        type?.removeAll()
        isSelect = false
     
        self.requestId.isEnabled = false
    }
}

//MARK: - UIPICkerViewDatasource and UIPICKerDelegate
extension LeaveCancel: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.report.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.report[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if report.count > 0 {
            self.requestId.text = self.report[row]
        }
    }
}

//MARK: - ToolBar PickerDelegate
extension LeaveCancel: ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        if report.count > 0 {
            self.requestId.text = self.report[row]
            self.reqNo = self.report[row]
        }
        self.requestId.resignFirstResponder()
    }

    func didTapCancel() {
        self.requestId.text = nil
        self.requestId.resignFirstResponder()
    }
}
