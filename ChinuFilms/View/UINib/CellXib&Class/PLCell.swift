//
//  PLCell.swift
//  SanskarEP
//
//  Created by Warln on 15/01/22.
//

import UIKit

class PLCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var creditLbl: UILabel!
    @IBOutlet weak var debitLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var refrencelbl: UILabel!
    @IBOutlet weak var addedlbl: UILabel!
    @IBOutlet weak var deducted: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
