//
//  tourdetCell.swift
//  SanskarEP
//
//  Created by Surya on 19/10/23.
//

import UIKit
protocol tourdetCellDelegate: AnyObject {
    func amountDidChange(_ cell: tourdetCell, serial: String, amount: String)
}


class tourdetCell: UITableViewCell {
    

    @IBOutlet weak var SLabel: UILabel!
    @IBOutlet weak var TImage: UIImageView!
    @IBOutlet weak var ALabel: UILabel!
    @IBOutlet weak var remarkL: UILabel!
    @IBOutlet weak var imagebutton: UIButton!
    @IBOutlet weak var remarkbtn: UIButton!
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var amounttxt: UITextField!
    
    weak var delegate: tourdetCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.awakeFromNib()
        amounttxt.addTarget(self, action: #selector(amountTextChanged), for: .editingChanged)
       }

    @objc func amountTextChanged() {
           if let amount = amounttxt.text, let serial = SLabel.text {
               delegate?.amountDidChange(self, serial: serial, amount: amount)
           }
       }
    
    func configureCell(isEditable: Bool) {
        amounttxt.isUserInteractionEnabled = isEditable
        }
        // Configure the view for the selected state
    }
    

