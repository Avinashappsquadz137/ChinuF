//
//  ApprovedListCell.swift
//  SanskarEP
//
//  Created by Surya on 01/04/24.
//

import UIKit

class ApprovedListCell: UITableViewCell {
    

    @IBOutlet weak var LocationLbl: UILabel!
    @IBOutlet weak var Datelbl: UILabel!
    @IBOutlet weak var ChannelLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var Locationlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
