//
//  TourfullDetailsCell.swift
//  SanskarEP
//
//  Created by Surya on 19/09/23.
//

import UIKit

class TourfullDetailsCell: UITableViewCell {
    


    @IBOutlet weak var TourId: UILabel!
    @IBOutlet weak var Amount: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var AAmount: UILabel!
    @IBOutlet weak var StatusL: UILabel!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var Locationlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
