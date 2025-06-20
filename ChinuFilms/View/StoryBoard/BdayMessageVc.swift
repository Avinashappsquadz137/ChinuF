//
//  BdayMessageVc.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 29/06/23.
//

import UIKit

class BdayMessageVc: UIViewController {
    @IBOutlet var Btext: UITextField!
    
    @IBOutlet var SubmitButton: UIButton!
    
    @IBOutlet var ImageP: UIImageView!
    @IBOutlet weak var Pview: UIView!
    @IBOutlet weak var BView: UIView!
    @IBOutlet weak var BdayMessage: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    
    var datal = [[String:Any]]()
    var imaged = String()
    var message = String()
    var EmpCode = String()
    var sent_bycode = String()
    var imageurl1 = "https://ep.sanskargroup.in/uploads/"
  //  "https://employee.sanskargroup.in/EmpImage/"
    
    var empname = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Pview.layer.cornerRadius = 15
        Pview.clipsToBounds = true
        BView.layer.borderWidth = 1.0
        BView.layer.cornerRadius = 15
        BView.clipsToBounds = true
        
        BdayMessage.text = message
        name.text = empname
        
        print(sent_bycode)
        let img = imaged.replacingOccurrences(of: " ", with: "%20")
        print(img)
        ImageP.sd_setImage(with: URL(string: img))
        
        ImageP.layer.borderWidth = 1.0
        ImageP.layer.borderColor = UIColor.black.cgColor
        ImageP.layer.cornerRadius = 5.0 // Optional: If you want rounded corners
        BdayMessage.numberOfLines = 0
        BdayMessage.lineBreakMode = .byWordWrapping
       // BdayMessage.layer.borderWidth = 1.0
    }
    
    func removeData() {
        Btext.text?.removeAll()
    }

    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true , completion: nil)
    }
    func WishApi() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = sent_bycode
        print(dict["EmpCode"])
        dict["Msg"] = Btext.text!
        print(dict["Msg"]!)
        print(EmpCode)
        dict["FromEmpCode"] = currentUser.EmpCode
        print(dict["FromEmpCode"]!)
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: rbdayApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                 //   print(JSON)
                    AlertController.alert(message: JSON.value(forKey: "message") as! String)
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                 //   self.dismiss(animated: true, completion: nil)
                    
                }
                
            }
            
            
        }
    }
    
    @IBAction func WishButton(_ sender: Any) {
        WishApi()
        removeData()
     
    }
}
