//
//  Request2Cell.swift
//  SanskarEP
//
//  Created by Surya on 18/10/24.
//

import UIKit

class Request2Cell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var venue: UILabel!    
    @IBOutlet weak var chhanel: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var forwardbtn: UIButton!
    @IBOutlet weak var statsuLbl: UILabel!
    @IBOutlet weak var typesLbl: UILabel!
    @IBOutlet weak var type: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
