//
//  SearcHvC.swift
//  SanskarEP
//
//  Created by Surya on 01/02/24.
//

import UIKit

class SearcHvC: UIViewController {

    @IBOutlet weak var searchview: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    var searchvalue =  ["Leave Request","Profile","Tour Detail","AllStatusVc","Your Visitor List","UpComing B'day","B'day Wishes","Advance","Submit Tour","Health Managment","Approved Tour","Stationary Request","Pay-Slip Request"]
    
    var filteredSearchValue = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let searchTextField = searchbar.value(forKey: "searchField") as? UITextField {
               searchTextField.textColor = UIColor.darkText
           }
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "searchCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        searchbar.delegate = self
        filteredSearchValue = searchvalue
        searchbar.layer.cornerRadius = 10
        searchbar.clipsToBounds = true
    }
    

    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    

}
extension SearcHvC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSearchValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchCell
        cell.SLabel.text = filteredSearchValue[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let selectedSearchResult = filteredSearchValue[indexPath.row]

        if let index = searchvalue.firstIndex(of: selectedSearchResult) {
            func presentCustomSheet(withIdentifier identifier: String, title: String? = nil, additionalConfig: ((UIViewController) -> Void)? = nil) {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier) {
                    // Dynamically set the title property if it exists
                    if let configurableVC = vc as? AnyObject {
                        if title != nil, configurableVC.responds(to: Selector("setTitleTxt:")) {
                            configurableVC.setValue(title, forKey: "titleTxt")
                        }
                    }

                    // iOS 15+ custom sheet presentation
                    if #available(iOS 15.0, *) {
                        if let sheet = vc.sheetPresentationController {
                            var customDetent: UISheetPresentationController.Detent?
                            if #available(iOS 16.0, *) {
                                customDetent = UISheetPresentationController.Detent.custom { _ in
                                    return 550
                                }
                                sheet.detents = [customDetent!]
                                sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                            }
                            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                            sheet.prefersGrabberVisible = true
                            sheet.preferredCornerRadius = 12
                        }
                    }
                    additionalConfig?(vc)

                    self.present(vc, animated: true, completion: nil)
                }
            }

            switch index {
            case 0:
                presentCustomSheet(withIdentifier: "NewAllLeaveReqVc")
//            case 1:
//                presentCustomSheet(withIdentifier: "LeaveCancel", title: searchvalue[indexPath.row])
            case 1:
                presentCustomSheet(withIdentifier: "ProfileVc")
            case 2:
                presentCustomSheet(withIdentifier: "TourVC", title: searchvalue[indexPath.row])
            case 3:
                presentCustomSheet(withIdentifier: "AllStatusVc")
//            case 5:
//                presentCustomSheet(withIdentifier: "GuestHistoryVc")
            case 4:
                presentCustomSheet(withIdentifier: "VistorHistoryVC")
            case 5:
                presentCustomSheet(withIdentifier: "BdayViewController")
            case 6:
                presentCustomSheet(withIdentifier: "MyBdayWishVc")
            case 7:
                presentCustomSheet(withIdentifier: "AdvcanceVC", title: searchvalue[indexPath.row])
            case 8:
                presentCustomSheet(withIdentifier: "AllDetail2VC")
            case 9:
                presentCustomSheet(withIdentifier: "HealthVc", title: searchvalue[indexPath.row])
            case 10:
                presentCustomSheet(withIdentifier: "ApprovedTourVC")
            case 11:
                presentCustomSheet(withIdentifier: "HealthVc", title: searchvalue[indexPath.row]) { vc in
                    if let healthVC = vc as? HealthVc {
                        healthVC.stat = true
                    }
                }
            case 12:
                presentCustomSheet(withIdentifier: "PaySlipVc", title: searchvalue[indexPath.row])
            default:
                print(index)
            }
        }
    }

}
extension SearcHvC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredSearchValue = searchvalue
        } else {
            filteredSearchValue = searchvalue.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        
        tableview.reloadData()
    }
}

