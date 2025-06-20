//
//  rejcell.swift
//  SanskarEP
//
//  Created by Surya on 06/12/23.
//

import UIKit

class rejcell: UITableViewCell {
    

    @IBOutlet weak var tourid: UILabel!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    

        
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
