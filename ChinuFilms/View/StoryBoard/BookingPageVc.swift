//
//  BookingPageVc.swift
//  SanskarEP
//
//  Created by Surya on 01/05/24.
//
//roleID == 1  tyagi ji , permission 1
//roleID == 2 vipil ji , permission 2
//roleID == 3 sales , permission 3
//roleID == 4 reception, permission 4
//roleID == 5 HOD  , permission 5
//roleID == 6 employees
//roleID == 7 qc employee
//roleID == 8 Qc hod
//roleID == 9 Qc team by channel
//roleID == 10 Library

import UIKit

class BookingPageVc: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var labelbtn: UILabel!
    @IBOutlet weak var Mainview: UIView!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var amntlbl: UILabel!
    @IBOutlet weak var gstlbl: UILabel!
    @IBOutlet weak var channellbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var aprlbtn: UIButton!
    @IBOutlet weak var rejectbtn: UIButton!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var approveview: UIView!
    @IBOutlet weak var tableviewtop: NSLayoutConstraint!
    @IBOutlet weak var suggestionimage: UIImageView!
    @IBOutlet weak var suggestionview: UIView!
    @IBOutlet weak var reason: NSLayoutConstraint!
    @IBOutlet weak var remarkstxt: UITextField!
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    @IBOutlet weak var starttime: UITextField!
    @IBOutlet weak var Endtime: UITextField!
    @IBOutlet weak var suggestbtn: UIButton!
    @IBOutlet weak var approvedview: UIView!
    @IBOutlet weak var switchpermisssion: UISwitch!
    @IBOutlet weak var eyesview: UIView!
    @IBOutlet weak var editview: UIView!
    @IBOutlet weak var Datelabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var editfromdate: UITextField!
    @IBOutlet weak var edittodate: UITextField!
    @IBOutlet weak var editstarttime: UITextField!
    @IBOutlet weak var editendtime: UITextField!
    @IBOutlet weak var editreamrks: UITextField!
    @IBOutlet weak var editsubmitbtn: UIButton!
    @IBOutlet weak var switchview: UIView!
    @IBOutlet weak var Switchfromtxt: UITextField!
    @IBOutlet weak var SwitchtoTxt: UITextField!
    @IBOutlet weak var filtersubmitbtn: UIButton!
    @IBOutlet weak var filterview: UIView!
    @IBOutlet weak var filterCollView: UICollectionView!
    @IBOutlet weak var Assignview: UIView!
    @IBOutlet weak var AssignName: UILabel!
    @IBOutlet weak var allselectbtn: UIButton!
    @IBOutlet weak var assigntobtn: UIButton!
    @IBOutlet weak var searchbtn: UIButton!
    @IBOutlet weak var secondeyeview: UIView!
    @IBOutlet weak var secondviewcancle: UIButton!
    @IBOutlet weak var secondtable: UITableView!
    @IBOutlet weak var playerview: UIView!
    @IBOutlet weak var playerimageview: UIImageView!
    @IBOutlet weak var metaview: UIView!
    @IBOutlet weak var metaremarks: UITextView!
    @IBOutlet weak var metasubmitbtn: UIButton!
    @IBOutlet weak var mtacancel: UIButton!
    @IBOutlet weak var filterbtn: UIButton!
    @IBOutlet weak var searchview: UIView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    var datalist  = [[String:Any]]()
    var DataList  = [[String:Any]]()
    var Viewlist  = [[String:Any]]()
    var Datalist1 = [[String:Any]]()
    var selectedBookingRows: Set<Int> = []
    var kathaId: [Int] = []
    var kathaIds: [Int] = []
    var kathaid = Int()
    var SalesId: String?
    var KEY: String?
    var Range: String?
    var imaged = String()
    var PromoId = Int()
    var promotype =  String()
    var status = String()
    var empCode: String?
    var kathaID = Int()
