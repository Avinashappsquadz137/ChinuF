//
//  AssignLitstCell.swift
//  SanskarEP
//
//  Created by Surya on 23/10/24.
//

import UIKit


class AssignLitstCell: UITableViewCell {

    @IBOutlet weak var datalabel: UILabel!
    @IBOutlet weak var nestedbtn: UIButton!
    @IBOutlet weak var nestedtext: UITextField!
    
    
    var assigndata = [[String: Any]]()
    var selectedassign: String?
    var selecteempcode: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    
       
        nestedtext.layer.cornerRadius = 8
        nestedtext.layer.borderWidth = 0.5
        nestedtext.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

