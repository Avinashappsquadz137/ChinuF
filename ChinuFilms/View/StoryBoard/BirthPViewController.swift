//
//  BirthPViewController.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 22/05/23.
//

protocol BirthPViewControllerDelegate: AnyObject {
    func didFinishWishing()
}
import UIKit

class BirthPViewController: UIViewController {
    
    @IBOutlet var Btext: UITextField!
    @IBOutlet var SubmitButton: UIButton!
    @IBOutlet var ImageP: UIImageView!
    @IBOutlet weak var Pview: UIView!
    @IBOutlet weak var CView: UIView!
    @IBOutlet weak var wish2: UILabel!
    @IBOutlet weak var wish3: UILabel!
    @IBOutlet weak var wish4: UILabel!
    @IBOutlet weak var wish1: UILabel!
    
    weak var delegate: BirthPViewControllerDelegate?
    var datal = [[String:Any]]()
    var imaged = String()
    var empCode = String()
    var imageurl1 = "https://ep.sanskargroup.in/uploads/"
    //"https://employee.sanskargroup.in/EmpImage/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        if imaged.isEmpty {
            ImageP.image = UIImage(named: "download")
        } else {
            let img = imaged.replacingOccurrences(of: " ", with: "%20")
            ImageP.sd_setImage(with: URL(string:  img))
        }
        
        Pview.layer.cornerRadius = 15
        CView.layer.borderWidth = 1.0
        CView.layer.cornerRadius = 15
        Pview.clipsToBounds = true
        
        ImageP.layer.borderWidth = 1.0
        ImageP.layer.borderColor = UIColor.black.cgColor
        ImageP.layer.cornerRadius = 5.0
        
            let cornerRadius: CGFloat = 6.0
            let borderWidth: CGFloat = 1.0
            let borderColor = UIColor.gray.cgColor
            
            // Round corners and add border to wish1 label
            wish1.layer.cornerRadius = cornerRadius
        //    wish1.layer.borderWidth = borderWidth
         //   wish1.layer.borderColor = borderColor
            
            // Round corners and add border to wish2 label
            wish2.layer.cornerRadius = cornerRadius
        //    wish2.layer.borderWidth = borderWidth
        //    wish2.layer.borderColor = borderColor
            
            // Round corners and add border to wish3 label
            wish3.layer.cornerRadius = cornerRadius
        //    wish3.layer.borderWidth = borderWidth
       //     wish3.layer.borderColor = borderColor
            
            // Round corners and add border to wish4 label
            wish4.layer.cornerRadius = cornerRadius
       //     wish4.layer.borderWidth = borderWidth
      //      wish4.layer.borderColor = borderColor
        
               addTapGesture(to: wish1)
               addTapGesture(to: wish2)
               addTapGesture(to: wish3)
               addTapGesture(to: wish4)
    
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    func addTapGesture(to label: UILabel) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(tapGesture)
        }
        
      
        @objc func labelTapped(_ sender: UITapGestureRecognizer) {
            guard let label = sender.view as? UILabel else { return }
          
            Btext.text = label.text
        }
    
    func WishApi() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = empCode
        dict["Message"] = Btext.text!
        dict["Sent_by"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: bwishApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    AlertController.alert(message: JSON.value(forKey: "message") as! String)
                    self.delegate?.didFinishWishing()
                    self.dismiss(animated: true, completion: nil)
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                }
            }
        }
    }

    
    @IBAction func WishButton(_ sender: Any) {
        WishApi()
       
    }
    
}
