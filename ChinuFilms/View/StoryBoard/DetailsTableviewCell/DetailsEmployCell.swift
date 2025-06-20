//
//  DetailsEmployCell.swift
//  SanskarEP
//
//  Created by Surya on 18/11/24.
//

import UIKit

class DetailsEmployCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtRemarkView: UITextView!
    @IBOutlet weak var btnViewContent: UIButton!
    @IBOutlet weak var btnAprove: UIButton!
    @IBOutlet weak var btnreject: UIButton!
    @IBOutlet weak var txtRemarkviewHeight: NSLayoutConstraint!
    @IBOutlet weak var okbtn: UIButton!
    
    var completedstage = Int()
    var approvalstage = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        txtRemarkView.delegate = self
        txtRemarkView.layer.cornerRadius = 10
        txtRemarkView.clipsToBounds = true
        txtRemarkView.text = "Remark ..."
        txtRemarkView.textColor = UIColor.lightGray
        txtRemarkView.layer.borderWidth = 1.0
        txtRemarkView.layer.borderColor = UIColor.darkGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

   
    }
    func configure(with data: [String: Any]) {
            let name = data["name"] as? String ?? "Unknown"
            let type = data["Type_name"] as? String ?? "N/A"
            let status = data["status"] as? String ?? "Pending"
             completedstage = data["completed_stage"] as? Int ?? 0
             approvalstage  = data["approval_stage"] as? Int ?? 0
        
        
            
            lblName.attributedText  = formattedText(label: "NAME", value: name)
            lblType.attributedText = formattedText(label: "TYPE", value: type)
            lblStatus.attributedText = formattedText(label: "STATUS", value: status)
      
        condition ()
        
        }

    func condition () {
        if (completedstage == 0 && approvalstage == 0) {
            btnViewContent.isHidden = true
            btnAprove.isHidden = true
            btnreject.isHidden = true
            txtRemarkView.isHidden = true
            okbtn.isHidden = true
        } else if  (completedstage == 1 && approvalstage == 0) {
            btnViewContent.isHidden = false
            btnAprove.isHidden = false
            btnreject.isHidden = false
            txtRemarkView.isHidden = true
            okbtn.isHidden = true
        } else if  (completedstage == 1 && approvalstage > 0) {
            
            btnViewContent.isHidden = false
            btnAprove.isHidden = true
            btnreject.isHidden = true
            txtRemarkView.isHidden = true
            okbtn.isHidden = true
        } else {
            btnViewContent.isHidden = true
            btnAprove.isHidden = true
            btnreject.isHidden = true
            txtRemarkView.isHidden = true
            okbtn.isHidden = true
            
        }
    }
       private func formattedText(label: String, value: String) -> NSAttributedString {
           let attributedString = NSMutableAttributedString()
           let labelAttributes: [NSAttributedString.Key: Any] = [
               .font: UIFont.boldSystemFont(ofSize: 20),
               .foregroundColor: UIColor.black
           ]
           let labelText = NSAttributedString(string: "\(label): ", attributes: labelAttributes)
           attributedString.append(labelText)
           let valueAttributes: [NSAttributedString.Key: Any] = [
               .font: UIFont.boldSystemFont(ofSize: 20),
               .foregroundColor: UIColor.darkGray
           ]
           let valueText = NSAttributedString(string: value, attributes: valueAttributes)
           attributedString.append(valueText)
           return attributedString
       }
    
    @IBAction func btnActionAprove(_ sender: UIButton) {
        btnViewContent.isHidden = false
        btnAprove.isHidden = true
        btnreject.isHidden = true
        txtRemarkView.isHidden = true
        okbtn.isHidden = true
    }
    
    @IBAction func btnActionreject(_ sender: UIButton) {
        btnAprove.isHidden = false
        btnreject.isHidden = false
        btnViewContent.isHidden = false
        self.txtRemarkView.isHidden = !self.txtRemarkView.isHidden
        self.okbtn.isHidden = !self.okbtn.isHidden
        
    }
    
    @IBAction func btnViewContent(_ sender: UIButton) {
          
    }
    

}
extension DetailsEmployCell : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (txtRemarkView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if txtRemarkView.textColor == UIColor.lightGray {
            txtRemarkView.text = ""
            txtRemarkView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if txtRemarkView.text == "" {

            txtRemarkView.text = "Remark ..."
            txtRemarkView.textColor = UIColor.lightGray
        }
    }
}
