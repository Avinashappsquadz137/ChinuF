//
//  QcMetaCell.swift
//  SanskarEP
//
//  Created by Surya on 16/12/24.
//

import UIKit

class QcMetaCell: UITableViewCell {
    

@IBOutlet weak var Name: UILabel!
@IBOutlet weak var Channel: UILabel!
@IBOutlet weak var Venue: UILabel!
@IBOutlet weak var Date: UILabel!
@IBOutlet weak var Time: UILabel!
@IBOutlet weak var Promo: UILabel!
@IBOutlet weak var eyebtn: UIButton!
@IBOutlet weak var metaidbtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        metaidbtn.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
