//
//  BookforReceptionVc.swift
//  SanskarEP
//
//  Created by Surya on 24/09/24.
//

import UIKit

class BookforReceptionVc: UIViewController {
    
    
    @IBOutlet weak var contactperson: UITextField!
    @IBOutlet weak var contactmbl: UITextField!
    @IBOutlet weak var assigntxt: UITextField!
    @IBOutlet weak var mianview: UIView!
    @IBOutlet weak var citytxt: UITextField!
    @IBOutlet weak var remarkstxt: UITextField!
    @IBOutlet weak var submitbtbn: UIButton!
    @IBOutlet weak var newtable:UITableView!
    
    var datalist  = [[String:Any]]()
    var Kathatype  = [[String:Any]]()
    var selectedEmpcode: String?
    var selectedIds: [Int] = []
    var selectedRows: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        ReceptionApi()
        selectTypeApi()
        
        newtable.register(UINib(nibName: "AssignListCell", bundle: nil), forCellReuseIdentifier: "AssignListCell")
        
        newtable.dataSource = self
        newtable.delegate = self
        mianview.isHidden = true
        newtable.isHidden = true
    }
    func setup(){
        contactperson.layer.cornerRadius = 10
        contactperson.layer.borderWidth = 0.5
        contactperson.layer.borderColor = UIColor.lightGray.cgColor
        
        contactmbl.layer.cornerRadius = 10
        contactmbl.layer.borderWidth = 0.5
        contactmbl.layer.borderColor = UIColor.lightGray.cgColor
        
        assigntxt.layer.cornerRadius = 10
        assigntxt.layer.borderWidth = 0.5
        assigntxt.layer.borderColor = UIColor.lightGray.cgColor
        
        citytxt.layer.cornerRadius = 10
        citytxt.layer.borderWidth = 0.5
        citytxt.layer.borderColor = UIColor.lightGray.cgColor
        
        remarkstxt.layer.cornerRadius = 10
        remarkstxt.layer.borderWidth = 0.5
        remarkstxt.layer.borderColor = UIColor.lightGray.cgColor
        
        submitbtbn.layer.cornerRadius = 10
        submitbtbn.layer.borderWidth = 0.5
       
        
    }
    
    func ReceptionApi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["sales_person"] = selectedEmpcode
        dict["caller_name"] = contactperson.text
        dict["Remarks"] = remarkstxt.text
        dict["Location"] =  citytxt.text
        dict["caller_mobile"] = contactmbl.text
        
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: receptionApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                if let dataArray = responseData["data"] as? [[String: Any]] {
                    // Parse and update your datalist here
          //          self.datalist = dataArray
                    // Reload the tableview
                 //   self.tableview.reloadData()
                    AlertController.alert(message: (response?.validatedValue("message"))!)
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }
    
    @objc func checkboxTapped(_ sender: UIButton) {
        let rowIndex = sender.tag
               if selectedRows.contains(rowIndex) {
                   selectedRows.remove(rowIndex)
                   if let id = Kathatype[rowIndex]["id"] as? Int {
                       selectedIds.removeAll(where: { $0 == id })
                   }
               } else {
                   selectedRows.insert(rowIndex)
                   if let id = Kathatype[rowIndex]["id"] as? Int {
                       selectedIds.append(id)
                   }
               }
        newtable.reloadData()
           }
       
        func selectTypeApi() {
            var dict = Dictionary<String, Any>()
            dict["EmpCode"] = currentUser.EmpCode
    
    
            DispatchQueue.main.async(execute: { Loader.showLoader() })
            APIManager.apiCall(postData: dict as NSDictionary, url: AssignPeopleAPi) { result, response, error, data in
                DispatchQueue.main.async(execute: { Loader.hideLoader() })
                if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true {
                    print(JSON)
                    if let data = JSON["data"] as? [[String:Any]] {
                        print(data)
                        self.Kathatype = data
    
    
                        DispatchQueue.main.async {
                            self.newtable.reloadData()
                        }
                    }
                }  else {
    
                    AlertController.alert(message: (response?.validatedValue("message"))!)
                }
                self.newtable.reloadData()
            }
        }
    
    @IBAction func assignbtn(_ sender: UIButton) {
        self.mianview.isHidden = !self.mianview.isHidden
        self.newtable.isHidden = !self.newtable.isHidden
    }
    
    @IBAction func submitbtn(_ sender: UIButton) {
        ReceptionApi()
        removeData()
    }
    
    func removeData() {
        contactperson.text?.removeAll()
        contactmbl.text?.removeAll()
        assigntxt.text?.removeAll()
        citytxt.text?.removeAll()
        remarkstxt.text?.removeAll()
       
    }
}
extension BookforReceptionVc: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Kathatype.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = newtable.dequeueReusableCell(withIdentifier: "AssignListCell", for: indexPath) as! AssignListCell
        cell.AssignLbl.text = Kathatype[indexPath.row]["name"] as? String ?? ""
        
        if selectedRows.contains(indexPath.row) {
              cell.assignbtn.setImage(UIImage(named: "check"), for: .normal)
          } else {
              cell.assignbtn.setImage(UIImage(named: "Uncheck"), for: .normal)
          }
        cell.locationview.isHidden = true
        cell.assignbtn.tag = indexPath.row
        cell.assignbtn.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEmpcode = Kathatype[indexPath.row]["EmpCode"] as? String ?? ""
        let SelectedName = Kathatype[indexPath.row]["name"] as? String ?? ""
        assigntxt.text = SelectedName
        self.newtable.isHidden = true
        self.mianview.isHidden = true
    }
    
}
extension BookforReceptionVc: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if textField == contactmbl {
               let allowedCharacters = "0123456789"
               let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
               let typedCharacterSet = CharacterSet(charactersIn: string)
               let isNumeric = allowedCharacterSet.isSuperset(of: typedCharacterSet)
               return isNumeric
           } else if textField == contactperson {
               let allowedCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: " "))
               let typedCharacterSet = CharacterSet(charactersIn: string)
               let isAlphabetic = allowedCharacters.isSuperset(of: typedCharacterSet)
               return isAlphabetic
           }
           return true
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          
           textField.resignFirstResponder()
           return true
       }
      }
