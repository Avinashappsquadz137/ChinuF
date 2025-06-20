//
//  AllBookingVC.swift
//  SanskarEP
//
//  Created by Warln on 14/03/22.
//

import UIKit
import iOSDropDown

class AllBookingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var nameTxt: DropDown!
    @IBOutlet weak var channelTxt: DropDown!
    @IBOutlet weak var programTxt: DropDown!
    @IBOutlet weak var fromDateTxt: UITextField!
    @IBOutlet weak var toDateTxt: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchHolder: UIView!
    @IBOutlet weak var headerView: UIView!
    
    
    
    var appDel:AppDelegate? = nil
    
    var startD: String = ""
    var endD: String = ""
    var typ: String?
    var channel: String?
    var roData: ROData?
    var roDetails: [RODetail] = []
    var titleTxt: String?
    var boolingNo: String?
    var name: String?
    var status: String?
    var fCount = 0
    var sans: Bool = false
    var sat: Bool = false
    var shub: Bool = false
    var chName: String = ""
    var chanList = ["Sanskar", "Satsang","Shubh"]
    var progList = ["Proposed","Confirm","Rejected"]
    var empName = [String]()
    var crtCode = [String]()
    var crteName: String = ""
    var toggle: Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDel = (UIApplication.shared.delegate as! AppDelegate)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BookingData", bundle: nil), forCellReuseIdentifier: "BookingData")
        getListData()
        myAllBookingApi()
        setup()
    }
    
    func setup() {
        headerLbl.text = titleTxt
        chnnlTxt()
        progTxt()
        datepicker()
        datepicker2()
        searchHolder.isHidden = true
        headerView.isHidden = toggle
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterBtnPressed(_ sender: UIButton ) {
        if toggle == true {
            toggle = false
            UIView.animate(
                withDuration: 0.7,
                delay: 0.0,
                options: .transitionFlipFromTop,
                animations: {
                    self.headerView.isHidden = false
                    self.headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120)
                    self.tableView.reloadData()
                },
                completion: nil
            )
        }else {
            toggle = true
            UIView.animate(
                withDuration: 0.7,
                delay: 0.0,
                options: .transitionFlipFromTop,
                animations: {
                    self.headerView.isHidden = true
                    self.headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
                    self.tableView.reloadData()
                },
                completion: nil
            )
        }
        
    }
    
    
    @IBAction func filterActionPresse(_ sender: UIButton) {
        switch sender.tag {
        case 93:
            searchHolder.isHidden = false
        case 94:
            searchHolder.isHidden = true
        default:
            break
        }
    }
    
    func nameText() {
        nameTxt.optionArray = empName
        nameTxt.isSearchEnable = true
        nameTxt.listHeight = 150
        nameTxt.didSelect { selectedText, index, id in
            self.nameTxt.text = selectedText
            self.crteName = self.crtCode[index]
            self.myAllBookingApi()
        }
    }
    
    func chnnlTxt() {
        channelTxt.optionArray = chanList
        channelTxt.isSearchEnable = true
        channelTxt.listHeight = 150
        channelTxt.didSelect { selectedText, index, id in
            self.channelTxt.text = selectedText
            self.chName = self.channelTxt.text ?? ""
            self.myAllBookingApi()
        }
    }
    
    func progTxt() {
        programTxt.optionArray = progList
        programTxt.isSearchEnable = true
        programTxt.listHeight = 150
        programTxt.didSelect { selectedText, index, id in
            self.programTxt.text = selectedText
            self.sortData(with: selectedText)
            self.tableView.reloadData()
        }
    }
    
    func sortData(with data: String) {
        guard let item = roData?.roDetails else {return}
        roDetails.removeAll()
        
        for i in item {
            if i.status == data {
                roDetails.append(i)
            }
        }
        
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
        datePicker.frame.size = CGSize(width: 0, height: 150)
        fromDateTxt.inputView = datePicker
    }
    
    @objc
    func datePickerValue(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        fromDateTxt.text = dateFormatter.string(from: sender.date)
        startD = fromDateTxt.text ?? ""
        myAllBookingApi()
    }
    
    func datepicker2 () {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *){
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.addTarget(self, action: #selector(datePickerValue2(_:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 150)
        toDateTxt.inputView = datePicker
    }
    
    @objc
    func datePickerValue2(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        toDateTxt.text = dateFormatter.string(from: sender.date)
        endD = toDateTxt.text ?? ""
        myAllBookingApi()
    }
    
    func getListData() {
        let dict = Dictionary<String,Any>()
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: exList) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let json = data,(response?["status"] as? Bool == true), response != nil {
                let decode = JSONDecoder()
                do{
                    let result = try decode.decode(EmpLData.self, from: json)
                    for i in result.data {
                        self.empName.append(i.name)
                        self.crtCode.append(i.empCode)
                        self.nameText()
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    
    
    func myAllBookingApi(){
        
        var dictParam:Dictionary<String,String> = Dictionary<String,String>()
        
        dictParam["start_dt"] = startD
        dictParam["end_dt"] = endD
        dictParam["typ"] = "A"
        dictParam["channel"] = chName.lowercased()
        dictParam["created_by"] = crteName
        print("login Param:",dictParam)
        
        
        let loginApi = WebServiceOperation.init("http://bms.sanskargroup.in/sans-api/rest/apiServices/getMBLRODetail", dictParam as Dictionary<String, AnyObject>, WebServiceOperation.WEB_SERVICE.WEB_SERVICE_POST)
        loginApi.completionBlock = {
            guard let responseData = loginApi.responseData, responseData.count > 0 else {
                return
            }
            self.roDetails.removeAll()
            print(String.init(describing: String.init(data: responseData, encoding: String.Encoding.utf8)))
            do {
                let dictResponse = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String:Any]
                
                if let dictStatus = dictResponse["status"] as? Bool
                {
                    if dictStatus == true{
                        print(dictResponse)
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode(ROData.self, from: JSONSerialization.data(withJSONObject: dictResponse, options: JSONSerialization.WritingOptions.prettyPrinted))
                        self.roData = jsonData
                        for item in jsonData.roDetails {
                            self.roDetails.append(item)
                        }
                        DispatchQueue.main.async(execute: {
                            self.tableView.reloadData()
                        })
                        
                    }
                    else{
                        
                        let msgString = dictResponse["message"] as? String
                        print("AlertMessage",msgString ?? "")
                        self.roData?.roDetails.removeAll()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            } catch let err {
                
                print(err.localizedDescription)
            }
        }
        self.tableView.reloadData()
        self.appDel!.operationQueue.addOperation(loginApi)
    }
    
    func removeData() {
        startD.removeAll()
        endD.removeAll()
    }
    
    
    func verifyBooking(){
        
        var dictParam:Dictionary<String,String> = Dictionary<String,String>()
        
        dictParam["booking_no"] = boolingNo
        dictParam["status"] = status
        dictParam["verified_by"] = currentUser.EmpCode
        dictParam["emp_name"] = name
        dictParam["verified_ip"] = ""
        print("login Param:",dictParam)
        
        
        let loginApi = WebServiceOperation.init("http://bms.sanskargroup.in/sans-api/rest/apiServices/verifyRO", dictParam as Dictionary<String, AnyObject>, WebServiceOperation.WEB_SERVICE.WEB_SERVICE_POST)
        loginApi.completionBlock = {
            guard let responseData = loginApi.responseData, responseData.count > 0 else {
                return
            }
            print(String.init(describing: String.init(data: responseData, encoding: String.Encoding.utf8)))
            do {
                let dictResponse = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String:Any]
                
                if let dictStatus = dictResponse["status"] as? Bool
                {
                    if dictStatus == true{
                        print(dictResponse)
                        let msg = dictResponse["message"] as? String ?? ""
                        AlertController.alert(title: "Booking", message: msg)
                        DispatchQueue.main.async(execute: {
                            self.myAllBookingApi()
                            
                            self.tableView.reloadData()
                        })
                    }
                    else{
                        
                        let msgString = dictResponse["message"] as? String
                        print("AlertMessage",msgString ?? "")
                        
                    }
                }
            } catch let err {
                
                print(err.localizedDescription)
            }
        }
        self.appDel!.operationQueue.addOperation(loginApi)
    }
    
    @objc
    func acceptBtnPressed(_ sender: UIButton) {
        AlertController.alert(title: "Accept", message: "Do you really want to Accept", buttons: ["Yes","No"]) { text, index in
            if index == 0 {
                self.boolingNo = self.roData?.roDetails[sender.tag].bookingNo
                self.name = self.roData?.roDetails[sender.tag].empName
                self.status = "C"
                self.verifyBooking()
            }else{
                
            }
        }

    }
    
    @objc
    func rejectBtnPressed(_ sender: UIButton ) {

        AlertController.alert(title: "Reject", message: "Do you really want to reject", buttons: ["Yes","No"]) { text, index in
            if index == 0{
                self.boolingNo = self.roData?.roDetails[sender.tag].bookingNo
                self.name = self.roData?.roDetails[sender.tag].empName
                self.status = "R"
                self.verifyBooking()
            }else{
                
            }

        }

    }
    
    
    
}

//MARK: - UITableView Datasource

extension AllBookingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingData", for: indexPath) as? BookingData else {
            return UITableViewCell()
        }
        let index = indexPath.row
        cell.setData(body: roDetails[index])
        cell.acceptBtn.tag = index
        cell.rejectBtn.tag = index
        cell.acceptBtn.addTarget(self, action: #selector(acceptBtnPressed(_:)), for: .touchUpInside)
        cell.rejectBtn.addTarget(self, action: #selector(rejectBtnPressed(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    
}

extension AllBookingVC: UITableViewDelegate {


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }


}
