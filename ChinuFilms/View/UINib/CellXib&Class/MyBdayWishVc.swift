//
//  MyBdayWishVc.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 20/06/23.
//

import UIKit

class MyBdayWishVc: UIViewController {
    var datalist = [[String:Any]]()
        
        var imageData = String()
        var EmpData = String()
        var sent_by = String()
        var imageurl = "https://ep.sanskargroup.in/uploads/"
 //   "https://employee.sanskargroup.in/EmpImage/"

    @IBOutlet var Table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        Table.register(UINib(nibName: "bdayreplycell", bundle: nil), forCellReuseIdentifier: "bdayreplycell")
        
        Table.delegate = self
        Table.dataSource = self
        bdaydata()
    
    }
 
    @IBAction func backbutton(_ sender: Any) {
        dismiss(animated: true,completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func ButtonTapped(_ sender: Any) {
//        let birthday = self.storyboard?.instantiateViewController(withIdentifier: "BdayMessageVc") as! BdayMessageVc
//    self.navigationController?.pushViewController(birthday, animated: true)
//    }
    func bdaydata() {
            var dict = Dictionary<String,Any>()
            dict["EmpCode"] = currentUser.EmpCode
            DispatchQueue.main.async(execute: {Loader.showLoader()})
            APIManager.apiCall(postData: dict as NSDictionary, url: BdaywishesApi) { result, response, error, data in
                DispatchQueue.main.async(execute: {Loader.hideLoader()})
             
                if let JSON = response as? NSDictionary {
                    if JSON.value(forKey: "status") as? Bool == true {
                        print(JSON)
                        let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                        print(data)
                        
                        self.datalist = data
                        print(self.datalist)
    //                    for i in 0..<self.datalist.count{
    //                        let na = (self.datalist[i]["Name"] as? String ?? "" )
    //                        print(na)
    //                        self.name.append(na)
    //                        print(self.name)
    //
    //                    }
                        self.Table.reloadData()
                    }
                }
                
            }
        }
    }
    extension MyBdayWishVc:UITableViewDelegate,UITableViewDataSource
    {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return datalist.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = Table.dequeueReusableCell(withIdentifier: "bdayreplycell", for: indexPath) as! bdayreplycell
            print(datalist)

            let bdayData = datalist[indexPath.row]["BDay"] as? [String:Any] ?? [:]
            let nameData = datalist[indexPath.row]["sender_name"] as? String ?? ""
            imageData = datalist[indexPath.row]["image"] as? String ?? ""
            EmpData = datalist[indexPath.row]["message"] as? String ?? ""
            sent_by = datalist[indexPath.row]["sent_by"] as? String ?? ""


           // let date = bdayData["date"] as? String ?? ""

            print(bdayData)
            print(nameData)
            print(imageData)
            print(EmpData)
            print(sent_by)
            cell.lblname.text = nameData
            cell.lblmsg.text = EmpData
           let img = imageData.replacingOccurrences(of: " ", with: "%20")
           print(img)
            cell.imageview.sd_setImage(with: URL(string: img))
            //   profile.sd_setImage(with: URL(string: img)
            cell.lblmsg.text = EmpData
            cell.lblmsg.numberOfLines = 0
                
                // Add tap gesture recognizer to lblmsg
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(messageLabelTapped(_:)))
                cell.lblmsg.addGestureRecognizer(tapGesture)
                cell.lblmsg.isUserInteractionEnabled = true

            return cell
        }
        @objc func messageLabelTapped(_ sender: UITapGestureRecognizer) {
            guard let label = sender.view as? UILabel, let message = label.text else {
                return
            }
            // Show an alert or expand the cell to display the full message
            let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BdayMessageVc") as! BdayMessageVc
            vc.sent_bycode = sent_by
            imageData = datalist[indexPath.row]["image"] as? String ?? ""
            let nameData = datalist[indexPath.row]["sender_name"] as? String ?? ""
            EmpData = datalist[indexPath.row]["message"] as? String ?? ""
            vc.imaged = imageData
            print(vc.imaged)
            vc.message = EmpData
            vc.empname = nameData
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
            self.present(vc, animated: true)
         
           
          //  present(vc, animated: true)
           
        }
        
    }


