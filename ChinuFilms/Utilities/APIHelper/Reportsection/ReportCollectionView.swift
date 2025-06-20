//
//  ReportCollectionView.swift
//  SanskarEP
//
//  Created by Surya on 25/12/24.
//

import UIKit

class ReportCollectionView: UICollectionViewCell {
    
    
    @IBOutlet weak var borderview: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var viewheight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBorderToUIView()
    }
    
    private func addBorderToUIView() {
        borderview.layer.borderColor = UIColor.black.cgColor
        borderview.layer.borderWidth = 0.5
        borderview.layer.masksToBounds = true
        borderview.layer.cornerRadius = 0
    }
    func setCellSize(width: CGFloat, height: CGFloat) {
        viewWidth.constant = width
        viewheight.constant = height
    }
}
