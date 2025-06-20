//
//  SheetViewController4.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 28/04/23.
//

import UIKit
//
class SheetViewController4: UIViewController,UISheetPresentationControllerDelegate {
//
//            //MARK: - IBOutlet
//            @IBOutlet weak var headerLbl: UILabel!
//            @IBOutlet weak var dateTxtField: UITextField!
//            @IBOutlet weak var nametextField: UITextField!
//            @IBOutlet weak var whomTxtField: UITextField!
//            @IBOutlet weak var reasonTxtView: UITextView!
//            //Mark:- Variable
//            var titleTxt: String?
//
//            override func viewDidLoad() {
//                super.viewDidLoad()
//
//                setup()
//                reasonTxtView.delegate = self
//
         }
////
////            func setup() {
////                reasonTxtView.text = "Reason For Meeting..."
////                reasonTxtView.textColor = .lightGray
////                headerLbl.text = titleTxt
////                reasonTxtView.layer.cornerRadius = 10
////                reasonTxtView.layer.borderWidth = 0.5
////                reasonTxtView.layer.borderColor = UIColor.lightGray.cgColor
////                reasonTxtView.clipsToBounds = true
////                datepicker()
////            }
//
//            func datepicker () {
//                let datePicker = UIDatePicker()
//                datePicker.datePickerMode = .dateAndTime
//                if #available(iOS 14.0, *) {
//                    datePicker.preferredDatePickerStyle = .wheels
//                } else {
//
//                }
//                datePicker.addTarget(self, action: #selector(datePickerValue(_:)), for: .valueChanged)
//                datePicker.frame.size = CGSize(width: 0, height: 250)
//                dateTxtField.inputView = datePicker
//            }
//
//            @objc
//            func datePickerValue(_ sender: UIDatePicker){
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                dateTxtField.text = dateFormatter.string(from: sender.date)
//            }
//
//            @IBAction func backBtnPressed(_ sender: UIButton) {
//
//                switch sender.tag {
//                case 17:
//                    self.navigationController?.popViewController(animated: true)
//                case 18:
//                    let vc = storyboard?.instantiateViewController(withIdentifier: "VistorHistoryVC") as! VistorHistoryVC
//                    navigationController?.pushViewController(vc, animated: true)
//                case 19:
//                    let vc = storyboard?.instantiateViewController(withIdentifier: "GuestHistoryVc") as! GuestHistoryVc
//                    navigationController?.pushViewController(vc, animated: true)
//                default:
//                    break
//                }
//
//            }
//
//
//            @IBAction func searchBtnPressed(_ sender: UIButton ) {
//                let vc = GuestHistoryVc()
//                navigationController?.pushViewController(vc, animated: true)
//            }
//
//            @IBAction func submitBtnPressed(_ sender: UIButton) {
//                if (dateTxtField.text! == "") && (nametextField.text! == "") && (whomTxtField.text! == "")  {
//                    AlertController.alert(message: "Please Enter the details")
//                }else{
//                    guestRequest()
//                }
//
//            }
//
//        }
//
//        //MARK: - Send Request to server
//
//        extension SheetViewController4 {
//
//            func guestRequest() {
//                var dict = Dictionary<String,Any>()
//                dict["EmpCode"] = currentUser.EmpCode
//                dict["Reason"] = reasonTxtView.text
//                dict["WhomtoMeet"] = whomTxtField.text!
//                dict["Guest_Name"] = nametextField.text!
//                dict["Date1"] = dateTxtField.text!
//                DispatchQueue.main.async(execute: {Loader.showLoader()})
//                APIManager.apiCall(postData: dict as NSDictionary, url: kGuestApi) { result, response, error, data in
//                    DispatchQueue.main.async(execute: {Loader.hideLoader()})
//                    if let _ = data,(response?["status"] as? Bool == true), response != nil {
//                        AlertController.alert(message: (response?.validatedValue("message"))!)
//                        self.removeData()
//                    }else{
//                        print(response?["error"] as Any)
//                    }
//                }
//            }
//
//            func removeData() {
//                whomTxtField.text?.removeAll()
//                nametextField.text?.removeAll()
//                dateTxtField.text?.removeAll()
//                reasonTxtView.text.removeAll()
//            }
//        }
//
//        //MARK: - UITextView Delegate
//
//        extension SheetViewController4: UITextViewDelegate {
//
//            func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//                let newText = (reasonTxtView.text as NSString).replacingCharacters(in: range, with: text)
//                let numberOfChars = newText.count
//                return numberOfChars < 200
//            }
//
//            func textViewDidBeginEditing(_ textView: UITextView) {
//
//                if reasonTxtView.textColor == UIColor.lightGray {
//                    reasonTxtView.text = ""
//                    reasonTxtView.textColor = UIColor.black
//                }
//            }
//
//            func textViewDidEndEditing(_ textView: UITextView) {
//
//                if reasonTxtView.text == "" {
//
//                    reasonTxtView.text = "Reason For Meeting..."
//                    reasonTxtView.textColor = UIColor.lightGray
//                }
//            }
//
//    }
//
//
//
//
//
