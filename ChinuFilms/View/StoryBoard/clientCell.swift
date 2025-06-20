//
//  clientCell.swift
//  SanskarEP
//
//  Created by Surya on 03/05/24.
//

import UIKit

class clientCell: UITableViewCell {
    
    @IBOutlet weak var PanIamgebtn: UIButton!
    @IBOutlet weak var GSTImageBtn: UIButton!
    @IBOutlet weak var clearbtn: UIButton!
    @IBOutlet weak var PanText: UITextField!
    @IBOutlet weak var GSTText: UITextField!
    @IBOutlet weak var clintname: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
   //     Addbutton.layer.cornerRadius = 8
        PanIamgebtn.layer.cornerRadius = 8
        GSTImageBtn.layer.cornerRadius = 8
        GSTImageBtn.isHidden = true
        PanIamgebtn.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
