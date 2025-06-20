//
//  TourAppVC.swift
//  SanskarEP
//
//  Created by Surya on 18/10/23.
//

import UIKit
import Alamofire
import PhotosUI

class TourAppVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var amntTxt: UITextField!
    @IBOutlet var TourTxt: UITextField!
    @IBOutlet weak var resonTxtview: UITextView!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var updatebtn: UIButton!
    @IBOutlet weak var addimagebutton: UIButton!
    @IBOutlet weak var tourlbl: UILabel!
    @IBOutlet weak var locationlbl: UILabel!
    @IBOutlet weak var eventlbl: UILabel!
    @IBOutlet weak var totalamnt: UILabel!
    @IBOutlet weak var tokenview: UIView!
    @IBOutlet weak var previewbtn: UIButton!
    @IBOutlet weak var previewview: UIView!
    @IBOutlet weak var tableview1: UITableView!
    @IBOutlet weak var previewtourid: UILabel!
    @IBOutlet weak var previewlocation: UILabel!
    @IBOutlet weak var preamount: UILabel!
    @IBOutlet weak var preeventname: UILabel!
    @IBOutlet weak var previewbbtn: UIButton!
    
    
    var selectedIndex: Int?
    var isImageSelected = false
    
    var totalAmount: Double = 0.0
    
    var TourImageData  = String()
    var TourId = [String]()
    var item: String?
    var datalist = [[String:Any]]()
    var alldata = [[String:Any]]()
    var DataList = [[String:Any]]()
    var imageData = String()
    var Serial = [Int]()
    var tour = String()
    var serials = Int()
    var editTour = String()
    var amountdata = String()
    var editamount = String()
    var editimage = String()
    var editreason = String()
    var edit = 0
    var updateVariable = Int()
    var tourD = String()
    var tourback  = ""
    var location  = ""
    var tourt     = ""
    var imageurl  = "https://sap.sanskargroup.in/uploads/tour/"
    var buttontitle = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
 //       TourTxt.text = location
        DetailsApi()
        newDetailApi()
        resonTxtview.delegate = self
        setup()
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview1.delegate = self
        tableview1.dataSource = self
        
        tableview.register(UINib(nibName: "TourDetailsCell", bundle: nil), forCellReuseIdentifier: "TourDetailsCell")
        tableview1.register(UINib(nibName: "previewTableViewCell", bundle: nil), forCellReuseIdentifier: "previewTableViewCell")
        
        self.tableview.reloadData()
        self.tableview1.reloadData()
        
        updatebtn.isHidden = true
        
        tourlbl.text = tourback
        previewlocation.text = location
        preamount.text = location
        
        previewtourid.text = tourback
        locationlbl.text = location
     //   eventlbl.text = location
        previewview.isHidden = true
        
        updateTotalAmount()
        
    }
    func setup() {
        
        resonTxtview.textColor = .black
        resonTxtview.layer.cornerRadius = 10
        resonTxtview.layer.borderWidth = 0.5
        // resonTxtview.layer.borderColor = UIColor.lightGray.cgColor
        resonTxtview.clipsToBounds = true
        
        amntTxt.textColor = .black
        amntTxt.layer.cornerRadius = 10
        amntTxt.layer.borderWidth = 0.5
        amntTxt.clipsToBounds = true
        
   
        tokenview.layer.cornerRadius = 10
        tokenview.clipsToBounds = true
        
        submitbtn.layer.cornerRadius = 10
        submitbtn.clipsToBounds = true
        
        savebtn.layer.cornerRadius = 10
        savebtn.clipsToBounds = true
        
        updatebtn.layer.cornerRadius = 10
        updatebtn.clipsToBounds = true
        
        tableview.layer.cornerRadius = 10
        tableview.clipsToBounds = true
        
        previewbtn.layer.cornerRadius = 10
        previewbtn.clipsToBounds = true
        
        previewbbtn.layer.cornerRadius = 10
        previewbbtn.clipsToBounds = true
        
        previewview.layer.cornerRadius = 10
        previewview.clipsToBounds = true
        
        }
    
    func removeData() {
        imageView.image = nil
        amntTxt.text?.removeAll()
        
    //    TourTxt.text?.removeAll()
        resonTxtview.text.removeAll()
        
    }
    

    func updateTotalAmount() {
           
           for data in datalist {
               if let amountString = data["Amount"] as? String, let amount = Double(amountString) {
                   totalAmount += amount
               }
           }
           totalamnt.text = "₹ " + "\(totalAmount)"
           preamount.text = "₹ " + "\(totalAmount)"
       }
  
   
   
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func previewbackbtn(_ sender: UIButton) {
        previewview.isHidden = true
    }
    
    @IBAction func SubmitBtn(_ sender: Any) {
        
                let alertController = UIAlertController(title: "Submit", message: "Once You Have Submit, Then You Cannot Any Change.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.FinalSbmit()
                    print("Submit button pressed")
                    self.dismiss(animated: true, completion: nil)
                }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel button pressed")
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            }
      
    @IBAction func previewbtn(_ sender: UIButton) {
        previewview.isHidden = !previewview.isHidden
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
                imageView.image = selectedImage
                isImageSelected = true
                // Hide the button image
                addimagebutton.setImage(nil, for: .normal)
            } else {
                print("Image not found")
            }
            picker.dismiss(animated: true, completion: nil)
        }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
    
    @objc
    func editOnclick(_ sender: UIButton) {
        
        updatebtn.isHidden = false
        let row = sender.tag
        editamount = datalist[row]["Amount"] as? String ?? ""
        editimage = datalist[row]["Billing_thumbnail"] as? String ?? ""
        editreason = datalist[row]["reason"] as? String ?? ""
        updateVariable = datalist[row]["Sno"] as? Int ?? 0
        
        setData(amo: editamount, ing: editimage, rea: editreason)
        
        tableview.reloadData()
    }
    func setData(amo: String, ing: String, rea: String) {
        amntTxt.text = amo
        resonTxtview.text = rea
        imageView.sd_setImage(with: URL(string: imageurl + ing))
    }
    @objc func deleteOnClick(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        DeleteApi(indexPath: indexPath)
    }
        
  
    func DeleteApi(indexPath: IndexPath) {
        guard indexPath.row < datalist.count else {
            return
        }

        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "OK", style: .destructive) { [weak self] (action) in
            let row = indexPath.row
            let serialToDelete = self?.datalist[row]["Sno"] as? Int ?? 0
            self?.performDeleteOperation(serial: serialToDelete, indexPath: indexPath)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    @IBAction func savebtn(_ sender: UIButton) {

        if isImageSelected {
            // Set the button image
            if let yourImage = UIImage(named: "more") {
                // Set the button image with increased size
                addimagebutton.setImage(yourImage, for: .normal)
                addimagebutton.imageView?.contentMode = .scaleAspectFit
                addimagebutton.tintColor = UIColor.black // Set the desired color for the image
            }

            isImageSelected = false
        }
           savebtn.isHidden = false
           updatebtn.isHidden = true
           ApiHit()
           removeData()
           DetailsApi()
           tableview.reloadData()
    }
    
    
    @IBAction func Updatebtn(_ sender: UIButton) {
        savebtn.isHidden = true
        updatebtn.isHidden = false
        EditTourDetail()
        removeData()
      //  DetailsApi()
        tableview.reloadData()
        
        }
    
    func newDetailApi(){
       
        print(self.DataList)
        var dict = Dictionary<String,Any>()
        dict["Emp_Code"] = currentUser.EmpCode
        dict["type"] = "0"
        APIManager.apiCall(postData: dict as NSDictionary, url: DetailList) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                    
                    self.DataList = data
                    print(self.DataList)
               
                    }else{
                        print(response?["error"] as Any)
                    }
               
                    self.tableview.reloadData()
                
                }
            }
        
    }
    
    func performDeleteOperation(serial: Int, indexPath: IndexPath) {
        var dict = Dictionary<String, Any>()
        dict["sno"] = String(serial)
        dict["Tour_Id"] = tour

        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: TDelete) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let _ = data, (response?["status"] as? Bool == true), response != nil {
                self.datalist.remove(at: indexPath.row)
                self.Serial.remove(at: indexPath.row)
                self.tableview.deleteRows(at: [indexPath], with: .automatic)
                AlertController.alert(message: (response?.validatedValue("message"))!)
            } else {
                print(response?["error"] as Any)
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
        }
    }
    
    func FinalSbmit(){
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        print( dict["EmpCode"])
        dict["Tour_Id"] = tour
        print( dict["Tour_Id"])
//        datalist.removeAll()
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: Tsubmit) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let _ = data,(response?["status"] as? Bool == true), response != nil {
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }else{
                print(response?["error"] as Any)
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
                //  self.ApiHit()
            }
        }
    }
    
    func DetailsApi(){
        var dict = Dictionary<String,Any>()
        self.datalist.removeAll()
        dict["EmpCode"] = currentUser.EmpCode
        print(dict["EmpCode"])
        dict["TourId"] = tourback
        print(dict["TourId"])
        APIManager.apiCall(postData: dict as NSDictionary, url: TDetails) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)

                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)

                    self.datalist = data
                    print(self.datalist)
                    
                    self.alldata = (self.datalist[0]["alldata"] as? [[String:Any]] ?? [])
                    print(self.alldata)
                    
                    for i in 0..<self.datalist.count{
                    let season_thumbnails = self.datalist[i]["Sno"] as? Int ?? 0
                    self.Serial.append(season_thumbnails)
                    }
                    print(self.Serial)
                    self.updateTotalAmount()
                //    AlertController.alert(message: JSON.value(forKey: "message") as! String)
                }else{
                    print(response?["error"] as Any)

               //  AlertController.alert(message: (response?.validatedValue("message"))!)

                }
                    DispatchQueue.main.async {

                        //                    }else{
                        //                        print(response?["error"] as Any)
                        //                    }
                        self.tableview.reloadData()
                        self.tableview1.reloadData()
                    }
                }
            }
