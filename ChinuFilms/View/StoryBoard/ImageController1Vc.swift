//
//  ImageController1Vc.swift
//  SanskarEP
//
//  Created by Surya on 21/11/23.
//

import UIKit

class ImageController1Vc: UIViewController {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Amount: UILabel!
    @IBOutlet weak var Tourid: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var AAmount: UILabel!
    @IBOutlet weak var statusL: UILabel!
    @IBOutlet weak var textview: UIView!
    @IBOutlet weak var forImage: UIView!
    @IBOutlet weak var imagev: UIImageView!
    @IBOutlet weak var texL: UILabel!
    @IBOutlet weak var FromD: UILabel!
    @IBOutlet weak var ToD: UILabel!

    var DataList  = [[String:Any]]()
    var alldata1  = [[String:Any]]()
    var data1     = [[String:Any]]()
    var Serial    = [Int]()
    var tour      = String()
    var serials   = Int()
    var imageData = String()
    var imageurl  = "https://sap.sanskargroup.in/uploads/tour/"
    var tourbac   = ""
    var requAmnt  = ""
    var statusDe  = ""
    var AAMnt     = ""
    var dat       = ""
    var dat2      =  ""
    var remarkL   = String()
    var imageB    = String()
    var type1     = ""
    var location  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Amount.text = requAmnt
        Tourid.text = location
        AAmount.text = AAMnt
        FromD.text = dat
        ToD.text = dat2
        
        textview.layer.cornerRadius = 10
        textview.clipsToBounds = true
        
        forImage.layer.cornerRadius = 15
        forImage.clipsToBounds = true
        
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "tourdetCell", bundle: nil), forCellReuseIdentifier: "tourdetCell")
        forImage.isHidden = true
    }
    

    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    

}
extension ImageController1Vc: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(DataList)
        
        return alldata1.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourdetCell", for: indexPath) as! tourdetCell
        let amo = alldata1[indexPath.row]["Amount"] as? String ?? ""
        print(amo)
        cell.ALabel.text = amo
        
        serials = alldata1[indexPath.row]["Sno"] as? Int ?? 0
        print(serials)
        cell.SLabel.text = String(serials)
        
        let remark = alldata1[indexPath.row]["reason"] as? String ?? ""
        print(remark)
        cell.remarkL.text = String(remark)
        
        
        imageData = alldata1[indexPath.row]["Billing_thumbnail"] as? String ?? ""
        let img = imageData.replacingOccurrences(of: " ", with: "%20")
        print(img)
        
        cell.TImage.sd_setImage(with: URL(string: imageurl+img))
        return cell
    }
}
