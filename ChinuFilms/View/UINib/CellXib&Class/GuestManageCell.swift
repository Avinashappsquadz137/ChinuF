//
//  GuestManageCell.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 09/08/23.
//

import UIKit

class GuestManageCell: UITableViewCell {
    
    
    @IBOutlet var backview: RoundUIView!
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var Label: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
