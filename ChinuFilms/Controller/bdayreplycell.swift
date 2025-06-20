//
//  bdayreplycell.swift
//  SanskarEP
//
//  Created by Surya on 01/09/23.
//

import UIKit

class bdayreplycell: UITableViewCell {
    

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblmsg: UILabel!
    @IBOutlet weak var reply: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        reply.layer.cornerRadius = 5
        reply.clipsToBounds = true
        reply.layer.borderColor = UIColor.black.cgColor
        
        imageview.layer.borderWidth = 1.0
        imageview.layer.borderColor = UIColor.black.cgColor
        imageview.layer.cornerRadius = 5.0 // Optional: If you want rounded corners
    }
   
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
