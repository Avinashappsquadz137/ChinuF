//
//  ClientDetailVC.swift
//  SanskarEP
//
//  Created by Surya on 01/05/24.
//

import UIKit
import Alamofire

class ClientDetailVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var kathaLbl: UILabel!
    @IBOutlet weak var VenueLbl: UILabel!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var todate: UILabel!
    @IBOutlet weak var LtterAddBtn: UIButton!
    @IBOutlet weak var SubmitBtn: UIButton!
    @IBOutlet weak var AddclientBtn: UIButton!
    @IBOutlet weak var addletter: UILabel!
    @IBOutlet weak var clientTable: UITableView!
    
    var Datalist: [String:Any]?
    var selectedPDFURL: URL?
    var selectedImage: UIImage?
    var panFiles: [Int: URL] = [:]
    var gstFiles: [Int: URL] = [:]
    var type = Int()
    var numberOfCells = 1
    var clientnamelits = [[String:Any]]()
    var selectedName: String?
    var selectedPanCard: String?
    var selectedGST: String?
    var selectedClient: Int?
    var filteredNameData = [[String: Any]]()
    var kathaId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "clientCell", bundle: nil), forCellReuseIdentifier: "clientCell")
        
        tableview.dataSource = self
        tableview.delegate = self
        ClientNameApi()
        
        clientTable.dataSource = self
        clientTable.delegate = self
        clientTable.isHidden = true
        
        view1.layer.cornerRadius = 8
        LtterAddBtn.layer.cornerRadius = 8
        LtterAddBtn.isHidden = true
        addletter.isHidden = true
        AddclientBtn.isHidden = true
        SubmitBtn.layer.cornerRadius = 8
        AddclientBtn.layer.cornerRadius = 8
        
        if let data = Datalist {
            kathaLbl.text = data["Name"] as? String ?? ""
            VenueLbl.text = data["Venue"] as? String ?? ""
            TimeLbl.text = data["SlotTiming"] as? String ?? ""
            todate.text = data["Katha_date"] as? String ?? ""
            fromDate.text = data["Katha_from_Date"] as? String ?? ""
            kathaId = String(describing: data["Katha_id"] as? Int ?? 0)
        }
    }
    
    @IBAction func submitbtn(_ sender: UIButton) {
        Submitapi()
    }
  

    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func Submitapi() {
        var dict = [String: Any]()
        dict["EmpCode"] = currentUser.EmpCode
        dict["katha_id"] = kathaId
        dict["address"] = ""
        dict["addharcard"] = ""

        // Extract cell values
        if let cell = tableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? clientCell {
            dict["name"] = cell.clintname.text ?? ""
            dict["gst_no"] = cell.GSTText.text ?? ""
            dict["pancard"] = cell.PanText.text ?? ""
        }

        // Set client ID
        dict["client_ID"] = selectedClient != nil ? "\(selectedClient!)" : "0"
        
        DispatchQueue.main.async { Loader.showLoader() }

        APIManager.apiCall(postData: dict as NSDictionary, url: clientdetailApi) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }
            if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true {
                print(JSON)
                if let data = JSON["data"] as? [[String: Any]] {
                    print(data)
                    AlertController.alert(message: (response?.validatedValue("message"))!)
                }
            } else {
                let message = response?.validatedValue("message") as? String ?? "Something went wrong."
                AlertController.alert(message: message)
            }
        }
    }

    func ClientNameApi() {
        var dict = [String: Any]()
        dict["EmpCode"] = currentUser.EmpCode
        dict["searchTerm"] = ""
        
        DispatchQueue.main.async { Loader.showLoader() }
        APIManager.apiCall(postData: dict as NSDictionary, url: clientnameApi) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }
            if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true {
                print(JSON)
                if let data = JSON["data"] as? [[String:Any]] {
                    print(data)
                    self.clientnamelits = data
                    self.filteredNameData = data
                    DispatchQueue.main.async { self.clientTable.reloadData() }
                }
            } else {
                AlertController.alert(message: response?.validatedValue("message") ?? "An error occurred.")
            }
            self.clientTable.reloadData()
        }
    }
}

extension ClientDetailVC: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableview {
            return numberOfCells
        } else if tableView == clientTable {
            return filteredNameData.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableview {
            let cell = tableview.dequeueReusableCell(withIdentifier: "clientCell", for: indexPath) as! clientCell
            cell.clintname.delegate = self
            cell.clintname.tag = indexPath.row
            cell.clintname.text = selectedName
            cell.PanText.text = selectedPanCard
            cell.GSTText.text = selectedGST
            return cell
        } else if tableView == clientTable {
            let cell1 = clientTable.dequeueReusableCell(withIdentifier: "clientname", for: indexPath)
            cell1.textLabel?.text = filteredNameData[indexPath.row]["name"] as? String ?? ""
            return cell1
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == clientTable {
            selectedName = filteredNameData[indexPath.row]["name"] as? String ?? ""
            selectedPanCard = filteredNameData[indexPath.row]["pancard"] as? String ?? ""
            selectedGST = filteredNameData[indexPath.row]["gst_no"] as? String ?? ""
            selectedClient = filteredNameData[indexPath.row]["client_id"] as? Int ?? 0
            clientTable.isHidden = true
            tableview.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableview {
            return 245
        } else if tableView == clientTable {
            return 35
        }else {
            return 245
        }

    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let point = textField.superview?.convert(textField.center, to: tableview),
              let indexPath = tableview.indexPathForRow(at: point),
              let cell = tableview.cellForRow(at: indexPath) as? clientCell else { return true }

        if textField == cell.clintname {
            let allowedCharacters = CharacterSet.letters.union(CharacterSet.whitespaces)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let isAlphabetic = allowedCharacters.isSuperset(of: typedCharacterSet)

            guard let currentText = textField.text else { return true }
            guard let rangeOfText = Range(range, in: currentText) else { return true }

            let updatedText = currentText.replacingCharacters(in: rangeOfText, with: string)
            filterSantData(with: updatedText)
            clientTable.isHidden = filteredNameData.isEmpty || updatedText.isEmpty
            
            return isAlphabetic
        }
        return true
    }

    func filterSantData(with text: String) {
        if text.isEmpty {
            filteredNameData = clientnamelits
        } else {
            filteredNameData = clientnamelits.filter {
                ($0["name"] as? String ?? "").lowercased().contains(text.lowercased())
            }
        }
        clientTable.reloadData()
    }
}
