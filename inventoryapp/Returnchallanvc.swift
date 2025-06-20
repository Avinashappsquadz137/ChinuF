//
//  Returnchallanvc.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 30/07/24.
//

import UIKit

class Returnchallanvc: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backbtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
 
    

}
