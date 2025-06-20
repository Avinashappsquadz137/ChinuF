//
//  PLVc.swift
//  SanskarEP
//
//  Created by Warln on 15/01/22.
//

import UIKit

class PLVc: UIViewController {
    //MARK: - IBoutlet
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var titleTxt: String?
    
    var list: [[String:Any]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLbl.text = titleTxt
        tableView.register(UINib(nibName: kCell.plCell, bundle: nil), forCellReuseIdentifier: kCell.plCell)
        getDetails()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
      navigationController?.popViewController(animated: true)
    }
    
    func getDetails() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        list.removeAll()
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: kplPlanel) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                let json = response?["data"] as? [[String:Any]] ?? [[:]]
                for i in json {
                    self.list.append(i)
                }
            }else{
                print(response?["error"] as Any)
            }
            self.tableView.reloadData()
        }
    }
    
    
}

//MARK: - UITableViewDelegate

extension PLVc: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if list.count > 0 {
            return list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kCell.plCell, for: indexPath) as? PLCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
           cell.dateLbl.text = list[index]["Date"] as? String ?? ""
        let Added = list[index]["Credit"] as? String ?? ""
        let Deduct = list[index]["Debit"] as? String ?? ""
        
        if Added.isEmpty || Added == ".00" {
                cell.creditLbl.isHidden = true
                cell.addedlbl.isHidden = true
                cell.debitLbl.isHidden = false
                cell.deducted.isHidden = false
                cell.debitLbl.text = Deduct
            } else {
                cell.creditLbl.isHidden = false
                cell.addedlbl.isHidden = false
                cell.creditLbl.text = Added
                cell.debitLbl.isHidden = true
                cell.deducted.isHidden = true
            }

           // Handle Debit
//           if let debit = list[index]["Debit"] as? String {
//               cell.debitLbl.isHidden = debit.isEmpty || debit == ".00"
//               cell.deducted.isHidden = debit.isEmpty || debit == ".00"
//               cell.debitLbl.text = debit == ".00" ? "0" : debit
//           } else {
//               cell.debitLbl.isHidden = true
//               cell.deducted.isHidden = true
//           }
//
//           // Handle Credit
//           if let credit = list[index]["Credit"] as? String {
//               cell.creditLbl.isHidden = credit.isEmpty || credit == ".00"
//               cell.addedlbl.isHidden = credit.isEmpty  || credit == ".00"
//               cell.creditLbl.text = credit == ".00" ? "0" : credit
//           } else {
//              
//               cell.creditLbl.isHidden = true
//               cell.addedlbl.isHidden = true
//           }

        
        
        
           cell.balanceLbl.text = list[index]["Balance"] as? String ?? ""
           cell.refrencelbl.text = list[index]["Reference"] as? String ?? ""

           return cell
       }
}

//MARK: - UITableViewDelagte

extension PLVc: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
        
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
