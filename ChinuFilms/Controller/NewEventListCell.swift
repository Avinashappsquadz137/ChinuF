//
//  NewEventListCell.swift
//  SanskarEP
//
//  Created by Surya on 25/11/24.
//

import UIKit

class NewEventListCell: UITableViewCell {
    
    
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var TypeLbl: UILabel!
    @IBOutlet weak var eventbtn: UIButton!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var colorlbl: UILabel!
    @IBOutlet weak var viewbtn: UIButton!
    @IBOutlet weak var Datelbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewbtn.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
