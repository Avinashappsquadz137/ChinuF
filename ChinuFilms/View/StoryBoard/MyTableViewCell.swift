//
//  MyTableViewCell.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 28/04/23.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    

    @IBOutlet var MyImage: UIImageView!
    @IBOutlet var MyLbl: UILabel!
    @IBOutlet var MyLbl2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
