//
//  NewApprovalBookingCell.swift
//  SanskarEP
//
//  Created by Surya on 12/08/24.
//

import UIKit

class NewApprovalBookingCell: UITableViewCell {

    @IBOutlet weak var Approvebtn: UIButton!
    @IBOutlet weak var rejectbtn: UIButton!
    @IBOutlet weak var ChannelLbl: UILabel!
    @IBOutlet weak var Amountlbl: UILabel!
    @IBOutlet weak var Locationlbl: UILabel!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var checkbutton: UIButton!
    @IBOutlet weak var fromdate: UILabel!
    @IBOutlet weak var todate: UILabel!    
    @IBOutlet weak var NameLbl: UILabel!
    
    @IBOutlet weak var channelview: UIView!
    @IBOutlet weak var TimeView: UIView!
    @IBOutlet weak var Amountview: UIView!
    @IBOutlet weak var Dateview: UIView!
    @IBOutlet weak var Locationview: UIView!
    @IBOutlet weak var SantView: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        channelview.layer.cornerRadius = 6
        TimeView.layer.cornerRadius = 6
        Amountview.layer.cornerRadius = 6
        Dateview.layer.cornerRadius = 6
        Locationview.layer.cornerRadius = 6
        SantView.layer.cornerRadius = 6
       
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
