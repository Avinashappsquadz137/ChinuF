//
//  NewLeaveCancel.swift
//  SanskarEP
//
//  Created by Surya on 08/01/25.
//

import UIKit

class NewLeaveCancel: UIViewController {
  
    
@IBOutlet weak var tableview: UITableView!
@IBOutlet weak var mainview: UIView!
@IBOutlet weak var remarkstext: UITextView!
@IBOutlet weak var approvebtn: UIButton!
@IBOutlet weak var rejectbtn: UIButton!
    
    
    var DetailData = [[String:Any]]()
    var reqid = String()
    var empcode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CancelStatusAPi()
        tableview.register(UINib(nibName: "statusTableViewCell", bundle: nil), forCellReuseIdentifier: "statusTableViewCell")
        mainview.isHidden = true
        approvebtn.layer.cornerRadius = 8
        rejectbtn.layer.cornerRadius = 8
        
        remarkstext.delegate = self
        remarkstext.layer.cornerRadius = 10
        remarkstext.clipsToBounds = true
     
        remarkstext.textColor = UIColor.lightGray
        remarkstext.layer.borderWidth = 1

    }
    
    @objc func Checkboxtapped(_ sender: UIButton) {
        self.mainview.isHidden = !self.mainview.isHidden
    }
    
    func CancelStatusAPi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: cancelstatus) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if  let responseData = response, responseData["status"] as? Bool == true {
                if let JSON = responseData["data"] as? [[String: Any]] {
                    self.DetailData = JSON
                    DispatchQueue.main.async {
                      
                    }
                    self.tableview.reloadData()
                }
            } else {
                AlertController.alert(message: (response?.validatedValue("message"))!)
                print(response?["error"] as Any)
            }
            
        }
    }
   
    @IBAction func clearbtn(_ sender: UIButton) {
        mainview.isHidden = true
    }
    
    @IBAction func approvebtn(_ sender: UIButton) {
        
    }
    
    @IBAction func rejectnbtn(_ sender: UIButton) {
    }
    
    
}

extension NewLeaveCancel: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "statusTableViewCell", for: indexPath) as? statusTableViewCell else {
            return UITableViewCell()
        }
        
        let rowData = DetailData[indexPath.row]
     
        reqid = rowData["name"] as? String ?? ""
        empcode = rowData["EmpCode"] as? String ?? ""
        
        cell.reqId.text = reqid + " " + "(" + empcode + ")"
        
        cell.fromdate.text = rowData["from_date"] as? String ?? ""
        cell.todate.text = rowData["to_date"] as? String ?? ""
       
        cell.status.text = rowData["Hr_Approval_Status"] as? String ?? ""
        
        cell.cancelbtn.tag = indexPath.row
        cell.cancelbtn.addTarget(self, action: #selector(Checkboxtapped(_:)), for: .touchUpInside)
        cell.reasonlbl.text = rowData["reason"] as? String ?? ""
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(messageLabelTapped(_:)))
        cell.reasonlbl.addGestureRecognizer(tapGesture)
        cell.reasonlbl.isUserInteractionEnabled = true
        
        return cell
        
    }
    @objc func messageLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel, let message = label.text else {
            return
        }
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension NewLeaveCancel : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (remarkstext.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if remarkstext.textColor == UIColor.lightGray {
            remarkstext.text = ""
            remarkstext.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if remarkstext.text == "" {

            remarkstext.text = ""
            remarkstext.textColor = UIColor.black
        }
    }
}
