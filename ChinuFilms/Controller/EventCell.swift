//
//  EventCell.swift
//  SanskarEP
//
//  Created by Surya on 31/08/24.
//

import UIKit

class EventCell: UITableViewCell {
    
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var locationlabel: UILabel!
    @IBOutlet weak var colorlbl: UILabel!
    @IBOutlet weak var reasonlbl: UILabel!
    @IBOutlet weak var fromdate: UILabel!
    @IBOutlet weak var todate: UILabel!
    @IBOutlet weak var typelbl: UILabel!
    @IBOutlet weak var eventbtn: UIButton!
    @IBOutlet weak var to: UILabel!    
    @IBOutlet weak var frwrdimage: UIImageView!
    @IBOutlet weak var type: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
