//
//  HeaderCell.swift
//  SanskarEP
//
//  Created by Warln on 11/01/22.
//

import UIKit

class HeaderCell: UICollectionReusableView {
    //MARK: - Header IBOutlet
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var empCode: UILabel!
    @IBOutlet weak var serachBtn: UIButton!
    @IBOutlet weak var notifyLbl: UILabel!
    @IBOutlet var DOB: UILabel!
    @IBOutlet var InTime: UILabel!
    
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setup()
       
    }
   
    func setup() {
        if #available(iOS 13.0, *) {
            self.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        } else {
            // Fallback on earlier versions
        }

    }
        
    
}
