//
//  leaveview.swift
//  SanskarEP
//
//  Created by Surya on 21/08/24.
//

import UIKit

class leaveview: UIView {

    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           commonInit()
       }
       
       func commonInit(){
           let viewFromXib = Bundle.main.loadNibNamed("leaveview", owner: self, options: nil)![0] as! UIView
           viewFromXib.frame = self.bounds
           addSubview(viewFromXib)
       }

}
