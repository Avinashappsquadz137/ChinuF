//
//  StatCell.swift
//  SanskarEP
//
//  Created by Warln on 12/03/22.
//

import UIKit

class StatCell: UITableViewCell {
    
    @IBOutlet weak var requestLbl: UILabel!
    @IBOutlet weak var resonLbl: UILabel!
    @IBOutlet weak var reqLbl: UILabel!
    @IBOutlet weak var approveLbl: UILabel!
    @IBOutlet weak var appBody: UILabel!
    @IBOutlet weak var duratLbl: UILabel!
    @IBOutlet weak var duratBody: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var statusBody: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
