//
//  TourDetailsCell.swift
//  SanskarEP
//
//  Created by Surya on 16/09/23.
//

import UIKit

class TourDetailsCell: UITableViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var editbtn: UIButton!
    @IBOutlet weak var deletebtn: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var ImageBtn: UIButton!
    
    var editButtonAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
