//
//  datatablecell.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 30/07/24.
//

import UIKit

class datatablecell: UITableViewCell {
    
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

        // Configure the view for the selected state
    }
    @IBAction func openButtonTapped(_ sender: UIButton) {
        buttonAction?()
    }
    
}
