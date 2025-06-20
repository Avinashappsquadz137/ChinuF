//
//  newapproCell.swift
//  SanskarEP
//
//  Created by Surya on 08/02/25.
//

import UIKit

class newapproCell: UITableViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dept: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var checkbtn: UIButton!
    @IBOutlet weak var imageview1: UIImageView!
    @IBOutlet weak var status: UILabel!
   

    override func awakeFromNib() {
        super.awakeFromNib()
       
        imageview.layer.borderWidth = 0.5
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 6
        
        
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
        imageview1.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.fill"), options: .refreshCached, completed: nil)
    }
    

}

