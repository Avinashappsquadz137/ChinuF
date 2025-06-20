//
//  TourStCell.swift
//  SanskarEP
//
//  Created by Surya on 28/11/23.
//

import UIKit

class TourStCell: UITableViewCell {

    @IBOutlet weak var reqid: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var todate: UILabel!
    @IBOutlet weak var fdate: UILabel!
    @IBOutlet weak var hodA: UILabel!
    @IBOutlet weak var canclebtn: UIButton!
    @IBOutlet weak var leavetype: UILabel!
    @IBOutlet weak var tolbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        canclebtn.layer.cornerRadius = 8
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
