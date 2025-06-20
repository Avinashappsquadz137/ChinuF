//
//  submitBook.swift
//  SanskarEP
//
//  Created by Warln on 10/03/22.
//

import UIKit

protocol GetStatus{
    func getStatus(_ state: Bool )
}

class submitBook: UIViewController {
    
    @IBOutlet weak var programLbl: UILabel!
    @IBOutlet weak var clientLbl: UILabel!
    @IBOutlet weak var fromDLbl: UILabel!
    @IBOutlet weak var toDLbl: UILabel!
    @IBOutlet weak var fromTimeLbl: UILabel!
    @IBOutlet weak var toTimeLbl: UILabel!
    @IBOutlet weak var channelLbl: UILabel!
    @IBOutlet weak var showLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!

    
    
    var appDel:AppDelegate? = nil
    var progTxt: String?
    var fromdate: String?
    var toDate: String?
    var fromTime: String?
    var toTime: String?
    var channelTxt: String?
    var locate: String?
    var totalText: String?
    var name: String?
    var total: String?
    var gst: Bool?
    var confirm: Bool?
    var prop: Bool?
    var id: String?
    var ptype: String?
    var gstType: String?
    var conType: String?
    var delegate: GetStatus?
    var titleText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDel = (UIApplication.shared.delegate as! AppDelegate)
        setup()
    }
    
    func setup() {
        programLbl.text = "Program Type:- \(progTxt ?? "") "
        clientLbl.text = "Client Name:- \(name ?? "")"
        fromDLbl.text = "From Date:- \(fromdate ?? "")"
        toDLbl.text = "To Date:- \(toDate ?? "")"
        fromTimeLbl.text = "From Time:- \(fromTime ?? "")"
        toTimeLbl.text = "To Time:- \(toTime ?? "")"
        channelLbl.text = "Channel Name:- \(channelTxt ?? "")"
        showLbl.text = "Show Location:- \(locate ?? "")"
        headerLbl.text = titleText
        if gst == true {
            gstType = "Y"
            totalLbl.text = "Total Amount:- \(total ?? "") Gst Extra"
        }else{
            gstType = "N"
            totalLbl.text = "Total Amount:- \(total ?? "") Gst Include"
        }
        
        if progTxt == "Katha" {
            ptype = "K"
        }else{
            ptype = "S"
        }
        if confirm == true {
            conType = "C"
        }else if prop == true {
            conType = "P"
        }else{
            conType = ""
        }
        
    }
    
    @IBAction func submtBtnPressed(_ sender: UIButton) {
        myBookingApi()
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
    func myBookingApi(){
        
        var dictParam:Dictionary<String,String> = Dictionary<String,String>()
        
        dictParam["booking_dt"] = Date().dateToString()
        dictParam["channel"] = channelTxt
        dictParam["prog_type"] = ptype
        dictParam["sant_code"] = id
        dictParam["start_dt"] = fromdate
        dictParam["end_dt"] = toDate
        dictParam["start_time"] = fromTime
        dictParam["end_time"] = toTime
        dictParam["katha_loct"] = locate
        dictParam["booking_amt"] = total
        dictParam["incl_gst"] = gstType
        dictParam["created_by"] = currentUser.EmpCode
        dictParam["created_ip"] = currentUser.CntNo
        dictParam["status"] = conType
        dictParam["sant_name"] = name ?? ""
        dictParam["emp_name"] = currentUser.Name
        
        
        let loginApi = WebServiceOperation.init("http://bms.sanskargroup.in/sans-api/rest/apiServices/insRO", dictParam as Dictionary<String, AnyObject>, WebServiceOperation.WEB_SERVICE.WEB_SERVICE_POST)
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
                        AlertController.alert(title: "My Booking", message: "Your record saved successfully", acceptMessage: "ok") {
                            self.delegate?.getStatus(true)
                            self.dismiss(animated: false, completion: nil)
                        }
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

}


