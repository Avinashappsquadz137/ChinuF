//
//  AssignListCell.swift
//  SanskarEP
//
//  Created by Surya on 27/09/24.
//

import UIKit

class AssignListCell: UITableViewCell {
    

@IBOutlet weak var AssignLbl: UILabel!
@IBOutlet weak var assignbtn: UIButton!
@IBOutlet weak var locationview: UIView!
@IBOutlet weak var locationonclick: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
