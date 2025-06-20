//
//  calenderCell.swift
//  SanskarEP
//
//  Created by Surya on 19/07/24.
//

import UIKit

class calenderCell: UICollectionViewCell {
    
    @IBOutlet weak var dayofmonth: UILabel!
    @IBOutlet weak var backview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        dayofmonth.textColor = .black // Set default text color
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
