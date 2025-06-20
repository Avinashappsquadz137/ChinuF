//
//  ATourVC.swift
//  SanskarEP
//
//  Created by Surya on 10/10/23.
//

import UIKit

class ATourVC: UIViewController {

    @IBOutlet weak var Header: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    var edata = [HodTour( imageGallery:["Flowers1","Flowers1","Hands1","Hands2","Flowers2","Hands1","Flowers2"])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "ApprCell", bundle: nil), forCellReuseIdentifier: "ApprCell")
    }
    

    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
}
extension ATourVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       150
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       return edata.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TourvHiewCell
        cell.Mycollectionview.tag = indexPath.section
        return cell
    }
    
    
}
