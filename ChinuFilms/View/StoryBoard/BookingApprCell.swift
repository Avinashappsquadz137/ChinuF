//
//  BookingApprCell.swift
//  SanskarEP
//
//  Created by Surya on 30/03/24.
//

import UIKit

class BookingApprCell: UITableViewCell {
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var AmountLbl: UILabel!
    @IBOutlet weak var ChannelLbl: UILabel!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var VenueLbl: UILabel!
    @IBOutlet weak var approvebtn: UIButton!
    @IBOutlet weak var rejectbtn: UIButton!
    @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var checkbtn: UIButton!
    @IBOutlet weak var GSTLbl: UILabel!
    @IBOutlet weak var todateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        approvebtn.layer.cornerRadius = 8
        rejectbtn.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
