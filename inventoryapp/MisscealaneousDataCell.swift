//
//  MisscealaneousDataCell.swift
//  SanskarEP
//
//  Created by Surya on 28/08/24.
//

import UIKit

class MisscealaneousDataCell: UITableViewCell {
    
    @IBOutlet weak var mainview:UIView!
    @IBOutlet weak var itemnamelbl:UILabel!
    @IBOutlet weak var itemQuantitylbl:UILabel!
    @IBOutlet weak var deletebtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainview.layer.cornerRadius = 10
        itemnamelbl.textColor = UIColor.black
        itemQuantitylbl.textColor  = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
