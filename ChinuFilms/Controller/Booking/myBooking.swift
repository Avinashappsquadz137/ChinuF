//
//  myBooking.swift
//  SanskarEP
//
//  Created by Warln on 11/03/22.
//

import UIKit
import Alamofire

class myBooking: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLbL: UILabel!
    var appDel:AppDelegate? = nil
    
    var startD: String?
    var endD: String?
    var typ: String?
    var channel: String?
    var roData: ROData?
    var titleTxt: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDel = (UIApplication.shared.delegate as! AppDelegate)
        tableView.dataSource = self
        tableView.delegate = self
        setup()
    }
    
    func setup() {
        tableView.register(UINib(nibName: "BookingData", bundle: nil), forCellReuseIdentifier: "BookingData")
        tableView.estimatedRowHeight = 150
        headerLbL.text = titleTxt
        myBookingApi()
    }
    
    func myBookingApi(){
        
        var dictParam:Dictionary<String,String> = Dictionary<String,String>()
        
        dictParam["start_dt"] = ""
        dictParam["end_dt"] = ""
        dictParam["typ"] = "M"
        dictParam["channel"] = ""
        dictParam["created_by"] = currentUser.EmpCode
        
        print("login Param:",dictParam)
        
        
        let loginApi = WebServiceOperation.init("http://bms.sanskargroup.in/sans-api/rest/apiServices/getMBLRODetail", dictParam as Dictionary<String, AnyObject>, WebServiceOperation.WEB_SERVICE.WEB_SERVICE_POST)
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
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode(ROData.self, from: JSONSerialization.data(withJSONObject: dictResponse, options: JSONSerialization.WritingOptions.prettyPrinted))
                        self.roData = jsonData
                        DispatchQueue.main.async(execute: {
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
    
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension myBooking: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roData?.roDetails.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookingData", for: indexPath) as? BookingData else {
            return UITableViewCell()
        }
        let index = indexPath.row
        if let data = roData?.roDetails[index]{
            cell.setData(body: data)
        }
        cell.acceptBtn.isHidden = true
        cell.rejectBtn.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
}

extension myBooking: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

