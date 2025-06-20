//
//  ApprvlCollCell.swift
//  SanskarEP
//
//  Created by Surya on 05/02/25.
//

import UIKit

class ApprvlCollCell: UICollectionViewCell {

    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var actionbtn: UIButton!
    @IBOutlet weak var roundview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      //  roundview.layer.borderWidth = 0.5
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
