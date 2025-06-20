//
//  SavedDataCell.swift
//  SanskarEP
//
//  Created by Surya on 28/08/24.
//

import UIKit

class SavedDataCell: UITableViewCell {
    
    @IBOutlet weak var mainview:UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var openbtn: UIButton!
    
    var buttonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainview.layer.cornerRadius = 10
        dateLbl.textColor = UIColor.black
        locationlbl.textColor  = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func openButtonTapped(_ sender: UIButton) {
        buttonAction?()
    }
}
