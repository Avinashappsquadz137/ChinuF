//
//  RequestTourApprovalVc.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 20/06/23.
//

import UIKit
import Alamofire
import MobileCoreServices

class RequestTourApprovalVc: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var imageview: UIImageView!
    @IBOutlet var amount: UITextField!
    @IBOutlet var tourid: UITextField!
    @IBOutlet var MyTableView: UITableView!
    @IBOutlet var BtnLbl: UIButton!
    
    @IBOutlet var dropbtn: UIButton!
    //
    var TourId = [String]()
    fileprivate let pickerView = ToolbarPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(TourId)
        
        
        MyTableView.isHidden = true
        
        MyTableView.delegate = self
        MyTableView.dataSource = self
        
    }
    
    
    @IBAction func backbutton(_ sender: Any) {
        dismiss(animated: true,completion: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func ArrowButton(_ sender: Any) {
        if MyTableView.isHidden {
            animate(toggle: true)
        } else {
            animate(toggle: false)
            
            //  self.MyTableView.isHidden = !self.MyTableView.isHidden
        }
    }
    func animate(toggle:Bool) {
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.MyTableView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.MyTableView.isHidden = true
            }
        }
    }
    
    
    @IBAction func AddImage(_ sender: Any) {
        let ac = UIAlertController(title: "Select Image", message: "Select Image from", preferredStyle: .actionSheet)
        //             let cameraBtn = UIAlertAction(title: "Camera", style: .default) {[weak self] (_) in self?.showImagePicker(selectedSource: .camera)
        func openCamera() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera not available.")
            }
        }
        func openGallery() {
            
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            present(imagePicker, animated: true, completion: nil)
        }
        //        }
        //        let GalleryBtn = UIAlertAction(title: "Gallery", style: .default) {[weak self] (_) in self?.showImagePicker(selectedSource: .photoLibrary)
        //        }
        //        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //        ac.addAction(cameraBtn)
        //        ac.addAction(GalleryBtn)
        //        ac.addAction(cancelBtn)
        //        self.present(ac,animated: true, completion: nil)
        //    }
        //
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
            if let pickedImage = info[.originalImage] as? UIImage {
                imageview.image = pickedImage
            }
            picker.dismiss(animated: true,completion: nil)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true,completion: nil)
        }
        
    }
    @IBAction func SubmitBtn(_ sender: Any) {
        var dict = [String: Any]()
        dict["EmpCode"] = currentUser.EmpCode
        dict["Amount"] = "500"
        dict["Tour_id"] = "TR/2023/IT/8090"
        dict["Date1"] = "2023-06-19"
        
        // Safely handle the image upload
        if let image = imageview.image?.resizeToWidth(250), let imageData = image.pngData() {
            dict["image"] = imageData
        }
        
        let url = BASEURL + "/" + ptourApi
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
}
    extension RequestTourApprovalVc: UITableViewDelegate,UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return TourId.count
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = MyTableView.dequeueReusableCell(withIdentifier: "droptourTableViewCell", for: indexPath) as! droptourTableViewCell
            cell.lbl?.text = TourId[indexPath.row]
            print(cell.lbl.text)
            return cell
    
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath)
            dropbtn.setTitle("\(TourId[indexPath.row])",for:.normal)
            animate(toggle: false)
        }
    
    }
//    extension UIImage {
//        func resizeToWidth(_ width:CGFloat)-> UIImage {
//            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
//            imageView.contentMode = UIView.ContentMode.scaleAspectFit
//            imageView.image = self
//            UIGraphicsBeginImageContext(imageView.bounds.size)
//            imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
//            let result = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return result!
//        }
//    }


