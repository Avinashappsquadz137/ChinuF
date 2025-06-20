//
//  ViewController.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 30/07/24.
//

import UIKit

class inentoryHomevc: UIViewController {
    
    @IBOutlet weak var createchallanview:UIView!
    @IBOutlet weak var savedchallanview:UIView!
    @IBOutlet weak var submitchallanview:UIView!
    @IBOutlet weak var returnchallanview:UIView!
    @IBOutlet weak var requestview:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.createchallanview.layer.cornerRadius = 10
        self.savedchallanview.layer.cornerRadius = 10
        self.submitchallanview.layer.cornerRadius = 10
        self.returnchallanview.layer.cornerRadius = 10
        self.requestview.layer.cornerRadius = 10
    }
    
    @IBAction func createchallanbtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "createchallanvc") as! createchallanvc
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func returnchallanbtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Returnchallanvc") as! Returnchallanvc
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    @IBAction func submitchallanbtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "submitchallanvc") as! submitchallanvc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func requestchallanbtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Requestvc") as! Requestvc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func savedchallanbtn(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Savedchallanvc") as! Savedchallanvc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

