//
//  mywishbdayTableViewCell.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 05/07/23.
//

import UIKit

class mywishbdayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblmsg:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
