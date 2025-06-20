//
//  statusTableViewCell.swift
//  SanskarEP
//
//  Created by Surya on 24/11/23.
//

import UIKit

class statusTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var reqId: UILabel!
    @IBOutlet weak var fromdate: UILabel!
    @IBOutlet weak var todate: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var reasonlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelbtn.layer.cornerRadius = 8 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
