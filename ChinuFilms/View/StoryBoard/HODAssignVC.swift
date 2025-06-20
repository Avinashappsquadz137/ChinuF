//
//  HODAssignVC.swift
//  SanskarEP
//
//  Created by Surya on 19/10/24.
//
import UIKit

class HODAssignVC: UIViewController {
    
    @IBOutlet weak var graphicstable: UITableView!
    @IBOutlet weak var assigntext: UITextField!
    @IBOutlet weak var remarks: UITextView!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var venulbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var channellbl: UILabel!
    @IBOutlet weak var Typelbl: UILabel!
    @IBOutlet weak var nestedTable: UITableView!
    
    var assignToDict: [String: String] = [:]
    var assigndata = [[String: Any]]()
    var Datalist: [String: Any]?
    var kathaId: String?
    var promoCounts: [String: Int] = [:]
    var selecteempcode: String?
    var selectedempname: String?
    var selectedEmployeeNames: [Int: String] = [:]
    var selectedEmployeeCodes: [Int: String] = [:]


    override func viewDidLoad() {
        super.viewDidLoad()

        graphicstable.dataSource = self
        graphicstable.delegate = self

        nestedTable.dataSource = self
        nestedTable.delegate = self
        nestedTable.isHidden = true
        
        submitbtn.layer.cornerRadius = 10
        submitbtn.clipsToBounds = true

        graphicstable.register(UINib(nibName: "AssignLitstCell", bundle: nil), forCellReuseIdentifier: "AssignLitstCell")
        KathForAssignApi()

        if let data = Datalist {
            namelbl.text = data["Name"] as? String ?? ""
            venulbl.text = data["Venue"] as? String ?? ""
            timelbl.text = data["SlotTiming"] as? String ?? ""
            datelbl.text = "\(data["Katha_from_Date"] as? String ?? "") to \(data["Katha_date"] as? String ?? "")"
            kathaId = String(describing: data["Katha_id"] as? Int ?? 0)
        
            channellbl.text = data["ChannelName"] as? String ?? ""

            Typelbl.text = data["Promo_Name"] as? String ?? ""

            if let promoNames = data["Promo_Name"] as? String {
                let promoList = promoNames.components(separatedBy: ", ")
                for promo in promoList {
                    promoCounts[promo, default: 0] += 1
                }
            }
        }
    }

    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    func KathForAssignApi() {
        var dict = [String: Any]()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async { Loader.showLoader() }
        APIManager.apiCall(postData: dict as NSDictionary, url: AssignPeopleAPi) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                if let dataArray = responseData["data"] as? [[String: Any]] {
                    self.assigndata = dataArray
                    self.graphicstable.reloadData()
                    self.nestedTable.reloadData()
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }

    func SubmitApi() {
        var dict = [String: Any]()
        dict["EmpCode"] = currentUser.EmpCode
        dict["katha_id"] = kathaId ?? ""

        // Prepare the "assign_to" dictionary based on graphicstable data
      
        
        for (index, promo) in promoCounts.keys.enumerated() {
            if let empCode = selectedEmployeeCodes[index] {
                assignToDict[promo] = empCode
            }
        }

        // Convert the dictionary to a JSON-like string for "assign_to"
        let jsonData = try? JSONSerialization.data(withJSONObject: assignToDict, options: .prettyPrinted)
        let jsonString = String(data: jsonData!, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "") ?? ""
        dict["assign_to"] = jsonString

        print("Request: \(dict)")

        DispatchQueue.main.async { Loader.showLoader() }
        APIManager.apiCall(postData: dict as NSDictionary, url: HODAssignSubmit) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                AlertController.alert(message: (response?.validatedValue("message"))!)
            } else {
                print(response?["error"] as Any)
                // Optional: Display error message from response
                // AlertController.alert(message: (response?.validatedValue("message"))!)
            }
        }
    }


    @objc func Checkboxtapped(_ sender: UIButton) {
        nestedTable.tag = sender.tag
        self.nestedTable.isHidden = !self.nestedTable.isHidden
    }
    
    @IBAction func submitbtn(_ sender: UIButton) {
        SubmitApi()
    }
}

extension HODAssignVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == graphicstable {
            return promoCounts.count
        } else if tableView == nestedTable {
            return assigndata.count
        } else {
            return 0
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == graphicstable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AssignLitstCell", for: indexPath) as! AssignLitstCell
            let promo = Array(promoCounts.keys)[indexPath.row]
            cell.datalabel?.text = promo
            cell.nestedbtn.tag = indexPath.row
            cell.nestedbtn.addTarget(self, action: #selector(Checkboxtapped(_:)), for: .touchUpInside)
            cell.nestedtext.text = selectedEmployeeNames[indexPath.row] ?? ""
            
            return cell
        } else if tableView == nestedTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeListCell", for: indexPath)
            cell.textLabel?.text = assigndata[indexPath.row]["name"] as? String ?? ""
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == nestedTable {
            let selectedCode = assigndata[indexPath.row]["EmpCode"] as? String ?? ""
            let selectedName = assigndata[indexPath.row]["name"] as? String ?? ""
            selectedEmployeeCodes[tableView.tag] = selectedCode
            selectedEmployeeNames[tableView.tag] = selectedName
            nestedTable.isHidden = true
            graphicstable.reloadRows(at: [IndexPath(row: tableView.tag, section: 0)], with: .none)
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == graphicstable {
            return 67
        } else if tableView == nestedTable {
            return 40
        }
       return 0
    }
}


