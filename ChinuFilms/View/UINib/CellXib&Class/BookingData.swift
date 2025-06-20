//
//  BookingData.swift
//  SanskarEP
//
//  Created by Warln on 11/03/22.
//

import UIKit

class BookingData: UITableViewCell {
    
    @IBOutlet weak var cDateLbl: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var santNameL: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var channelLbl: UILabel!
    @IBOutlet weak var locateLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbL: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var posterImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(body: RODetail) {
        cDateLbl.text = "Date: \(body.bookingDt)        ID:\(body.bookingNo)"
        name.text = "Name: \(body.empName)"
        santNameL.text = "Sant: \(body.santName)"
        statusLbl.text = "Status: \(body.status)"
        channelLbl.text = "Channel: \(body.channel)         Program: \(body.progTyp)"
        if body.inclGst == "Yes"{
            amount.text = "Amount: \(body.bookingAmt)/- Gst Include"
        }else{
            amount.text = "Amount: \(body.bookingAmt)/- Gst Extra"
        }
        locateLbl.text = "Location: \(body.kathaLoct)"
        dateLbl.text = "Date Period: \(body.startDt) To \(body.endDt)"
        timeLbL.text = "Time Period: \(body.startTime) To \(body.endTime)"
        switch body.channel {
        case "Sanskar":
            posterImg.image = UIImage(named: "sanskar")
        case "Satsang":
            posterImg.image = UIImage(named: "satsangLog")
        case "Shubh":
            posterImg.image = UIImage(named: "shubh")
        default:
            break
        }
        
    }
    
}
