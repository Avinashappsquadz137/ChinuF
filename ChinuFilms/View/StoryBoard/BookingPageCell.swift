//
//  BookingPageCell.swift
//  SanskarEP
//
//  Created by Surya on 01/05/24.
//

import UIKit

class BookingPageCell: UITableViewCell {

  
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var AMountLabel: UILabel!
    @IBOutlet weak var GSTLabel: UILabel!
    @IBOutlet weak var ChennelLabel: UILabel!
    @IBOutlet weak var DateromLabel: UILabel!
    @IBOutlet weak var DateTOLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var VenueLabel: UILabel!
    @IBOutlet weak var statsulbl: UILabel!
    @IBOutlet weak var rounduiview: UIView!
    @IBOutlet weak var eyebtn: UIButton!
    @IBOutlet weak var editbtn: UIButton!
    @IBOutlet weak var forwardimage: UIImageView!
    @IBOutlet weak var dialbtn: UIButton!
    @IBOutlet weak var assignbtn: UIButton!
    @IBOutlet weak var checkbtn: UIButton!
    @IBOutlet weak var typeslbl: UILabel!
    @IBOutlet weak var Type1Lbl: UILabel!
    @IBOutlet weak var eyeview: UIButton!
    @IBOutlet weak var gstlbl: UILabel!
    @IBOutlet weak var Mainamount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rounduiview.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
