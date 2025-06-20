//
//  ReceptionListCell.swift
//  SanskarEP
//
//  Created by Surya on 26/09/24.
//

import UIKit

class ReceptionListCell: UITableViewCell {
    
    
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var contactlbl: UILabel!
    @IBOutlet weak var citylbl: UILabel!
    @IBOutlet weak var assignlbl: UILabel!
    @IBOutlet weak var remarkslbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contactlbl.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(phoneNumberTapped))
        contactlbl.addGestureRecognizer(tapGesture)

    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    @objc func phoneNumberTapped() {
          if let phoneNumber = contactlbl.text {
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
