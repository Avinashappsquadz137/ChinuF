//
//  approvalcollectionCell.swift
//  SanskarEP
//
//  Created by Surya on 05/02/25.
//


import UIKit

class ApprovalCollectionView: UICollectionViewCell {
  
    
    @IBOutlet weak var boaderview: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var circalimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBorderToUIView()
    }
    

private func addBorderToUIView() {
    boaderview.layer.borderColor = UIColor.black.cgColor
    boaderview.layer.borderWidth = 0.5
    boaderview.layer.masksToBounds = true
    boaderview.layer.cornerRadius = 8
}
}
