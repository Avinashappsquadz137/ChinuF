//
//  EmployeedetailsCell.swift
//  SanskarEP
//
//  Created by Surya on 03/01/25.
//

import UIKit

class EmployeedetailsCell: UICollectionViewCell {
    
    @IBOutlet weak var Borderview: UIView!
    @IBOutlet weak var detaillabel: UILabel!
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var viewheight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBorderToUIView()
    }
    private func addBorderToUIView() {
        Borderview.layer.borderColor = UIColor.black.cgColor
        Borderview.layer.borderWidth = 0.5
        Borderview.layer.masksToBounds = true
        Borderview.layer.cornerRadius = 0
    }
    func setCellSize(width: CGFloat, height: CGFloat) {
        viewWidth.constant = width
        viewheight.constant = height
    }
}
