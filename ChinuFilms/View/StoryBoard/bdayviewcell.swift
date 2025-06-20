//
//  bdayviewcell.swift
//  SanskarEP
//
//  Created by Surya on 01/09/23.
//

import UIKit

class bdayviewcell: UITableViewCell {
    

    @IBOutlet weak var MyLbl: UILabel!
    @IBOutlet weak var MyLbl2: UILabel!
    @IBOutlet weak var MyImage: UIImageView!
    @IBOutlet weak var msgbtn: UIButton!
    @IBOutlet weak var mylbl3: UILabel!
    @IBOutlet weak var terminatedbtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        
        msgbtn.layer.cornerRadius = 8
        
        terminatedbtn.layer.cornerRadius = 5
        terminatedbtn.clipsToBounds = true
        
        MyImage.layer.borderWidth = 1.0
        MyImage.layer.borderColor = UIColor.black.cgColor
        MyImage.layer.cornerRadius = 5.0 // Optional: If you want rounded corners
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
