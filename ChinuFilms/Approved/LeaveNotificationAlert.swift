//
//  LeaveNotificationAlert.swift
//  SanskarEP
//
//  Created by Vaibhav on 18/02/25.
//

import UIKit


protocol LeaveRequestDelegate {
    func FetchRequest(_ status: Bool, _ noteId: String)
}

class LeaveNotificationAlert: UIViewController {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var Namelbl: UILabel!
    @IBOutlet weak var typelbl: UILabel!
    @IBOutlet weak var Acceptbtn: UIButton!
    @IBOutlet weak var Rejectbtn: UIButton!
    @IBOutlet weak var Remarkstext: UITextView!
    @IBOutlet weak var Headerview: UIView!
    @IBOutlet weak var viewtop: NSLayoutConstraint!
    @IBOutlet weak var datelbl: UILabel!
    
    
    var imgName: String?
    var nameTxt: String?
    
    var type: String?
    var reqid: Int?
    var leavetype: String?
    var date: String?
    
    var userInfo: [String: Any]?
    
    var delegate: LeaveRequestDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Headerview.layer.cornerRadius = 5
        Headerview.clipsToBounds = true
        Remarkstext.isHidden = true
        Remarkstext.delegate = self
        
        Remarkstext.layer.cornerRadius = 10
        Acceptbtn.layer.cornerRadius = 10
        Rejectbtn.layer.cornerRadius = 10
        
        Remarkstext.clipsToBounds = true
        Remarkstext.layer.borderWidth = 1.0
        Remarkstext.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        if let userInfo = userInfo as? [String: Any] {
            print("Full userInfo: \(userInfo)")
            
            if let data = userInfo["data"] as? [String: Any] {
                print("Extracted data: \(data)")
                
                if let requestId = data["req_id"] as? Int {
                    self.reqid = requestId
                }
                
                if let notificamtionType = data["notification_type"] as? String {
                    self.type = notificamtionType
                } else {
                    print("⚠️ 'notification_type' is nil or not an Int")
                }
            }
        }
        
        setdetail()
    }
    
    
    func setdetail() {
        if let data = userInfo?["data"] as? [String: Any] {
            Namelbl.text = data["notification_content"] as? String ?? nameTxt
            typelbl.text = data["notification_title"] as? String ?? leavetype
            datelbl.text = data["creation_date"] as? String ?? date
            
            if let imgUrl = data["img"] as? String, let url = URL(string: imgUrl) {
                imageview.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(systemName: "person.fill"),
                    options: .refreshCached,
                    completed: nil
                )
            } else if let localImg = imgName, let url = URL(string: localImg) {
                imageview.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.fill"))
            }
        } else {
            Namelbl.text = nameTxt
            typelbl.text = leavetype
            datelbl.text = date
            
            if let localImg = imgName, let url = URL(string: localImg) {
                imageview.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.fill"))
            }
        }
    }
    
    @IBAction func canclebtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func Acceptonclick(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func RejectOnclick(_ sender: UIButton) {
        if Remarkstext.isHidden {
            Remarkstext.isHidden = false
            viewtop.constant = 60
            sender.setTitle("Send", for: .normal)
            sender.backgroundColor = UIColor.blue
        } else {
            Remarkstext.isHidden = true
            viewtop.constant = 5
            sender.setTitle("Reject", for: .normal)
            sender.backgroundColor = UIColor(red: 187/255, green: 45/255, blue: 59/255, alpha: 1.0)
           
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
extension LeaveNotificationAlert : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (Remarkstext.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if Remarkstext.textColor == UIColor.lightGray {
            Remarkstext.text = ""
            Remarkstext.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if Remarkstext.text == "" {

            Remarkstext.text = "Remark ..."
            Remarkstext.textColor = UIColor.lightGray
        }
    }
}
