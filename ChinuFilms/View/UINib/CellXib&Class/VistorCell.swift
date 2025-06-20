//
//  VistorCell.swift
//  SanskarEP
//
//  Created by Warln on 23/04/22.
//

import UIKit
import SDWebImage

class VistorCell: UITableViewCell {
    
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var toWhomeLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var inTimeLbl: UILabel!
    @IBOutlet weak var outTimeLbl: UILabel!
    @IBOutlet weak var pview: UIView!    
    @IBOutlet weak var penbtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImg.layer.borderWidth = 1.0
        posterImg.layer.borderColor = UIColor.black.cgColor
        posterImg.layer.cornerRadius = 5.0 // Optional: If you
        pview.layer.cornerRadius = 5.0
        pview.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with model: VistorList ) {
        guard let url = URL(string: model.image ?? "") else {return}
        posterImg.sd_setImage(
            with: url,
            placeholderImage: UIImage(systemName: "person.fill"),
            options: .refreshCached, completed: nil
        )
        nameLbl.text = model.name
        dateLbl.text = model.guest_date
        toWhomeLbl.text = model.to_whome
        addressLbl.text = model.address
        inTimeLbl.text = model.in_time
        outTimeLbl.text = model.out_time
        
    }
    
}
