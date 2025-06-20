//
//  NotificationVc.swift
//  SanskarEP
//
//  Created by Warln on 04/04/22.
//

import UIKit
import SDWebImage
import iOSDropDown

class NotificationVc: UIViewController , CustomAlertDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var grantView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationTxt: DropDown!
    @IBOutlet weak var tabview: UIView!
    @IBOutlet weak var notLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchbar: UISearchBar!
    
    var titleTxt: String?
    var notifyData : [Notify] = []
    var filteredDetails: [Notify] = []
    var locDetails = ["Ground Floor","Reception","Conference Room","Second Floor"]
    var selectNo: Int = 0
    var datalist = [[String:Any]]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLbl.text = titleTxt
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
        grantView.isHidden = true
        NotificationCenter.default.addObserver(forName: NSNotification.Name("NtCount"), object: nil, queue: nil) { [weak self] _ in
            self?.fetchData()
            
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewHomeVC") as? NewHomeVC {
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func clearBtnPressed(_ sender: UIButton) {
        removeNotify()
    }
    
    
    func fetchData() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async { Loader.showLoader() }
        
        APIManager.apiCall(postData: dict as NSDictionary, url: notifyList) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }

            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    if let jsonData = try? JSONSerialization.data(withJSONObject: JSON, options: []) {
                        do {
                            let decodedResponse = try JSONDecoder().decode(NotifyResponse.self, from: jsonData)
                            print("Decoded Data: ", decodedResponse.data)
                            self.notifyData = decodedResponse.data ?? []
                        } catch {
                            print("Decoding error: \(error)")
                        }
                    }
                } else {
                    print(response?["error"] as Any)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.updateNoNotificationLabel()
                    self.updateClearButtonVisibility()
                }
            }
        }
    }

    func updateNoNotificationLabel() {
        if notifyData.isEmpty {
            notLabel.text = "No data available"
            notLabel.isHidden = false
        } else {
            notLabel.isHidden = true
        }
    }

    private func updateClearButtonVisibility() {
            let shouldShowClearButton = !notifyData.isEmpty
            clearButton.isHidden = !shouldShowClearButton
        }
    
    func GuestAction(id: String,status: String,selectid: String? = nil,reason: String? = nil) {
        var dict = [String: Any]()
        dict["id"] = id
        dict["status"] = status
        dict["floor"] = selectid
        dict["reason"] = reason

        DispatchQueue.main.async { Loader.showLoader() }
        APIManager.apiCall(postData: dict as NSDictionary, url: guestAction) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }
            if let response = response, response["status"] as? Bool == true {
                AlertController.alert(message: response.validatedValue("message") as! String)
               
            } else {
                print(response?["error"] as Any)
            }
            self.tableView.reloadData()
        }
    }
    
    func resizedImage(named name: String, size: CGSize) -> UIImage? {
        guard let image = UIImage(named: name) else { return nil }
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func removeNotify() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: removeNote) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                DispatchQueue.main.async(execute: {Loader.hideLoader()})
                AlertController.alert(message: (response?.validatedValue("message"))!)
                self.fetchData()
            }else{
                print(response?["error"] as Any)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func didCompleteAction(with message: String) {
            self.navigationController?.popViewController(animated: true)
            showToast(message: message)
        self.tableView.reloadData()
        }
}

extension NotificationVc: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  isSearching ? filteredDetails.count : notifyData.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
                let data =  isSearching ? filteredDetails[indexPath.row] : notifyData[indexPath.row]
                if data.status == true {
                    cell.titleLbl.text = data.notification_title
                    cell.subTitleLbl.text = data.notification_content
                }else{
        
                }

        return cell
    }
}

