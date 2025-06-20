//
//  AcceptCell.swift
//  SanskarEP
//
//  Created by Warln on 18/01/22.
//

import UIKit
import SDWebImage

class AcceptCell: UITableViewCell {
    
    @IBOutlet weak var requestId: UILabel!
    @IBOutlet weak var emp: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var requestDate: UILabel!
    @IBOutlet weak var shiftLbl: UILabel!
    @IBOutlet weak var hideShift: UILabel!
    @IBOutlet weak var reqHide: UILabel!
    @IBOutlet weak var reqLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var acceptBtN: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var firstview: UIView!
    @IBOutlet weak var secondview: UIView!
    @IBOutlet weak var checkbtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        firstview.layer.cornerRadius = 5.0
//        firstview.layer.borderWidth = 1.0
//        secondview.layer.cornerRadius = 5.0
//        secondview.layer.borderWidth = 1.0
        userImg.layer.cornerRadius = 5.0
        userImg.layer.borderWidth = 1.0
//        
        acceptBtN.layer.cornerRadius = 5.0
  //      acceptBtN.layer.borderWidth = 1.0
        rejectBtn.layer.cornerRadius = 5.0
  //      rejectBtn.layer.borderWidth = 1.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setImage(with model: String) {
        var imgUrl = ""
        if model.containsWhitespace {
            imgUrl = model.replacingOccurrences(of: " ", with: "%20")
        }else{
            imgUrl = model
        }
        guard let url = URL(string: imgUrl) else {return}
        userImg.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.fill"), options: .refreshCached, completed: nil)
    }
    
   
    @IBAction func TourDetails(_ sender: Any) {
        let customDialogVC = CustomDialogVC() // Initialize your custom dialog view controller
                customDialogVC.modalPresentationStyle = .overCurrentContext // Present modally over the current view
                
    //    present(customDialogVC, animated: true, completion: nil)
    }
}
