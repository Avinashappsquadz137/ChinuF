//
//  EventbookingCell.swift
//  SanskarEP
//
//  Created by Surya on 17/09/24.
//

import UIKit

class EventbookingCell: UITableViewCell {
    
    @IBOutlet weak var santname: UILabel!
    @IBOutlet weak var Channel: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var bookingbtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