extension NotificationVc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let appAction = UIContextualAction(style: .destructive, title: "Approve") {  (contextualAction, view, boolValue) in
               self.editData(at: indexPath)
           }
           
           appAction.backgroundColor = .systemBlue
           appAction.image = resizedImage(named: "check-mark", size: CGSize(width: 35, height: 35))
           
           let swipeActions = UISwipeActionsConfiguration(actions: [appAction])
           return swipeActions
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Reject") {  (contextualAction, view, boolValue) in
               self.deleteData(at: indexPath)
           }
           
           deleteAction.backgroundColor = .red
           deleteAction.image = resizedImage(named: "remove", size: CGSize(width: 35, height: 35))
           
           let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
           return swipeActions
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        let index = isSearching ? filteredDetails[indexPath.row] : notifyData[indexPath.row]
           
           if index.notification_type == "8" || index.notification_type == "9" {
               let vc = CustomAlert(nibName: "CustomAlert", bundle: nil)
               vc.imgName = index.notification_thumbnail
               vc.nameTxt = index.notification_content
               vc.type = index.notification_type
               vc.inoutkey = index.inOrOut
               vc.reqid = index.req_id
               vc.delegate = self
               vc.modalPresentationStyle = .overCurrentContext
               vc.modalTransitionStyle = .flipHorizontal
               present(vc, animated: true)
           } else if index.notification_type == "14" {
               let vc = LeaveNotificationAlert(nibName: "LeaveNotificationAlert", bundle: nil)
               vc.imgName = index.notification_thumbnail
               vc.nameTxt = index.notification_content
               vc.type = index.notification_type
               vc.leavetype = index.note_type
               vc.reqid = index.req_id
               vc.date = index.creation_date
               

               vc.modalPresentationStyle = .overCurrentContext
               vc.modalTransitionStyle = .flipHorizontal
               present(vc, animated: true)
           }
    }
   
//    func deleteData(at indexPath: IndexPath) {
//        let index = notifyData[indexPath.row]
//        if index.notification_type == "9"  {
//            let requestId = index.req_id != nil ? String(index.req_id!) : ""
//
//            GuestAction(id: requestId, status: "2", reason: "Not Aavaible")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.notifyData.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//        } else {
//            AlertController.alert(message: "You can not reject notifications.")
//        }
//    }
    
    func deleteData(at indexPath: IndexPath) {
        guard currentUser.Code == "H" else {
            AlertController.alert(message: "You do not have permission to reject notifications.")
            return
        }
        
        let index = notifyData[indexPath.row]
        if index.notification_type == "9"  {
            let requestId = index.req_id != nil ? String(index.req_id!) : ""
            
            GuestAction(id: requestId, status: "2", reason: "Not Available")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.notifyData.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else {
            AlertController.alert(message: "You can not reject notifications.")
        }
    }

    
//    func editData(at indexPath: IndexPath) {
//        let index = notifyData[indexPath.row]
//        if index.notification_type == "9" {
//            if let requestId = index.req_id {
//                GuestAction(id: String(requestId), status: "1", selectid: "1")
//                self.notifyData.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .fade)
//            } else {
//                print("Error: req_id is nil")
//            }
//        } else {
//            print("You can not approve notifications .")
//        }
//    }
    func editData(at indexPath: IndexPath) {
        guard currentUser.Code == "H" else {
            AlertController.alert(message: "You do not have permission to approve notifications.")
            return
        }
        
        let index = notifyData[indexPath.row]
        if index.notification_type == "9" {
            if let requestId = index.req_id {
                GuestAction(id: String(requestId), status: "1", selectid: "1")
                self.notifyData.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                print("Error: req_id is nil")
            }
        } else {
            print("You can not approve notifications.")
        }
    }


}
extension NotificationVc: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredDetails = notifyData
          
        } else {
            isSearching = true
            filteredDetails = notifyData.filter { data in
                return (data.notification_content?.lowercased() ?? "").contains(searchText.lowercased()) ||
                       (data.notification_title?.lowercased() ?? "").contains(searchText.lowercased())
            }
        }
        updateNoNotificationLabel()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        filteredDetails = notifyData
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}