//
        }

    func EditTourDetail() {
        var dict = [String: Any]()
        dict["Sno"] = String(updateVariable)
        dict["EmpCode"] = currentUser.EmpCode
        dict["Amount"] = amntTxt.text ?? ""
        dict["reason"] = resonTxtview.text ?? ""
        dict["TourID"] = tourback

        if let image = imageView.image?.resizeToPhoto1(250), let imageData = image.pngData() {
            dict["thumbnail"] = imageData
        }

        self.DataList.removeAll()

        let url = BASEURL + "/" + TUpdate
        DispatchQueue.main.async { Loader.showLoader() }

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in dict {
                if key == "thumbnail", let imageData = value as? Data {
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

                        if let data = JSON["data"] as? [[String: Any]] {
                            self.DataList = data
                            self.updateTotalAmount()
                            self.tableview.reloadData()
                        }
                    } else {
                        print("Invalid response format")
                    }
                case .failure(let error):
                    print("Upload Failed: \(error.localizedDescription)")
                }
            }
        }
    }

//    func setData(amo: String,ing: String,tou: String, rea: String){
//        amntTxt.text = amo
//        TourTxt.text = location
//        resonTxtview.text = rea
//        imageView.sd_setImage(with: URL(string: imageurl+ing))
//
//    }
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func ApiHit() {
        var dict = [String: Any]()
        dict["EmpCode"] = currentUser.EmpCode

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dict["date"] = dateFormatter.string(from: Date())

        dict["Amount"] = amntTxt.text ?? ""
        dict["Tour_id"] = tourback
        dict["reason"] = resonTxtview.text ?? ""

        if let image = imageView.image?.resizeToWidth1(250), let imageData = image.pngData() {
            dict["image"] = imageData
        }

        let url = BASEURL + "/" + LTourApi
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

                        if let data = JSON["data"] as? [[String: Any]] {
                            self.DataList = data
                            self.Serial = data.compactMap { $0["Sno"] as? Int }
                            print("Updated Serial Numbers:", self.Serial)

                            self.DetailsApi()
                            self.tableview.reloadData()
                        }
                        AlertController.alert(message: JSON["message"] as? String ?? "Success")
                        self.navigationController?.popViewController(animated: true)
                    } 
                case .failure(let error):
                    print("Upload Failed: \(error.localizedDescription)")
                }
            }
        }
    }

    
}
extension UIImage {
        func resizeToWidth1(_ width:CGFloat)-> UIImage {
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
extension UIImage {
        func resizeToPhoto1(_ width:CGFloat)-> UIImage {
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
extension TourAppVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (resonTxtview.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
     
    func textViewDidBeginEditing(_ textView: UITextView) {

        if resonTxtview.textColor == UIColor.lightGray {
            resonTxtview.text = ""
            resonTxtview.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if resonTxtview.text == "" {

            resonTxtview.text = "Remark..."
            resonTxtview.textColor = UIColor.lightGray
        }
    }

}

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return datalist.count
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TourDetailsCell", for: indexPath) as! TourDetailsCell
//        
//       
//    
////
////        if status == 0 {
////            cell.editbtn.isEnabled = true
////            cell.deletebtn.isEnabled = true
////        } else {
////            cell.editbtn.isEnabled = false
////            cell.deletebtn.isEnabled = false
////        }
//       let status = datalist[indexPath.row]["Status"] as? Int ?? 0
//       let amountdata = datalist[indexPath.row]["Amount"] as? String ?? ""
//        cell.Label.text = amountdata
//        
//        let serial = datalist[indexPath.row]["Sno"] as? String ?? ""
//        cell.numberLabel.text = "\(indexPath.row + 1)"
//        
//        editreason = datalist[indexPath.row]["reason"] as? String ?? ""
//        imageData = datalist[indexPath.row]["Billing_thumbnail"] as? String ?? ""
//        let img = imageData.replacingOccurrences(of: " ", with: "%20")
//        cell.imageview.sd_setImage(with: URL(string: imageurl+img))
//        cell.deletebtn.addTarget(self, action: #selector(deleteOnClick(_:)), for: .touchUpInside)
//      
//        cell.deletebtn.tag = indexPath.row
//        
//        cell.editbtn.tag = indexPath.row
//        cell.editbtn.addTarget(self, action: #selector(editOnclick(_:)), for: .touchUpInside)
//        
//        
//        serials = Serial[indexPath.row]
//        let amount = datalist[indexPath.row]["Amount"] as? String ?? ""
//        self.tour = datalist[indexPath.row]["Tour_id"] as? String ?? ""
//        let location = datalist[indexPath.row]["Location"] as? String ?? ""
//      
//            return cell
//            
//        }

        
extension TourAppVC: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == tableview {
                return datalist.count // Adjust this as per your data needs
            } else if tableView == tableview1 {
                return datalist.count // Adjust this as per your data needs
            }
            return 0
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if tableView == tableview {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TourDetailsCell", for: indexPath) as! TourDetailsCell
              
                       let status = datalist[indexPath.row]["Status"] as? Int ?? 0
                       let amountdata = datalist[indexPath.row]["Amount"] as? String ?? ""
                        cell.Label.text = amountdata
                
                if let requestAmount = datalist[indexPath.row]["Amount"] as? String {
                    cell.Label.text = "₹ " + requestAmount + ".00"
                } else {
                    cell.Label.text = "₹ 0" // or handle the case where the amount is not found
                }
                
                        let serial = datalist[indexPath.row]["Sno"] as? String ?? ""
                        cell.numberLabel.text = "\(indexPath.row + 1)"
                
                        editreason = datalist[indexPath.row]["reason"] as? String ?? ""
                        imageData = datalist[indexPath.row]["Billing_thumbnail"] as? String ?? ""
                        let img = imageData.replacingOccurrences(of: " ", with: "%20")
                        cell.imageview.sd_setImage(with: URL(string: imageurl+img))
                        cell.deletebtn.addTarget(self, action: #selector(deleteOnClick(_:)), for: .touchUpInside)
                
                        cell.deletebtn.tag = indexPath.row
                
                        cell.editbtn.tag = indexPath.row
                        cell.editbtn.addTarget(self, action: #selector(editOnclick(_:)), for: .touchUpInside)
                
                
                        serials = Serial[indexPath.row]
                        let amount = datalist[indexPath.row]["Amount"] as? String ?? ""
                        self.tour = datalist[indexPath.row]["Tour_id"] as? String ?? ""
                        let location = datalist[indexPath.row]["Location"] as? String ?? ""
                // Add other configurations if needed
                return cell
            } else if tableView == tableview1 {

                let cell = tableView.dequeueReusableCell(withIdentifier: "previewTableViewCell", for: indexPath) as! previewTableViewCell
                
//                let amountdata = datalist[indexPath.row]["Amount"] as? String ?? ""
//                 cell.AMount.text = amountdata
                
                if let requestAmount = datalist[indexPath.row]["Amount"] as? String {
                    cell.AMount.text = "₹ " + requestAmount + ".00"
                } else {
                    cell.AMount.text = "₹ 0" // or handle the case where the amount is not found
                }
         
                 let serial = datalist[indexPath.row]["Sno"] as? String ?? ""
                 cell.Sno.text = "\(indexPath.row + 1)"
                imageData = datalist[indexPath.row]["Billing_thumbnail"] as? String ?? ""
                let img = imageData.replacingOccurrences(of: " ", with: "%20")
                cell.imageview.sd_setImage(with: URL(string: imageurl+img))
                
                return cell
            }
            return UITableViewCell()
        }
            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 100
            }
        }



 
