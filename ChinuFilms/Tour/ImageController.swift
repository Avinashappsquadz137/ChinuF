//
//  ImageController.swift
//  SanskarEP
//
//  Created by Surya on 14/10/23.
//

import UIKit

class ImageController: UIViewController {
    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Amount: UILabel!
    @IBOutlet weak var Tourid: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var AAmount: UILabel!
    @IBOutlet weak var statusL: UITextField!
    @IBOutlet weak var textview: UIView!
    @IBOutlet weak var forImage: UIView!
    @IBOutlet weak var imagev: UIImageView!
    @IBOutlet weak var texL: UILabel!
    @IBOutlet weak var FromD: UILabel!
    @IBOutlet weak var ToD: UILabel!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var previousbtn: UIButton!
    @IBOutlet weak var remarkview: UIView!
    @IBOutlet weak var rejlabel: UILabel!
    @IBOutlet weak var locatioan: UILabel!
    
    
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
    var dat2      = ""
    var remarkL   = String()
    var imageB    = String()
    var type1     = ""
    var location  = ""
    //   var type      = ""
    
    var sourceViewController: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Amount.text = requAmnt
        Tourid.text = tourbac
        locatioan.text = location
        AAmount.text = AAMnt
        
       
        
        print(statusDe)
        if statusDe == "0" {
            statusL.text = "Submit"
            backbutton.isHidden = true
            previousbtn.isHidden = true
            remarkview.isHidden = true
            statusL.textColor = UIColor.blue
        } else if statusDe == "1" {
            statusL.text = "Approved"
            backbutton.isHidden = true
            previousbtn.isHidden = true
            remarkview.isHidden = true
            statusL.textColor = UIColor.blue
        } else if statusDe == "2" {
            statusL.text = "Reject"
            statusL.textColor = UIColor.red
            backbutton.isHidden = false
            previousbtn.isHidden = false
            remarkview.isHidden = false
    
        }
        
        if let source = sourceViewController {
                    switch source {
                    case "ApprovedTourVC":
                        Label.text = "Approved Tour List"
                    case "AllDetail2VC":
                        Label.text = "Submmit Tour List"
                    default:
                        Label.text = "Default Text"
                    }
                }
        
        
        FromD.text = dat
        ToD.text = dat2
        
        textview.layer.cornerRadius = 10
        textview.clipsToBounds = true
        
        backbutton.layer.cornerRadius = 10
        backbutton.clipsToBounds = true
        
        previousbtn.layer.cornerRadius = 10
        previousbtn.clipsToBounds = true
        
        forImage.layer.cornerRadius = 15
        forImage.clipsToBounds = true
        
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "tourdetCell", bundle: nil), forCellReuseIdentifier: "tourdetCell")

        forImage.isHidden = true
        remarkview.isHidden = true
    }
    
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    func setData(amo: String,ing: String){
        texL.text = amo
        imagev.sd_setImage(with: URL(string: imageurl+ing))
        forImage.isHidden = false
    }
    @IBAction func clearbtn(_ sender: UIButton) {
        forImage.isHidden = true
    }
    
     
//        backtosaved()
//        self.dismiss(animated: true, completion: nil)
     
    
    
    @IBAction func prebtn(_ sender: UIButton) {
        previousremark()
        remarkview.isHidden = false
    }
    
    @IBAction func sokbtn(_ sender: Any) {
        remarkview.isHidden = true
    }
   
    @IBAction func backtosavedbtn(_ sender: UIButton) {
        backtosaved()
        self.dismiss(animated: true, completion: nil)
    }
    
    func backtosaved(){
        var dict = Dictionary<String,Any>()
        dict["TourID"] = tourbac
        print(dict["TourID"])
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: srejapi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }else{
                AlertController.alert(message: (response?.validatedValue("message"))!)
                print(response?["error"] as Any)
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()

            }
        }
    }
    func previousremark(){
        var dict = Dictionary<String,Any>()
        dict["TourID"] = tourbac
        print(dict["TourID"])
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: rejapi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    
                    let data = (JSON["data"] as? [[String: Any]] ?? [[:]])
                    print(data)
                    
                    self.DataList = data
                    print(self.DataList)
                    //       let season_thumbnails = self.DataList["Remarks"] as? String ?? ""
                    for item in self.DataList {
                        if let remarks = item["Remarks"] as? String {
                            self.rejlabel.text = remarks
                            
                            self.remarkview.isHidden = false
                            print("Remarks: \(remarks)")
                            
                        }
                    }
                    //  AlertController.alert(message: (response?.validatedValue("message"))!)
                    DispatchQueue.main.async {
                      //  self.remarkview.isHidden = true
                        self.tableview.reloadData()
                    }
                }else{
                    //  AlertController.alert(message: (response?.validatedValue("message"))!)
                    print(response?["error"] as Any)
                    DispatchQueue.main.async {
                        self.rejlabel.text = response?.validatedValue("message")
                       // self.remarkview.isHidden = true
                    }
                }
            }
        }
    }
}
extension ImageController: UITableViewDataSource , UITableViewDelegate {

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(DataList)
        
         return alldata1.count
    }
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 100

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "tourdetCell", for: indexPath) as! tourdetCell
         print(DataList)
      //  alldata = (self.DataList[indexPath.section]["alldata"] as? [[String: Any]] ?? [[:]])
       //     print(alldata)

         let amo = alldata1[indexPath.row]["Amount"] as? String ?? ""
         print(amo)
         cell.amounttxt.text = amo
         cell.configureCell(isEditable: false)

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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        imageB = alldata1[indexPath.row]["Billing_thumbnail"] as? String ?? ""
        let img = imageData.replacingOccurrences(of: " ", with: "%20")
        remarkL = alldata1[indexPath.row]["reason"] as? String ?? ""
        setData(amo: remarkL,ing: imageB)

    }
}

