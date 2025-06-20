//
//  HTourCell.swift
//  SanskarEP
//
//  Created by Surya on 10/10/23.
//

import UIKit

class HTourCell: UITableViewCell {
    

    @IBOutlet weak var TImage: UIImageView!
    @IBOutlet weak var EmpN: UILabel!
    @IBOutlet weak var EmpC: UILabel!
    @IBOutlet weak var DepL: UILabel!
    @IBOutlet weak var PendingL: UILabel!
    @IBOutlet weak var PendingB: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