//    var PromoUrl: String?
    var filterData = [[String:Any]]()
    fileprivate let timePicker = UIDatePicker()
    fileprivate let edittimePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        boookingApi()
        receptionbookAPi()
        timePickerSetup()
        edittimePickerSetup()
        removeData()
        contentcompleteApi(kathaID: 123)
        allselectbtn.isHidden = true
        assigntobtn.isHidden = true
        switchpermisssion.isOn = false
        tableview.delegate = self
        tableview.dataSource = self
        filterCollView.dataSource = self
        filterCollView.delegate = self
        secondtable.delegate = self
        secondtable.dataSource = self
        tableview.register(UINib(nibName: "BookingPageCell", bundle: nil), forCellReuseIdentifier: "BookingPageCell")
        tableview.register(UINib(nibName: "ReceptionListCell", bundle: nil), forCellReuseIdentifier: "ReceptionListCell")
        tableview.register(UINib(nibName: "QcMetaCell", bundle: nil), forCellReuseIdentifier: "QcMetaCell")
        secondtable.register(UINib(nibName: "DetailsEmployCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        btn.layer.cornerRadius = 8
        metasubmitbtn.layer.cornerRadius = 8
        mtacancel.layer.cornerRadius = 8
        btn.clipsToBounds = true
        Assignview.isHidden = true
        metaview.isHidden = true
        playerview.isHidden = true
        eyesview.isHidden = true
        secondeyeview.isHidden = true
        editview.isHidden = true
        switchview.isHidden = true
        setup()
        switchview.isHidden = true
        filterCollView.isHidden = true
        secondtable.isHidden = true
        switchpermisssion.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideDetailView))
        //            tapGesture.cancelsTouchesInView = false
        //            self.view.addGestureRecognizer(tapGesture)
        
        if  let roleID = Int(currentUser.booking_role_id), roleID == 5 || roleID == 6 || roleID == 8 || roleID == 7 || roleID == 9 || roleID == 10 {
            btn.isHidden = true
            searchbtn.isHidden = true
            labelbtn.isHidden = true
            tableviewtop.constant = -50
        } else {
            btn.isHidden = false
            searchbtn.isHidden = false
            labelbtn.isHidden = false
            tableviewtop.constant = 10
        }
        if  let roleID = Int(currentUser.booking_role_id), roleID == 1 {
            approvedview.isHidden = false
            //   allselectbtn.isHidden = false
        } else {
            approvedview.isHidden = true
            allselectbtn.isHidden = true
        }
        if  let roleID = Int(currentUser.booking_role_id), roleID == 2 || roleID == 3 || roleID == 4 || roleID == 5 || roleID == 6 || roleID == 8 || roleID == 7 || roleID == 9 || roleID == 10 {
            searchbtn.isHidden = true
        } else {
            searchbtn.isHidden = false
        }
        searchbtn.isHidden = true
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        filterCollView.collectionViewLayout = layout
        filterCollView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        metaremarks.delegate = self
        metaremarks.layer.cornerRadius = 10
        metaremarks.clipsToBounds = true
        metaremarks.text = "Remark ..."
        metaremarks.layer.borderWidth = 1.0
        metaremarks.layer.borderColor = UIColor.lightGray.cgColor
        metaremarks.textColor = UIColor.lightGray
        
        searchview.isHidden = true
    }
    
    func removeData() {
        editfromdate.text?.removeAll()
        edittodate.text?.removeAll()
        editstarttime.text?.removeAll()
        editendtime.text?.removeAll()
        remarkstxt.text?.removeAll()
    }
    
    func setup(){
        aprlbtn.layer.cornerRadius = 8
        aprlbtn.clipsToBounds = true
        assigntobtn.layer.cornerRadius = 8
        assigntobtn.clipsToBounds = true
        filtersubmitbtn.layer.cornerRadius = 8
        filtersubmitbtn.clipsToBounds = true
        suggestbtn.layer.cornerRadius = 8
        suggestbtn.clipsToBounds = true
        rejectbtn.layer.cornerRadius = 8
        rejectbtn.clipsToBounds = true
        editsubmitbtn.layer.cornerRadius = 8
        editsubmitbtn.clipsToBounds = true
        labelbtn.clipsToBounds = true
        labelbtn.layer.cornerRadius = 8
        Mainview.isHidden = true
        approveview.isHidden = true
        suggestionview.isHidden = true
        suggestbtn.isHidden = true
        editsubmitbtn.layer.cornerRadius = 8
        editsubmitbtn.clipsToBounds = true
        fromdate.layer.cornerRadius = 10
        fromdate.layer.borderWidth = 0.5
        fromdate.layer.borderColor = UIColor.lightGray.cgColor
        todate.layer.cornerRadius = 10
        todate.layer.borderWidth = 0.5
        todate.layer.borderColor = UIColor.lightGray.cgColor
        starttime.layer.cornerRadius = 10
        starttime.layer.borderWidth = 0.5
        starttime.layer.borderColor = UIColor.lightGray.cgColor
        Endtime.layer.cornerRadius = 10
        Endtime.layer.borderWidth = 0.5
        Endtime.layer.borderColor = UIColor.lightGray.cgColor
        remarkstxt.layer.cornerRadius = 10
        remarkstxt.layer.borderWidth = 1.0
        remarkstxt.layer.borderColor = UIColor.black.cgColor
        editfromdate.layer.cornerRadius = 10
        editfromdate.layer.borderWidth = 0.5
        editfromdate.layer.borderColor = UIColor.lightGray.cgColor
        edittodate.layer.cornerRadius = 10
        edittodate.layer.borderWidth = 0.5
        edittodate.layer.borderColor = UIColor.lightGray.cgColor
        editstarttime.layer.cornerRadius = 10
        editstarttime.layer.borderWidth = 0.5
        editstarttime.layer.borderColor = UIColor.lightGray.cgColor
        editendtime.layer.cornerRadius = 10
        editendtime.layer.borderWidth = 0.5
        editendtime.layer.borderColor = UIColor.lightGray.cgColor
        editreamrks.layer.cornerRadius = 10
        editreamrks.layer.borderWidth = 0.5
        editreamrks.layer.borderColor = UIColor.lightGray.cgColor
        
        
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
        starttime.inputAccessoryView = toolBar
        starttime.inputView = timePicker
        Endtime.inputAccessoryView = toolBar2
        Endtime.inputView = timePicker
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        } else {
        }
    }
    func edittimePickerSetup() {
        let edittoolBar = UIToolbar()
        let edittoolBar2 = UIToolbar()
        edittoolBar.sizeToFit()
        edittoolBar2.sizeToFit()
        let doneBtn1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editdoneBtnClicK))
        let doneBtn2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editdoneBtnClicK1))
        edittoolBar.items = [doneBtn1]
        edittoolBar2.items = [doneBtn2]
        editstarttime.inputAccessoryView = edittoolBar
        editstarttime.inputView = edittimePicker
        editendtime.inputAccessoryView = edittoolBar2
        editendtime.inputView = edittimePicker
        edittimePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            edittimePicker.preferredDatePickerStyle = .wheels
        } else {
        }
    }
    
    @IBAction func filterbtnaction(_ sender: UIButton) {
        self.searchview.isHidden = !self.searchview.isHidden
    }
    
    
    @IBAction func searchhidebtn(_ sender: UIButton) {
        searchview.isHidden = true
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            allselectbtn.isHidden = false
            FilterListApi()
            searchbtn.isHidden = false
            filterbtn.isHidden = true
        } else {
            allselectbtn.isHidden = true
            selectedBookingRows.removeAll()
            boookingApi()
            searchbtn.isHidden = true
            filterbtn.isHidden = false
        }
        self.tableview.reloadData()
    }
    
    @IBAction func customsubmitbtn(_ sender: UIButton) {
        FilterListApi()
        switchview.isHidden = true
    }
    @IBAction func selectallbtn(_ sender: UIButton) {
        if selectedBookingRows.count == datalist.count {
            selectedBookingRows.removeAll()
            kathaIds.removeAll()
            sender.setImage(UIImage(named: "Uncheck"), for: .normal)
        } else {
            selectedBookingRows = Set(0..<datalist.count)
            kathaId = datalist.compactMap { $0["Katha_id"] as? Int }
            sender.setImage(UIImage(named: "check"), for: .normal)
        }
        assigntobtn.isHidden = selectedBookingRows.isEmpty
        labelbtn.isHidden = !selectedBookingRows.isEmpty
        btn.isHidden = !selectedBookingRows.isEmpty
        tableview.reloadData()
    }
    
    @IBAction func assigntobtn(_ sender: UIButton) {
        self.Assignview.isHidden = !self.Assignview.isHidden
        selectTypeApi()
    }
    
    @IBAction func searchbtn(_ sender: UIButton) {
        FilterSelectApi()
        self.filterCollView.isHidden = !self.filterCollView.isHidden
    }
    
    @IBAction func switchbtncancel(_ sender: UIButton) {
        switchview.isHidden = true
    }
    
    @IBAction func assignsubmitbtn(_ sender: UIButton) { //kathaid
        if !kathaIds.isEmpty {
            SelectKathaAssignApi()
        } else {
            print("No Katha selected")
            AlertController.alert(message: "Please select at least one Katha")
        }
        tableview.reloadData()
    }
    @objc
    func doneBtnClicK() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm a"
        starttime.text = "\(formatter.string(from: timePicker.date))"
        self.view.endEditing(true)
    }
    @objc
    func doneBtnClicK1() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm a"
        Endtime.text = "\(formatter.string(from: timePicker.date))"
        self.view.endEditing(true)
    }
    @objc
    func editdoneBtnClicK() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm a"
        editstarttime.text = "\(formatter.string(from: edittimePicker.date))"
        self.view.endEditing(true)
    }
    @objc
    func editdoneBtnClicK1() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm a"
        editendtime.text = "\(formatter.string(from: edittimePicker.date))"
        self.view.endEditing(true)
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    //    @objc func hideDetailView() {
    //        Mainview.isHidden = true
    //    }
    
    @IBAction func newbookingbtn(_ sender: UIButton) {
        var vc: UIViewController
        if let roleID = Int(currentUser.booking_role_id), roleID == 4 {
            vc = storyboard?.instantiateViewController(withIdentifier: "BookforReceptionVc") as! BookforReceptionVc
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    var customDetent: UISheetPresentationController.Detent?
                    if #available(iOS 16.0, *) {
                        customDetent = UISheetPresentationController.Detent.custom { context in
                            return 540
                        }
                        sheet.detents = [customDetent!]
                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                    }
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 12
                }
            }
            present(vc, animated: true, completion: nil)
        } else if let roleID = Int(currentUser.booking_role_id), roleID == 1 || roleID == 2 || roleID == 3 {
            vc = storyboard!.instantiateViewController(withIdentifier: "BookingKathaVc") as! BookingKathaVc
            
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    var customDetent: UISheetPresentationController.Detent?
                    if #available(iOS 16.0, *) {
                        customDetent = UISheetPresentationController.Detent.custom { context in
                            return 560
                        }
                        sheet.detents = [customDetent!]
                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                    }
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 12
                }
            }
            present(vc, animated: true, completion: nil)
        }
    }
    
    func selectTypeApi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async {
            Loader.showLoader()
        }
        APIManager.apiCall(postData: dict as NSDictionary, url: AssignPeopleAPi) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }
            if let JSON = response as? NSDictionary,
               let status = JSON["status"] as? Bool, status == true {
                if let dataArray = JSON["data"] as? [[String: Any]],
                   let firstPerson = dataArray.first {
                    if let name = firstPerson["name"] as? String {
                        DispatchQueue.main.async {
                            self.AssignName.text = name
                        }
                    }
                    self.empCode = firstPerson["EmpCode"] as? String
                }
            } else {
                let errorMessage = (response?.validatedValue("message")) ?? "Something went wrong."
                AlertController.alert(message: errorMessage)
            }
        }
    }
    
    
    func printKathaDetails(name: String, channelName: String, venue: String, kathaDate: String, kathaFromDate: String, kathaTiming: String, gst: String, amount: String) {
        self.namelbl.text = name
        self.amntlbl.text = amount
        self.location.text = venue
        self.channellbl.text = channelName
        self.timelbl.text = kathaTiming
        self.datelbl.text = kathaFromDate + " " + "To" +  " " + kathaDate
    }
    
    func Suggestiondetails(SuggestionFromDate: String, SuggestiontoDate: String, SuggestionInTime: String, SuggestionOutTime: String, SuggestionRemark: String) {
        DispatchQueue.main.async {
            self.remarkLabel.text = SuggestionRemark
            self.TimeLabel.text = SuggestionInTime + " " + "To" + " " + SuggestionOutTime
            self.Datelabel.text = SuggestionFromDate + " " + "To" + " " + SuggestiontoDate
        }
    }
    
    @IBAction func approvebtn(_ sender: UIButton) {
        approveBooking()
        Mainview.isHidden = true
        tableview.reloadData()
    }
    @IBAction func rejectbtn(_ sender: UIButton) {
        rejectBooking()
    }
    @IBAction func suggestbtn(_ sender: UIButton) {
        SuggestionApi()
        Mainview.isHidden = true
    }
    @IBAction func filtersubmit(_ sender: UIButton) {
    }
    
    func SuggestionApi() {
        var dict = Dictionary<String, Any>()
        dict["katha_id"] = kathaId
        dict["EmpCode"]  = currentUser.EmpCode
        dict["status"]   = "3"
        dict["suggestion_time"] = starttime.text
        dict["suggestion_end_time"] = Endtime.text
        dict["suggestion_date"] = fromdate.text
        dict["suggestion_end_date"] = todate.text
        dict["Remarks"] = remarkstxt.text
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: hodBApprovalApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                DispatchQueue.main.async {
                    
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
    func FilterListApi() {
        self.datalist.removeAll()
        var dict = Dictionary<String, Any>()
        dict["EmpCode"]  = currentUser.EmpCode
        if KEY != nil
        {
            //      AlertController.alert(message: KEY ?? "0" )
            dict["value"]  = KEY
        }
        else
        {
            dict["value"]   = "-3"
        }
        
        
        if Range == "custom" {
            
            dict["start_date"] = Switchfromtxt.text
            dict["end_date"] = SwitchtoTxt.text
        } else {
            dict["start_date"] = ""
            dict["end_date"] = ""
        }
        
        //          dict["start_date"] = ""
        //          dict["end_date"] = ""
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: FilterListapi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if  let responseData = response, responseData["status"] as? Bool == true {
                if let JSON = responseData["data"] as? [[String: Any]] {
                    self.datalist = JSON
                    self.tableview.reloadData()
                    
                }
            } else {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                print(response?["error"] as Any)
            }
        }
        

    }
    func FilterSelectApi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"]  = currentUser.EmpCode
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: Filterselectapi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if  let responseData = response, responseData["status"] as? Bool == true {
                if let JSON = responseData["data"] as? [[String: Any]] {
                    self.filterData = JSON
                    //      AlertController.alert(message: (response?.validatedValue("message"))!)
                    DispatchQueue.main.async {
                        self.filterCollView.reloadData()
                    }
                }
            } else {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                print(response?["error"] as Any)
            }
            
        }
    }
    
    @IBAction func editsubmitbtn(_ sender: UIButton) {
        EditApi()
    }
    
    func EditApi() {
        var dict = Dictionary<String, Any>()
        dict["katha_id"] = kathaId
        dict["EmpCode"]  = currentUser.EmpCode
        dict["status"]   = "4"
        dict["suggestion_time"] = editstarttime.text
        dict["suggestion_end_time"] = editendtime.text
        dict["suggestion_date"] = editfromdate.text
        dict["suggestion_end_date"] = edittodate.text
        dict["Remarks"] = editreamrks.text
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: hodBApprovalApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                DispatchQueue.main.async {
                    
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
    func SelectKathaAssignApi() {
        var dict = Dictionary<String, Any>()
        dict["katha_id"]  = kathaIds
        dict["EmpCode"]   = currentUser.EmpCode
        dict["assign_to"] = empCode
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: SelectAssignapi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                    self.tableview.reloadData()
            } else {
                print(response?["error"] as Any)
            }
        }
    }
    
    @IBAction func fromdatebtn(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.fromdate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    @IBAction func todatebtn(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.todate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    
    @IBAction func editfrombtn(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.editfromdate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    @IBAction func edittodate(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.edittodate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    @IBAction func switchFrombtn(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.Switchfromtxt.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    @IBAction func Switchtobtn(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.SwitchtoTxt.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    
    @IBAction func canclebtn(_ sender: UIButton) {
        Mainview.isHidden = true
    }
    
    @IBAction func editcanclebtn(_ sender: UIButton) {
        editview.isHidden = true
    }
    
    @IBAction func secondviewcancle(_ sender: UIButton) {
        secondeyeview.isHidden = true
        
    }
    
    @IBAction func playercanclebtn(_ sender: UIButton) {
        playerview.isHidden = true
    }
    
    
    @IBAction func suggestionbtn(_ sender: UIButton) {
        suggestbtn.isHidden = false
        self.aprlbtn.isHidden = !self.aprlbtn.isHidden
        self.rejectbtn.isHidden = !self.rejectbtn.isHidden
        
        if suggestionimage.image == UIImage(named: "check") {
            suggestionimage.image = UIImage(named: "Uncheck")
        } else {
            suggestionimage.image = UIImage(named: "check")
        }
        self.suggestionview.isHidden = !self.suggestionview.isHidden
        
        if self.suggestionview.isHidden {
            suggestbtn.isHidden = true
            self.reason.constant = 4
        } else {
            let safeAreaInsetsTop = view.safeAreaInsets.top
            self.reason.constant = safeAreaInsetsTop + 120
            
        }
    }
    
    func approveBooking() {
        var dict = Dictionary<String, Any>()
        dict["katha_id"] = kathaIds
        dict["EmpCode"] = currentUser.EmpCode
        dict["status"] = "1"
        dict["salesEmpCode"] = SalesId
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: hodBApprovalApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                DispatchQueue.main.async {
                    
                }
                self.boookingApi()
                self.kathaIds.removeAll()
            } else {
                print(response?["error"] as Any)
            }
        }
    }
    func rejectBooking() {
        var dict = Dictionary<String, Any>()
        dict["katha_id"] = kathaId
        dict["EmpCode"] = currentUser.EmpCode
        dict["status"] = "2"
        dict["salesEmpCode"] = SalesId
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: hodBApprovalApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                DispatchQueue.main.async {
                    
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
    
    func boookingApi() {
        self.datalist.removeAll()
        var dict = Dictionary<String, Any>()
        dict["category_id"] = "2"
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: kathaApprovedApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                
                if let dataArray = responseData["data"] as? [[String: Any]] {
                    
                    self.datalist = dataArray
                    self.tableview.reloadData()
                }
            } else {
                //    AlertController.alert(message: (response?.validatedValue("message"))!)
                print(response?["error"] as Any)
            }
        }
    }
    
    func contentcompleteApi(kathaID: Int) {
        var dict = Dictionary<String, Any>()
        dict["katha_id"] = "\(kathaID)"
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: ContentCompleteApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                if let dataArray = responseData["data"] as? [[String: Any]] {
                    print(dataArray)
                    self.Viewlist = dataArray
                    self.secondtable.reloadData()
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
    
    func contentSubmitApi(status: Int, remarks: String?) {
        var dict = [String: Any]()
        dict["id"] = "\(PromoId)"
        dict["EmpCode"] = "\(currentUser.EmpCode)"
        dict["status"] = "\(status)"
        dict["Promo_type"] = "\(promotype)"
        if status == 2, let remarks = remarks {
            dict["Remarks"] = remarks
        }
        
        //        DispatchQueue.main.async {
        //            Loader.showLoader()
        //        }
        
        APIManager.apiCall(postData: dict as NSDictionary, url: ContentsubmitApi) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                if let dataArray = responseData["data"] as? [[String: Any]] {
                    AlertController.alert(message: (response?.validatedValue("message"))!)
                    // self.secondtable.reloadData()
                }
            } else {
                print(error)
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
        }
    }

    
    func bookingdetailapi() {
        var dict = Dictionary<String, Any>()
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: katha_booking_detailApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true {
                print(JSON)
                if let data = JSON["data"] as? [[String:Any]] {
                    print(data)
                    self.Datalist1 = data
                    print(self.Datalist1)
                    DispatchQueue.main.async {
                        
                    }
                }
            }  else {
                
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
        }
    }
    
    @objc func eyeviewcheckboxTapped(_ sender: UIButton) {
        let index = sender.tag
        let selectedRowData = datalist[index] 
        let kathaid = selectedRowData["Katha_id"] as? Int ?? 0
        let vc = storyboard?.instantiateViewController(withIdentifier: "scheduleVC") as! scheduleVC
        vc.kathaId = kathaid
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                var customDetent: UISheetPresentationController.Detent?
                if #available(iOS 16.0, *) {
                    customDetent = UISheetPresentationController.Detent.custom { context in
                        return 540
                    }
                    sheet.detents = [customDetent!]
                    sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                }
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 12
            }
        }
        present(vc, animated: true, completion: nil)

    }
    
    
    
    @objc func checkboxTapped(_ sender: UIButton) {
        
        eyesview.isHidden = false
        
        
        
        let index = sender.tag
        if index < datalist.count {
            
            let suggestionFromDate = datalist[index]["suggestion_date"] as? String ?? ""
            let suggestionToDate = datalist[index]["suggestion_end_date"] as? String ?? ""
            let suggestionInTime = datalist[index]["suggestion_time"] as? String ?? ""
            let suggestionOutTime = datalist[index]["suggestion_end_time"] as? String ?? ""
            let suggestionRemark = datalist[index]["Remarks"] as? String ?? ""
            
            Suggestiondetails(SuggestionFromDate: suggestionFromDate, SuggestiontoDate: suggestionToDate, SuggestionInTime: suggestionInTime, SuggestionOutTime: suggestionOutTime, SuggestionRemark: suggestionRemark)
        }
        
        
    }
    @objc func CheckboxTappedview(_ sender: UIButton) {
        let selectedKathaID = sender.tag
        contentcompleteApi(kathaID: selectedKathaID)
        secondeyeview.isHidden = false
        secondtable.isHidden = false
    }
    
    
    @objc func CheckBtnCheckboxTapped(_ sender: UIButton) {
        let row = sender.tag
        kathaIds.append(datalist[row]["Katha_id"] as? Int ?? 0)
        if selectedBookingRows.contains(row) {
            selectedBookingRows.remove(row)
            tableview.reloadData()
        } else {
            selectedBookingRows.insert(row)
            tableview.reloadData()
        }
        if selectedBookingRows.count == 1 {
            btn.isHidden = true
            labelbtn.isHidden = true
            assigntobtn.isHidden = false
        } else if selectedBookingRows.isEmpty {
            btn.isHidden = false
            labelbtn.isHidden = false
            assigntobtn.isHidden = true
        } else {
            btn.isHidden = true
            labelbtn.isHidden = true
            assigntobtn.isHidden = false
        }
        
        tableview.reloadData()
        
    }
    
    @objc func CheckboxTapped(_ sender: UIButton) {
        editview.isHidden = false
    }
    @objc func metatncheckboxTapped(_ sender: UIButton) {
        metaview.isHidden = false
    }
    
    
    @IBAction func metasubmitbtn(_ sender: UIButton) {
          let rowIndex = sender.tag
          let rowData = datalist[rowIndex]
          kathaID = rowData["kathaId"] as? Int ?? 0
          metaidApi()
    }
    
    @IBAction func metacancelbtn(_ sender: UIButton) {
        metaview.isHidden = true
    }
    
    func metaidApi() {
        var dict = Dictionary<String,Any>()
        dict["Katha_Id"] = "\(kathaID)"
        dict["EmpCode"] = currentUser.EmpCode
        dict["metaId"] = metaremarks.text!
       
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: CreateMetaApi) { result, response, error, data in
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
    
    @objc func QceyebtncheckboxTapped(_ sender: UIButton) {
        let buttonIndex = sender.tag
        guard let rowData = datalist[buttonIndex] as? [String: Any] else { return }
        let PromoUrl = rowData["url"] as? String ?? ""
        let promoType = rowData["promo_type"] as? String ?? ""
    
            let vc = storyboard!.instantiateViewController(withIdentifier: "videoplayerVC") as! videoplayerVC
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    if #available(iOS 16.0, *) {
                        let customDetent = UISheetPresentationController.Detent.custom { context in
                            return 540
                        }
                        sheet.detents = [customDetent]
                        sheet.largestUndimmedDetentIdentifier = customDetent.identifier
                    }
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 12
                }
            }
            vc.promo = PromoUrl
            self.present(vc, animated: true)
    }
    
    
    @objc func rejectCheckboxTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if let cell = secondtable.cellForRow(at: indexPath) as? DetailsEmployCell {
            let remarks = cell.txtRemarkView.text ?? ""
            
            //            if remarks.isEmpty {
            //                // Show an alert if remarks are mandatory
            //                showAlert(message: "Please enter remarks before rejecting.")
            //                return
            //            }
            cell.txtRemarkView.isHidden = true  // Accessing txtRemarkView from cell
            cell.okbtn.isHidden = true
            contentSubmitApi(status: 2, remarks: remarks)
        }
    }
    
    @objc func ApproveCheckboxTapped(_ sender: UIButton) {
        contentSubmitApi(status: 1, remarks: "")
    }
    
    
    @objc func viewbuttontapped(_ sender: UIButton) {
        let buttonIndex = sender.tag
        guard let rowData = Viewlist[buttonIndex] as? [String: Any] else { return }
        let PromoUrl = rowData["url"] as? String ?? ""
        let promoType = rowData["Promo_type"] as? String ?? ""
        if promoType == "1" {
            let vc = storyboard!.instantiateViewController(withIdentifier: "videoplayerVC") as! videoplayerVC
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    if #available(iOS 16.0, *) {
                        let customDetent = UISheetPresentationController.Detent.custom { context in
                            return 540
                        }
                        sheet.detents = [customDetent]
                        sheet.largestUndimmedDetentIdentifier = customDetent.identifier
                    }
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 12
                }
            }
            vc.promo = PromoUrl
            self.present(vc, animated: true)
        } else {
                playerview.isHidden = false
                playerimageview.sd_setImage(with: URL(string: PromoUrl))
         
        }
    }
    
    
    
    @IBAction func eyesexitbtn(_ sender: UIButton) {
        eyesview.isHidden = true
    }
    
    func receptionbookAPi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: receptionbookingListAPi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                if let dataArray = responseData["data"] as? [[String: Any]] {
                    self.DataList = dataArray
                    self.tableview.reloadData()
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
    
}
extension BookingPageVc: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableview {
            if let roleID = Int(currentUser.booking_role_id) {
                if roleID == 1 || roleID == 2 || roleID == 3 || roleID == 5 || roleID == 8 || roleID == 7 || roleID == 9 || roleID == 10 {
                    return self.datalist.count
                } else if roleID == 4 {
                    return datalist.count
                }
            }
        } else if tableView == secondtable {
            if let roleID = Int(currentUser.booking_role_id) {
                if roleID == 5 {
                    return Viewlist.count
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let roleID = Int(currentUser.booking_role_id) else { return UITableViewCell() }
        if tableView == tableview {
            if roleID == 4 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ReceptionListCell", for: indexPath) as? ReceptionListCell {
                    let index = datalist[indexPath.row]
                    cell.namelbl.text = datalist[indexPath.row]["caller_name"] as? String ?? ""
                    cell.citylbl.text = "\(index["location"] as? String ?? "")"
                    cell.assignlbl.text = "\(index["sales_person_name"] as? String ?? "")"
                    cell.remarkslbl.text = "\(index["remarks"] as? String ?? "")"
                    cell.contactlbl.text = "\(index["caller_mobile"] as? String ?? "")"
                    return cell
                }
            }  else if roleID == 1 || roleID == 2 || roleID == 3 || roleID == 5 || roleID == 8 || roleID == 7 || roleID == 10  {
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "BookingPageCell", for: indexPath) as? BookingPageCell {
                    if  let rowData = datalist[indexPath.row] as? [String: Any] {
                        cell.NameLabel.text = rowData["Name"] as? String ?? ""
                      
                        cell.GSTLabel.text = rowData["GST"] as? String ?? ""
                        cell.VenueLabel.text = rowData["Venue"] as? String ?? ""
                        cell.ChennelLabel.text = rowData["ChannelName"] as? String ?? ""
                        cell.DateromLabel.text = " \(rowData["Katha_from_Date"] as? String ?? "") to \(rowData["Katha_date"] as? String ?? "")"
                        
                        if roleID == 10 {
                            cell.AMountLabel.text = rowData["Meta_Id"] as? String ?? ""
                        } else  {
                            cell.AMountLabel.text = rowData["Amount"] as? String ?? ""
                        }
                      
                       kathaid = rowData["katha_id"] as? Int ?? 0
                   
                        let status = rowData["Status"] as? String ?? ""
                        cell.statsulbl.text = status
                        if status == "Suggestion" {
                            cell.eyebtn.isHidden = false
                            cell.editbtn.isHidden = false
                            cell.dialbtn.isHidden = false
                            cell.forwardimage.isHidden = true
                        } else {
                            cell.eyebtn.isHidden = true
                            cell.editbtn.isHidden = true
                            cell.dialbtn.isHidden = true
                            cell.forwardimage.isHidden = false
                        }
                        if status == "Content Complete" {
                            cell.eyebtn.isHidden = false
                        } else {
                            cell.eyebtn.isHidden = true
                        }
                        if roleID == 2  {
                            cell.typeslbl.isHidden = false
                            cell.Type1Lbl.isHidden = false
                            cell.typeslbl.text = rowData["Promo_Name"] as? String ?? ""
                            cell.forwardimage.isHidden = true
                        } else {
                            cell.typeslbl.isHidden = true
                            cell.Type1Lbl.isHidden = true
                            cell.forwardimage.isHidden = false
                        }
                    
                        
                        if roleID == 8 || roleID == 7 || roleID == 10  {
                            cell.eyeview.isHidden = false
                       //     cell.AMountLabel.isHidden = true
                            cell.GSTLabel.isHidden = true
                            cell.gstlbl.isHidden = true
                            
                            if roleID == 10 {
                                cell.Mainamount.text = "MetaId"
                            }
                        } else {
                            cell.eyeview.isHidden = true
                            cell.AMountLabel.isHidden = false
                            cell.GSTLabel.isHidden = false
                            cell.gstlbl.isHidden = false
                        }

                        if status == "Assign to Hod" {
                            cell.statsulbl.textColor = UIColor.purple
                        } else if status != "Suggestion" {
                            cell.statsulbl.text = status
                            cell.statsulbl.textColor = UIColor.black
                        } else {
                            cell.statsulbl.textColor = UIColor.clear
                        }
                        if switchpermisssion.isOn {
                            cell.checkbtn.isHidden = false
                            cell.forwardimage.isHidden = selectedBookingRows.contains(indexPath.row)
                        } else {
                            cell.checkbtn.isHidden = true
                            cell.forwardimage.isHidden = false
                        }
                        let checkImageName = selectedBookingRows.contains(indexPath.row) ? "check" : ""
                        cell.checkbtn.setImage(UIImage(named: checkImageName), for: .normal)
                        
                        cell.checkbtn.tag = indexPath.row
                        cell.checkbtn.addTarget(self, action: #selector(CheckBtnCheckboxTapped(_:)), for: .touchUpInside)
                        cell.eyebtn.tag = indexPath.row
                        if roleID == 3 {
                            cell.eyebtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
                        } else if roleID == 5 {
                            cell.eyebtn.tag = kathaid
                            cell.eyebtn.addTarget(self, action: #selector(CheckboxTappedview(_:)), for: .touchUpInside)
                        }
                        cell.eyeview.tag = indexPath.row
                        cell.eyeview.addTarget(self, action: #selector(eyeviewcheckboxTapped(_:)), for: .touchUpInside)
                       
                        
                        cell.editbtn.tag = indexPath.row
                        cell.editbtn.addTarget(self, action: #selector(CheckboxTapped(_:)), for: .touchUpInside)
                        if let kathaTiming = rowData["SlotTiming"] as? String, !kathaTiming.isEmpty {
                            cell.TimeLabel.text = kathaTiming
                        } else {
                            cell.TimeLabel.text = rowData["KathaTiming"] as? String ?? ""
                        }
                        return cell
                    }
                }
            } else if  roleID == 9 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "QcMetaCell", for: indexPath) as? QcMetaCell {
                    let rowData = datalist[indexPath.row]
                    cell.Date.text = " \(rowData["Katha_from_Date"] as? String ?? "") to \(rowData["Katha_date"] as? String ?? "")"
                   kathaID = rowData["kathaId"] as? Int ?? 0
                    
                    cell.Venue.text = rowData["Venue"] as? String ?? ""
                    cell.Name.text = rowData["name"] as? String ?? ""
                    cell.Channel.text = rowData["ChannelName"] as? String ?? ""
                    cell.Promo.text = rowData["Type_name"] as? String ?? ""
                    cell.Time.text = rowData["KathaTiming"] as? String ?? ""
                    
                    cell.eyebtn.tag = indexPath.row
                    cell.eyebtn.addTarget(self, action: #selector(QceyebtncheckboxTapped(_:)), for: .touchUpInside)
                    cell.metaidbtn.tag = indexPath.row
                    cell.metaidbtn.addTarget(self, action: #selector(metatncheckboxTapped(_:)), for: .touchUpInside)
                    return cell
                }
            }
        } else if tableView == secondtable {
            if roleID == 5 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DetailsEmployCell {
                    if  let rowData = Viewlist[indexPath.row] as? [String: Any] {
                        cell.configure(with: rowData)
                        PromoId =  rowData["id"] as? Int ?? 0
                        promotype = rowData["Promo_type"] as? String ?? ""
//                        PromoUrl =  rowData["url"] as? String ?? ""
                        cell.okbtn.tag = indexPath.row
                        cell.okbtn.addTarget(self, action: #selector(rejectCheckboxTapped(_:)), for: .touchUpInside)
                        cell.btnAprove.tag = indexPath.row
                        cell.btnAprove.addTarget(self, action: #selector(ApproveCheckboxTapped(_:)), for: .touchUpInside)
                        cell.btnViewContent.tag = indexPath.row
                        cell.btnViewContent.addTarget(self, action: #selector(viewbuttontapped(_:)), for: .touchUpInside)
                    }
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let roleID = Int(currentUser.booking_role_id) else { return 200 }
        if tableView == self.tableview {
            if roleID == 4 {
                return 165
            } else if roleID == 3 || roleID == 5  || roleID == 1 || roleID == 8 || roleID == 7 || roleID == 10  {
                return 200
            } else if roleID == 2 {
                return 240
            }  else if roleID == 9 {
                return 170
            }
        }
        return UITableView.automaticDimension
     
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = datalist[indexPath.row]["Name"] as? String ?? ""
        let channelName = datalist[indexPath.row]["ChannelName"] as? String ?? ""
        let venue = datalist[indexPath.row]["Venue"] as? String ?? ""
        let kathaDate = datalist[indexPath.row]["Katha_date"] as? String ?? ""
        let kathaFromDate = datalist[indexPath.row]["Katha_from_Date"] as? String ?? ""
        let kathaTiming = datalist[indexPath.row]["KathaTiming"] as? String ?? ""
        let gst = datalist[indexPath.row]["GST"] as? String ?? ""
        let amount = datalist[indexPath.row]["Amount"] as? String ?? ""
        let id = datalist[indexPath.row]["Katha_id"] as? Int ?? 0
        kathaIds.append(id)
        SalesId = datalist[indexPath.row]["salesEmpCode"] as? String ?? ""
        printKathaDetails(name: name, channelName: channelName, venue: venue, kathaDate: kathaDate, kathaFromDate: kathaFromDate, kathaTiming: kathaTiming, gst: gst, amount: amount)
        let permission = datalist[indexPath.row]["permission"] as? Int ?? 0
        switch permission {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
            return
        case 1:
            approveview.isHidden = false
            Mainview.isHidden = false
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: "ClientDetailVC") as! ClientDetailVC
            vc.Datalist = datalist[indexPath.row]
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    var customDetent: UISheetPresentationController.Detent?
                    if #available(iOS 16.0, *) {
                        customDetent = UISheetPresentationController.Detent.custom { context in
                            return 560
                        }
                        sheet.detents = [customDetent!]
                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                    }
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 12
                }
            }
            present(vc, animated: true, completion: nil)
        case 3:
            approveview.isHidden = true
            Mainview.isHidden = true
        case 4:
            let vc = storyboard?.instantiateViewController(withIdentifier: "KathaAssignVc") as! KathaAssignVc
            vc.Datalist = datalist[indexPath.row]
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController {
                    var customDetent: UISheetPresentationController.Detent?
                    if #available(iOS 16.0, *) {
                        customDetent = UISheetPresentationController.Detent.custom { context in
                            return 540
                        }
                        sheet.detents = [customDetent!]
                        sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                    }
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 12
                }
            }
            present(vc, animated: true, completion: nil)
        default:
            print("Unhandled permission value: \(permission)")
        }
    }
}

extension BookingPageVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = filterCollView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath)  as? KathaFilterCell else {
            return UICollectionViewCell()
        }
        let Range = filterData[indexPath.row]["date_range"] as? String ?? ""
        cell.collectionLabel.text = Range
        let KEY = filterData[indexPath.row]["key"] as? Int ?? 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let value = filterData[indexPath.row]["key"] as? Int ?? 0
        KEY = String(value)
        Range = filterData[indexPath.row]["date_range"] as? String ?? ""
        if Range == "custom" {
            switchview.isHidden = false
        } else {
            switchview.isHidden = true
        }
        //       AlertController.alert(message: KEY ?? "0" )
        FilterListApi()
        filterCollView.isHidden = true
    }
}
extension BookingPageVc : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (metaremarks.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if metaremarks.textColor == UIColor.lightGray {
            metaremarks.text = ""
            metaremarks.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if metaremarks.text == "" {

            metaremarks.text = "Remark ..."
            metaremarks.textColor = UIColor.lightGray
        }
    }
}
