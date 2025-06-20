//
//  RequestCell.swift
//  SanskarEP
//
//  Created by Surya on 03/10/24.
//

import UIKit

class RequestCell: UITableViewCell {
    

    @IBOutlet weak var newbookingbtn: UIButton!
    @IBOutlet weak var callerName: UILabel!
    @IBOutlet weak var CallerContact: UILabel!
    @IBOutlet weak var Venue: UILabel!
    @IBOutlet weak var remarks: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var callbtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newbookingbtn.layer.cornerRadius = 8
        
        callbtn.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(phoneNumberTapped))
        callbtn.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    @objc func phoneNumberTapped() {
        if let phoneNumber = callbtn.title(for: .normal) {  
            if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
                if UIApplication.shared.canOpenURL(phoneCallURL) {
                    UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    print("Calling is not supported on this device.")
                }
            }
        }
    }

}
