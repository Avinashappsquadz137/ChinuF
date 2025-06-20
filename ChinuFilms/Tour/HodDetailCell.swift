//
//  HodDetailCell.swift
//  SanskarEP
//
//  Created by Surya on 21/10/23.
//

import UIKit

class HodDetailCell: UITableViewCell {
    

    @IBOutlet weak var EmpName: UILabel!
    @IBOutlet weak var EmpCode: UILabel!
    @IBOutlet weak var Status: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var ReqAmnt: UILabel!
    @IBOutlet weak var AppAmnt: UILabel!
    @IBOutlet weak var Remark: UILabel!
    @IBOutlet weak var tourid: UILabel!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
