//
//  ReuestTypeVc.swift
//  SanskarEP
//
//  Created by Warln on 12/03/22.
//

import UIKit

class ReuestTypeVc: UIViewController {
    
    @IBOutlet weak var report: UILabel!
    @IBOutlet weak var newType: UILabel!
    @IBOutlet weak var headerlbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    var stData: StData?
    var advanceD: AdvanceD?
    var titleTxt: String?
    var reportTxt: String?
    var newTxt: String?
    var type: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerlbl.text = titleTxt
        newType.text = newTxt
        report.text = reportTxt
        countLbl.layer.cornerRadius = countLbl.bounds.size.width / 2
        countLbl.clipsToBounds = true
        if type == "Ad" {
            advanceDataHit()
        }else{
            stationData()
        }
        
    }
    
    @IBAction func reportBtnPressed(_ sender: UIButton) {
        if type == "Ad" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "statReport") as! statReport
            vc.titleTxt = reportTxt
            vc.Advalue = advanceD?.data
            vc.type = "Ad"
            self.present(vc,animated: true,completion: nil)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "statReport") as! statReport
            vc.titleTxt = reportTxt
            vc.stValue = stData?.data
            self.present(vc,animated: true,completion: nil)
        }

        
    }
    
    @IBAction func newTypeBtnPressed(_ sender: UIButton) {
        if type == "Ad" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdvcanceVC" ) as! AdvcanceVC
            vc.titleTxt = newTxt
            self.present(vc,animated: true,completion: nil)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: idenity.healthVc ) as! HealthVc
            vc.stat = true
            vc.titleTxt = newTxt
            self.present(vc,animated: true,completion: nil)
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
   //     self.navigationController?.popViewController(animated: true)
    }
    
    
    func stationData() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: statData) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let json = data, (response?["status"] as? Bool == true), response != nil {
                let decoder = JSONDecoder()
                do{
                    self.stData = try decoder.decode(StData.self, from: json)
                    self.countLbl.text = "\(self.stData?.data.count ?? 0)"
                }catch let error{
                    print(error.localizedDescription as Any)
                }
            }
        }
    }
    
    func advanceDataHit() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: advanceApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let json = data,(response?["status"] as? Bool == true), response != nil {
                let decoder = JSONDecoder()
                do{
                    self.advanceD = try decoder.decode(AdvanceD.self, from: json)
                    self.countLbl.text = "\(self.advanceD?.data.count ?? 0)"
                }catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }

}
