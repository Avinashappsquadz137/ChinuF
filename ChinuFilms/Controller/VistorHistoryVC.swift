//
//  VistorHistoryVC.swift
//  SanskarEP
//
//  Created by Warln on 23/04/22.
//

import UIKit
import Alamofire

class VistorHistoryVC: UIViewController, GuestformDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerTxt: UILabel!
    @IBOutlet weak var searchUIBar: UISearchBar!
    @IBOutlet weak var searchHolder: UIView!
    @IBOutlet weak var detailview: UIView!
    @IBOutlet weak var meetinglbl: UILabel!
    @IBOutlet weak var outtimelbl: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var guestbtn: UIButton!
    @IBOutlet weak var hidebtn: UIButton!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var Datetime: UITextField!
    @IBOutlet weak var retextview: UITextView!
    @IBOutlet weak var namelbl: UITextField!
    
    
    var titleText: String?
    var vistorList: [VistorList] = []
    var newList: [VistorList] = []
    var fromDate: String?
    var toDate: String?
    var isSearch: Bool = false
    var searchTap: Bool = false
    var selectedIndexPath: IndexPath?
    fileprivate let edittimePicker = UIDatePicker()
    
    var selectedId: String?
    var type = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "VistorCell", bundle: nil), forCellReuseIdentifier: "VistorCell")
        tableView.dataSource = self
        tableView.delegate = self
        searchUIBar.delegate = self
   //     headerTxt.text = "Vistor History"
        vistorApiHit()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.searchHolder.isHidden = true
        }, completion: nil)
        detailview.isHidden = true
        submit.layer.cornerRadius = 8
        datepicker()
        Datetime.layer.cornerRadius = 8
        Datetime.layer.borderWidth = 1.0
        Datetime.layer.borderColor = UIColor.lightGray.cgColor
        
        retextview.delegate = self
        
        retextview.layer.cornerRadius = 10
        
        
        retextview.clipsToBounds = true
        retextview.layer.borderWidth = 1.0
        retextview.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func didCompleteAction(with message: String) {
            self.navigationController?.popViewController(animated: true)
            showToast(message: message)
       
        }
    
    func datepicker () {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {

        }
        datePicker.addTarget(self, action: #selector(datePickerValue(_:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 250)
        Datetime.inputView = datePicker
    }
    
    @objc
    func datePickerValue(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        Datetime.text = dateFormatter.string(from: sender.date)
    }
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }

    @IBAction func hideviewbtn(_ sender: UIButton) {
        detailview.isHidden = true
    }

    @IBAction func submitbtn(_ sender: UIButton) {
        guestRequest()
        detailview.isHidden = true
        tableView.reloadData()
    }
    
    @IBAction func GuestBtnCLiclk(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GuestVc") as! GuestVc

      
        
        if #available(iOS 15.0, *) {
        if let sheet = vc.sheetPresentationController {
        var customDetent: UISheetPresentationController.Detent?
            if #available(iOS 16.0, *) {
            customDetent = UISheetPresentationController.Detent.custom { context in
                return 520
                
            }
            sheet.detents = [customDetent!]
            sheet.largestUndimmedDetentIdentifier = customDetent!.identifier
                }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 12
                            }
                        }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func searchBtnPressed(_ sender: UIButton ) {
        switch sender.tag{
        case 98:
            searchHolder.isHidden = false
        case 99:
            searchHolder.isHidden = true
        default:
            break
        }
    }
    
    @IBAction func hidebtn(_ sender: UIButton) {
        searchHolder.isHidden = true
    }

    func configure1(with model: VistorList ) {
        guard let url = URL(string: model.image ?? "") else {return}
        image.sd_setImage(
            with: url,
            placeholderImage: UIImage(systemName: "person.fill"),
            options: .refreshCached, completed: nil
        )
        namelbl.text = model.name
        meetinglbl.text = model.to_whome
        outtimelbl.text = model.mobile
        
        selectedId = model.id
    }
    
    @available(iOS 15.0, *)
    @IBAction func filterBtnPressed(_ sender: UIButton ) {
        let vc = FilterVC()
        vc.modalPresentationStyle = UIModalPresentationStyle.pageSheet
        vc.delegate = self
        guard let sheetController = vc.presentationController as? UISheetPresentationController else {
            return
        }
        sheetController.detents = [.medium()]
        sheetController.prefersGrabberVisible = true
        present(vc, animated: true)
        
    }
    
    @objc
    func AcceptOnClick(_ sender: UIButton) {
        let index = sender.tag
        let selectedModel: VistorList

        if isSearch {
            selectedModel = newList[index]
        } else {
            selectedModel = vistorList[index]
        }
        configure1(with: selectedModel) // Set the data for the labels
        detailview.isHidden = !detailview.isHidden // Toggle the visibility of detailview
        Datetime.text?.removeAll()
        retextview.text?.removeAll()
        tableView.reloadData()
    }

    func guestRequest() {
        var dict = Dictionary<String, Any>()
        dict["id"] = selectedId ?? ""
        dict["EmpCode"] = currentUser.EmpCode
        dict["Reason"] = retextview.text
        dict["WhomtoMeet"] = meetinglbl.text
        dict["Guest_Name"] = namelbl.text
        dict["Date1"] = Datetime.text
        dict["image"] = image.image?.resizeToWidth3(250)

        let url = BASEURL + "/" + kGuestApi
        DispatchQueue.main.async { Loader.showLoader() }

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in dict {
                if key == "image", let image = value as? UIImage, let imageData = image.pngData() {
                    let filename = "\(Int64(Date().timeIntervalSince1970 * 1000)).png"
                    multipartFormData.append(imageData, withName: key, fileName: filename, mimeType: "image/png")
                } else if let stringValue = value as? String, let data = stringValue.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: url, method: .post, headers: nil)
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { response in
            DispatchQueue.main.async { Loader.hideLoader() }
            switch response.result {
            case .success(let value):
                if let JSON = value as? NSDictionary, let status = JSON["status"] as? Bool {
                    let message = JSON["message"] as? String ?? "Unknown response"
                    AlertController.alert(message: message)
                    if status {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                if let err = error as? URLError, err.code == .notConnectedToInternet || err.code == .timedOut {
                    print("No Internet Connection or Request Timed Out")
                } else {
                    print("Upload Failed: \(error.localizedDescription)")
                }
            }
        }
    }

    
    func vistorApiHit() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
//        dict["fromDate"] = fromDate ?? ""
//        dict["toDate"] = toDate ?? ""
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        vistorList.removeAll()
        newList.removeAll()
        APIManager.apiCall(postData: dict as NSDictionary, url: vistorHistory) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            guard let data = data, error == nil else {
                AlertController.alert(message: error?.localizedDescription as? String ?? "")
                return
            }
            do{
                let json = try JSONDecoder().decode(VistorResponse.self, from: data)
                self.vistorList.append(contentsOf: json.data ?? [])
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }
    }

}

