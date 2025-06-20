//
//  LeaveReqCell.swift
//  SanskarEP
//
//  Created by Warln on 14/01/22.
//

import UIKit

class LeaveReqCell: UITableViewCell {
    
    @IBOutlet weak var requestId: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var noDays: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var NDayView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
