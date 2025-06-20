//
//  NewHealthVc.swift
//  SanskarEP
//
//  Created by Surya on 14/12/23.
//

import UIKit

class NewHealthVc: UIViewController {

    @IBOutlet weak var PolicyNumber: UILabel!
    @IBOutlet weak var ExpireDate: UILabel!
    @IBOutlet weak var PolicyAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
}
