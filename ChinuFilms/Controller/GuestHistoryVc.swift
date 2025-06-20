//
//  GuestHistoryVc.swift
//  SanskarEP
//
//  Created by Warln on 16/04/22.
//

import UIKit

class GuestHistoryVc: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerTxt: UILabel!
    
    var titleTxt: String?
    var guestList = [GuestList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "GuestCell", bundle: nil), forCellReuseIdentifier: "GuestCell")
        headerTxt.text = "Guest History"
        tableView.dataSource = self
        tableView.delegate = self
        hitGeustApi()

    }
    
    @IBAction func backBtnPressed(_ sender: UIButton ) {
        dismiss(animated: true,completion: nil)
      //  self.navigationController?.popViewController(animated: true)
    }
    
    func hitGeustApi() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: guestHistory) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            guard let data = data, error == nil else {
                AlertController.alert(message: error?.localizedDescription ?? "")
                return
            }
            do{
                let json = try JSONDecoder().decode(GuestResponse.self, from: data)
                self.guestList.append(contentsOf: json.data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                print(error.localizedDescription)
            }
        }
    }


}


extension GuestHistoryVc: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GuestCell", for: indexPath) as? GuestCell else {
            return UITableViewCell()
        }
        cell.configure(with: guestList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

extension GuestHistoryVc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