extension VistorHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch{
            return newList.count
        }else{
            return vistorList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VistorCell", for: indexPath) as? VistorCell else {
            return UITableViewCell()
        }
//        if isSearch {
//            cell.configure(with: newList[indexPath.row])
//        } else {
//            cell.configure(with: vistorList[indexPath.row])
//        }
//  
//        cell.penbtn.tag = indexPath.row
//        cell.penbtn.addTarget(self, action: #selector(AcceptOnClick(_:)), for: .touchUpInside)
//        cell.selectionStyle = .none
//         
//        type = vistorList[indexPath.row]["type"] as? Int ?? 0
//        if type == 1 {
//            cell.penbtn.isHidden = false
//        } else {
//            cell.penbtn.isHidden = true
//        }
//        
//        return cell
        let visitor: VistorList
           if isSearch {
               visitor = newList[indexPath.row]
           } else {
               visitor = vistorList[indexPath.row]
           }
           cell.configure(with: visitor)
           cell.penbtn.tag = indexPath.row
           cell.penbtn.addTarget(self, action: #selector(AcceptOnClick(_:)), for: .touchUpInside)
           cell.selectionStyle = .none
           cell.penbtn.isHidden = visitor.type != 1

           return cell
    }



    }



extension VistorHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}

extension VistorHistoryVC: FilterVCDelegate {
    func didGetDate(with start: String, with end: String) {
        DispatchQueue.main.async {
            self.fromDate = start
            self.toDate = end
            self.vistorApiHit()
        }
    }
    
}

extension VistorHistoryVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
           isSearch = false
    }
       
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
           isSearch = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            isSearch = false
            self.tableView.reloadData()
        }else{
            newList = vistorList.filter({ text in
                let temp: NSString = text.name as! NSString
                let range = temp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            if newList.count == 0 {
                isSearch = false
            }else{
                isSearch = true
            }
            self.tableView.reloadData()
        }
    }
}
extension VistorHistoryVC : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (retextview.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if retextview.textColor == UIColor.lightGray {
            retextview.text = ""
            retextview.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if retextview.text == "" {

            retextview.text = "Remark ..."
            retextview.textColor = UIColor.lightGray
        }
    }
}

