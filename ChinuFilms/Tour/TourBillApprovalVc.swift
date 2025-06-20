//
//  TourBillApprovalVc.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 14/07/23.
//

import UIKit

class TourBillApprovalVc: UIViewController {
    
    @IBOutlet var HeaderLbl: UILabel!
    @IBOutlet var TableView: UITableView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func bckbtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
