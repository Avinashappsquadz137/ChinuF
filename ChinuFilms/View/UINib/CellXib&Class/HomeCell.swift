//
//  HomeCell.swift
//  SanskarEP
//
//  Created by Warln on 11/01/22.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var taskBtn: UIButton!
    @IBOutlet weak var countlbl: UILabel!
    @IBOutlet weak var starimage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.countlbl.layer.cornerRadius = countlbl.frame.height / 2
        self.countlbl.clipsToBounds = true
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
