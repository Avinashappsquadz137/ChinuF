import UIKit

class PunchHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var inTimeLabel: UILabel!
    @IBOutlet weak var outTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     //   addBorderToUIView()
        // Ensure labels are center aligned and occupy equal width
        dateLabel.textAlignment = .center
        inTimeLabel.textAlignment = .center
        outTimeLabel.textAlignment = .center
        
        locationLabel.contentHorizontalAlignment = .center
        locationLabel.titleLabel?.textAlignment = .center
        locationLabel.titleLabel?.numberOfLines = 2
        locationLabel.titleLabel?.lineBreakMode = .byWordWrapping
        
    }
//    private func addBorderToUIView() {
//        dateLabel.layer.borderColor = UIColor.black.cgColor
//        dateLabel.layer.borderWidth = 0.5
//        dateLabel.layer.masksToBounds = true
//        dateLabel.layer.cornerRadius = 0
//        
//        inTimeLabel.layer.borderColor = UIColor.black.cgColor
//        inTimeLabel.layer.borderWidth = 0.5
//        inTimeLabel.layer.masksToBounds = true
//        inTimeLabel.layer.cornerRadius = 0
//        
//        outTimeLabel.layer.borderColor = UIColor.black.cgColor
//        outTimeLabel.layer.borderWidth = 0.5
//        outTimeLabel.layer.masksToBounds = true
//        outTimeLabel.layer.cornerRadius = 0
//        
//        locationLabel.layer.borderColor = UIColor.black.cgColor
//        locationLabel.layer.borderWidth = 0.5
//        locationLabel.layer.masksToBounds = true
//        locationLabel.layer.cornerRadius = 0
//
//    }
    
}
