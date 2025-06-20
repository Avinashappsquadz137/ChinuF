//
//  PunchHistoryDaysS.swift
//  SanskarEP
//
//  Created by Vaibhav on 22/03/25.
//

import UIKit

class PunchHistoryDaysS: UICollectionViewCell {
    
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var dayview: UIView!
    @IBOutlet weak var daysbtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBorderToUIView()
    }
    
    private func addBorderToUIView() {
        dayview.layer.borderColor = UIColor.black.cgColor
        dayview.layer.borderWidth = 0.5
        dayview.layer.masksToBounds = true
        dayview.layer.cornerRadius = 0
        dayview.layer.cornerRadius = 8
        dayview.clipsToBounds = true
    }
    
}
