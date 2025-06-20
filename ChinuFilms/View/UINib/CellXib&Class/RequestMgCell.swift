//
//  RequestMgCell.swift
//  SanskarEP
//
//  Created by Warln on 13/01/22.
//

import UIKit

class RequestMgCell: UITableViewCell {
    
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var reqBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
