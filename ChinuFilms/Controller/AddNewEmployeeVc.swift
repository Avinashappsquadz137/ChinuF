//
//  AddNewEmployeeVc.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 20/06/23.
//

import UIKit
import iOSDropDown
import Alamofire

class AddNewEmployeeVc:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var imageview: UIImageView!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var dateTextField2: UITextField!
    @IBOutlet weak var menuTxtf: DropDown!
    @IBOutlet var NameTtxf: UITextField!
    @IBOutlet var EmailTtxf: UITextField!
    @IBOutlet var ContactTtxf: UITextField!
    @IBOutlet var PasswordTtxf: UITextField!
    @IBOutlet var PanTtxf: UITextField!
    @IBOutlet var AadharTtxf: UITextField!
    
    var mobile: String?

    fileprivate let pickerView = ToolbarPickerView()
    var eventName:[String] = []
    
    var item: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DepartApi()
        
    }
    
    
    @IBAction func BackBtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    
    func setup() {
        print(eventName)
        menuTxtf.optionArray = eventName
        menuTxtf.isSearchEnable = true
        menuTxtf.listHeight = 150
        menuTxtf.didSelect { selectedText, index, id in
            self.menuTxtf.text = selectedText
            self.item = selectedText
        }
    }
    func DepartApi() {
        var dict = Dictionary<String,Any>()
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: DeptApi) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    let data = (JSON["data"] as? [[String : Any]] ?? [[:]])
                    // Now you have the JSON data as an array of dictionaries
                    // You can work with the jsonArray here
                //    print(jsonArray)
                   print(data)
                    let names = data.compactMap { $0["DeptName"] as? String }
                    print(names)
                    self.eventName = names
                
                    self.setup()
                   print(self.eventName)
               }else{
                  print(response?["error"] as Any)
                }
               
            }
        }
    }
    
    
    func removeData() {
        
        item?.removeAll()
        menuTxtf.text?.removeAll()
    }
    

        
    @IBAction func submitButton(_ sender: Any) {
        
        if let contact = ContactTtxf.text, let date = dateTextField.text, let date1 = dateTextField2.text, let pan = PanTtxf.text, let aadhar = AadharTtxf.text, let email = EmailTtxf.text {
            if (contact == "") && (date == "") && (date1 == "") && (pan == "") && (aadhar == "") && (email == "")  {
                AlertController.alert(message: "Please enter detail")
            }else if (contact.isNumeric() == false) && (aadhar.isNumeric() == false){
                AlertController.alert(message: "Please enter in digit")
            }else{
                submitApi()
            }
        }
    }
        
        
        

//MARK: - Login Api
    
    func submitApi() {
        var dict = [String: Any]()
        dict["Name"] = NameTtxf.text ?? ""
        dict["CntNo"] = ContactTtxf.text ?? ""
        dict["Dob"] = dateTextField2.text ?? ""
        dict["Dept"] = menuTxtf.text ?? ""
        dict["Doj"] = dateTextField.text ?? ""
        dict["Email"] = EmailTtxf.text ?? ""
        dict["Password"] = PasswordTtxf.text ?? ""
        dict["Pan"] = PanTtxf.text ?? ""
        dict["Aadhar"] = AadharTtxf.text ?? ""

        // Safely handle the image upload
        if let image = imageview.image?.resizetoimage(250), let imageData = image.pngData() {
            dict["image"] = imageData
        }

        let url = BASEURL + "/" + AddEmpApi
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
            DispatchQueue.main.async {
                Loader.hideLoader()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? NSDictionary, let status = JSON["status"] as? Bool, status {
                        print("Response JSON:", JSON)
                    } else {
                        print("Upload failed or incorrect response format")
                    }
                case .failure(let error):
                    print("Upload Failed: \(error.localizedDescription)")
                }
            }
        }
    }

    
    @IBAction func AddImage(_ sender: Any) {
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
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
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
            imageview.image = selectedImage
        } else {
            print("Image not found")
        }
        picker.dismiss(animated: true,completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
    
    
    @IBAction func dateBtnPressed(_ sender: Any) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.dateTextField.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
        
    }
    
    @IBAction func dateTextField2(_ sender: Any) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.dateTextField2.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
}
extension AddNewEmployeeVc: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.eventName.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.eventName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.menuTxtf.text = self.eventName[row]
    }
}
    extension AddNewEmployeeVc: ToolbarPickerViewDelegate {
        func didTapDone() {
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
            self.menuTxtf.text = self.eventName[row]
            self.item = self.eventName[row]
            self.menuTxtf.resignFirstResponder()
        }
        
        func didTapCancel() {
            self.menuTxtf.text = nil
            self.menuTxtf.resignFirstResponder()
        }
    }
extension UIImage {
    func resizetoimage(_ width:CGFloat)-> UIImage {
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

    

