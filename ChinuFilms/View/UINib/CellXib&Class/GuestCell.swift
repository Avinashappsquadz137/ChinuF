//
//  GuestCell.swift
//  SanskarEP
//
//  Created by Warln on 23/04/22.
//

import UIKit

class GuestCell: UITableViewCell {
    
    @IBOutlet weak var nameLBl: UILabel!
    @IBOutlet weak var whomLbL: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var reasonLBl: UILabel!
    @IBOutlet weak var GImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        GImage.layer.borderWidth = 1.0
        GImage.layer.borderColor = UIColor.black.cgColor
        GImage.layer.cornerRadius = 5.0 // Optional: If you
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: GuestList) {
        guard let url = URL(string: model.PImg) else {return}
        GImage.sd_setImage(
            with: url,
            placeholderImage: UIImage(systemName: "person.fill"),
            options: .refreshCached, completed: nil
        )
        nameLBl.text = model.Guest_Name
        whomLbL.text = model.WhomtoMeet
        reasonLBl.text = model.Reason
        dateLbl.text = model.Date1.date.subString(from: 0, to: 10)
      
    }
    
}
