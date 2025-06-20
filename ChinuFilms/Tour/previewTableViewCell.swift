//
//  previewTableViewCell.swift
//  SanskarEP
//
//  Created by Surya on 01/07/24.
//

import UIKit

class previewTableViewCell: UITableViewCell {
    

    @IBOutlet weak var Sno: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var AMount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
