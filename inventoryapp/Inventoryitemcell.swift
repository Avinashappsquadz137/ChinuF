//
//  Inventoryitemcell.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 06/08/24.
//

import UIKit

class Inventoryitemcell: UITableViewCell {
    
    @IBOutlet weak var itemtypelbl:UILabel!
    @IBOutlet weak var itemnamelbl:UILabel!
    @IBOutlet weak var itemmodlenolbl:UILabel!
    @IBOutlet weak var deletebtn:UIButton!

    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        itemnamelbl.textColor = UIColor.black
        itemtypelbl.textColor  = UIColor.black
        itemmodlenolbl.textColor = UIColor.black
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
