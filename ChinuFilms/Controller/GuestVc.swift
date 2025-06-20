//
//  GuestVc.swift
//  SanskarEP
//
//  Created by Warln on 13/01/22.
//


protocol GuestformDelegate: AnyObject {
    func didCompleteAction(with message: String)
}

import UIKit
import Alamofire

class GuestVc: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - IBOutlet
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var dateTxtField: UITextField!
    @IBOutlet weak var nametextField: UITextField!
    @IBOutlet weak var whomTxtField: UITextField!
    @IBOutlet weak var reasonTxtView: UITextView!
    @IBOutlet weak var Uimage: UIImageView!
    
    //Mark:- Variable
    var titleTxt: String?
    weak var delegate: GuestformDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTxtField.textColor == UIColor.lightGray
        nametextField.textColor == UIColor.lightGray
        whomTxtField.textColor == UIColor.lightGray
        setup()
        reasonTxtView.delegate = self

          //  whomTxtField.text = " " + currentUser.Name
            //whomTxtField.isUserInteractionEnabled = false
         
    }
    
    @IBAction func Backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    
    @IBAction func uploadimage(_ sender: UIButton) {
        let ac = UIAlertController(title: "Select Image", message: "Select Image from", preferredStyle: .actionSheet)
        let cameraBtn = UIAlertAction(title: "Camera", style: .default) {[weak self] (_) in self?.showImagePicker(selectedSource: .camera)
            
        }
        let GalleryBtn = UIAlertAction(title: "Gallery", style: .default) {[weak self] (_) in self?.showImagePicker(selectedSource: .photoLibrary)
        }
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cameraBtn)
        ac.addAction(GalleryBtn)
        ac.addAction(cancelBtn)
        self.present(ac,animated: true, completion: nil)
    }
    
    func setup() {
        reasonTxtView.text = "Reason For Meeting..."
        reasonTxtView.textColor = .lightGray
        headerLbl.text = titleTxt
        reasonTxtView.layer.cornerRadius = 10
        reasonTxtView.layer.borderWidth = 0.5
        reasonTxtView.layer.borderColor = UIColor.lightGray.cgColor
        reasonTxtView.clipsToBounds = true
        datepicker()
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
        dateTxtField.inputView = datePicker
    }
    
    @objc
    func datePickerValue(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateTxtField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
    
         //   dismiss(animated: true,completion: nil)
        
        switch sender.tag {
        case 17:
            self.navigationController?.popViewController(animated: true)
        case 18:
            let vc = storyboard?.instantiateViewController(withIdentifier: "VistorHistoryVC") as! VistorHistoryVC
           // navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        case 19:
            let vc = storyboard?.instantiateViewController(withIdentifier: "GuestHistoryVc") as! GuestHistoryVc
          //  navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        default:
            break
        }
        
    }
    
    
    @IBAction func searchBtnPressed(_ sender: UIButton ) {
        let vc = GuestHistoryVc()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
     
        if dateTxtField.text?.isEmpty ?? true {
               AlertController.alert(message: "Please enter the Date and Time")
               return
           }
           if nametextField.text?.isEmpty ?? true {
               AlertController.alert(message: "Please enter the Name")
               return
           }
           if whomTxtField.text?.isEmpty ?? true {
               AlertController.alert(message: "Please enter Address")
               return
           }
           if reasonTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || reasonTxtView.text == "Reason For Meeting..." {
               AlertController.alert(message: "Please enter the Reason")
               return
           }
        
           guestRequest()
       }
    func showImagePicker(selectedSource: UIImagePickerController.SourceType){
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            print("Selected Source not available")
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = false
        self.present(imagePickerController,animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            Uimage.image = selectedImage
        } else {
            print("Image not found")
        }
        picker.dismiss(animated: true,completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }

}

//MARK: - Send Request to server

extension GuestVc {
    func guestRequest() {
        var dict = [String: Any]()
        dict["EmpCode"] = currentUser.EmpCode
        dict["Reason"] = reasonTxtView.text ?? ""
        dict["Address"] = whomTxtField.text ?? ""
        dict["Guest_Name"] = nametextField.text ?? ""
        dict["Date1"] = dateTxtField.text ?? ""

        // Handle the image safely
        if let image = Uimage.image?.resizeToWidth3(250), let imageData = image.pngData() {
            dict["image"] = imageData
        }

        let url = BASEURL + "/" + kGuestApi
        DispatchQueue.main.async { Loader.showLoader() }

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in dict {
                if key == "image", let imageData = value as? Data {
                    let filename = "\(Int64(Date().timeIntervalSince1970 * 1000)).png"
                    multipartFormData.append(imageData, withName: key, fileName: filename, mimeType: "image/png")
                } else if let stringValue = "\(value)".data(using: .utf8) {
                    multipartFormData.append(stringValue, withName: key)
                }
            }
        }, to: url)
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseJSON { response in
            DispatchQueue.main.async { Loader.hideLoader() }

            switch response.result {
            case .success(let value):
                if let jsonResponse = value as? [String: Any], let status = jsonResponse["status"] as? Bool {
                    let message = jsonResponse["message"] as? String ?? "Unknown error"

                    if status {
                        DispatchQueue.main.async {
                            self.delegate?.didCompleteAction(with: message)
                            self.showToast(message: message)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.dismiss(animated: true)
                            }
                        }
                    } else {
                        AlertController.alert(message: message)
                    }
                } else {
                    AlertController.alert(message: "Invalid response format")
                }

            case .failure(let error):
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet || urlError.code == .timedOut {
                    print("Network error: \(urlError.localizedDescription)")
                } else {
                    print("Upload failed: \(error.localizedDescription)")
                }
            }
        }
    }


    
    func removeData() {
        whomTxtField.text?.removeAll()
        nametextField.text?.removeAll()
        dateTxtField.text?.removeAll()
        reasonTxtView.text.removeAll()
    
    }
}

//MARK: - UITextView Delegate

extension GuestVc: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (reasonTxtView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if reasonTxtView.textColor == UIColor.lightGray {
            reasonTxtView.text = ""
            reasonTxtView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if reasonTxtView.text == "" {

            reasonTxtView.text = "Reason For Meeting..."
            reasonTxtView.textColor = UIColor.lightGray
        }
    }
}
extension UIImage {
        func resizeToWidth3(_ width:CGFloat)-> UIImage {
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageView.image = self
            UIGraphicsBeginImageContext(imageView.bounds.size)
            imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result!
        }
    }
