//
//  healtVC.swift
//  SanskarEP
//
//  Created by Surya on 27/10/23.
//

import UIKit

class healtVC: UIViewController {

    @IBOutlet weak var Backview: UIView!
    @IBOutlet weak var PolicyNum: UILabel!
    @IBOutlet weak var Expireda: UILabel!
    @IBOutlet weak var PolicyAmnt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Backview.layer.cornerRadius = 15
        Backview.clipsToBounds = true
    
    }
    


    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
}
