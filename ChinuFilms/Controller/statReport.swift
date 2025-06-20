//
//  statReport.swift
//  SanskarEP
//
//  Created by Warln on 12/03/22.
//

import UIKit

class statReport: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLBl: UILabel!
    
    var stValue: [StValue]?
    var Advalue: [AdvanceV]?
    var type: String?
    var titleTxt: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "StatCell", bundle: nil), forCellReuseIdentifier: "StatCell")
        tableView.delegate = self
        tableView.dataSource = self
        headerLBl.text = titleTxt
        tableView.backgroundColor = .clear
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension statReport: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == "Ad"{
            return Advalue?.count ?? 0
        }else{
            return stValue?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as? StatCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
        if type == "Ad"{
            cell.requestLbl.text = ":- \(Advalue?[index].requestedAmount ?? "")"
            cell.resonLbl.text = ":- \(Advalue?[index].reason ?? "")"
            cell.reqLbl.text = ":- \(Advalue?[index].reqDate ?? "")"
            cell.approveLbl.text = ":- \(Advalue?[index].approvedAmount ?? "")"
            cell.appBody.text = "Approve Amount"
            cell.duratLbl.text = ":- \(Advalue?[index].repaymentDuration ?? "")"
            cell.duratBody.text = "Duration"
            cell.statusLbl.text = ":- \(Advalue?[index].status ?? "")"
            cell.statusBody.text = "Status"
        }else{
            cell.requestLbl.text = ":- \(stValue?[index].requestType ?? "")"
            cell.resonLbl.text = ":- \(stValue?[index].reason ?? "")"
            cell.reqLbl.text = ":- \(stValue?[index].reqDate ?? "")"
            cell.approveLbl.isHidden = true
            cell.appBody.isHidden = true
            cell.duratLbl.isHidden = true
            cell.duratBody.isHidden = true
            cell.statusLbl.isHidden = true
            cell.statusBody.isHidden = true
            cell.selectionStyle = .none
        }
        

        return cell
    }
    
}

extension statReport: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type == "Ad"{
            return 200
        }else{
            return 120
        }
    }
    
}
