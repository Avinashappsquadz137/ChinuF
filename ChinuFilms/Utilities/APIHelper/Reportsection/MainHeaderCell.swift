//
//  MainHeaderCell.swift
//  SanskarEP
//
//  Created by Vaibhav on 01/04/25.
//

import UIKit

class MainHeaderCell: UICollectionViewCell {


    @IBOutlet weak var namelable: UILabel!
    @IBOutlet weak var image: UIImageView!
    
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
    
    func configure(with name: String, id: Int) {
           namelable.text = name
           image.image = UIImage(named: "icon_\(id)")
       }
    
}
