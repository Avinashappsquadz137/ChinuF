//
//  TableBookCell.swift
//  SanskarEP
//
//  Created by Surya on 26/03/24.
//

import UIKit

class TableBookCell: UITableViewCell {
    

    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Namelbl: UILabel!
    @IBOutlet weak var amountlbl: UILabel!
    @IBOutlet weak var channellbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var venuelbl: UILabel!
    @IBOutlet weak var bookingidlbl: UILabel!
    @IBOutlet weak var DateLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
