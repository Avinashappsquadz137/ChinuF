//
//  NewApprovalTourCell.swift
//  SanskarEP
//
//  Created by Surya on 12/08/24.
//

import UIKit

class NewApprovalTourCell: UITableViewCell {
    
    
    
    @IBOutlet weak var TourId: UILabel!
    @IBOutlet weak var EmpCode: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var FromDate: UILabel!
    @IBOutlet weak var ToDate: UILabel!
    @IBOutlet weak var ReqAmnt: UILabel!
    @IBOutlet weak var AppAmnt: UILabel!
    @IBOutlet weak var Checkbutn: UIButton!
    @IBOutlet weak var Tourview: UIView!
    @IBOutlet weak var Empview: UIView!
    @IBOutlet weak var venueview: UIView!
    @IBOutlet weak var Dateview: UIView!
    @IBOutlet weak var reqview: UIView!
    @IBOutlet weak var appview: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Tourview.layer.cornerRadius = 6
        Empview.layer.cornerRadius = 6
        venueview.layer.cornerRadius = 6
        Dateview.layer.cornerRadius = 6
        reqview.layer.cornerRadius = 6
        appview.layer.cornerRadius = 6
      
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
