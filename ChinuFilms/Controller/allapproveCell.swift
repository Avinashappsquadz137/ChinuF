//
//  allapproveCell.swift
//  SanskarEP
//
//  Created by Surya on 07/08/24.
//

import UIKit

class allapproveCell: UITableViewCell {
    
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var EmpName: UILabel!
    @IBOutlet weak var depart: UILabel!
    @IBOutlet weak var fromdate: UILabel!
    @IBOutlet weak var checkbtn: UIButton!
    @IBOutlet weak var approvebtn: UIButton!
    @IBOutlet weak var rejectbtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func setImage(with model: String) {
        var imgUrl = ""
        if model.containsWhitespace {
            imgUrl = model.replacingOccurrences(of: " ", with: "%20")
        }else{
            imgUrl = model
        }
        guard let url = URL(string: imgUrl) else {return}
        imageview.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.fill"), options: .refreshCached, completed: nil)
    }
}
