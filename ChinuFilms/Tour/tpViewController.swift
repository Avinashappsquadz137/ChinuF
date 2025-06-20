//
//  tpViewController.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 14/07/23.
//

import UIKit
import Alamofire
import PhotosUI
import iOSDropDown


class tpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var amntTxt: UITextField!
    @IBOutlet var TourTxt: DropDown!
    @IBOutlet weak var resonTxtview: UITextView!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var photoview: UIView!
    @IBOutlet weak var PhotoImgView: UIImageView!
    
    
    
    
    var TourImageData  = String()
    var TourId = [String]()
    var item: String?
    var datalist = [[String:Any]]()
    var imageData = String()
    var Serial = [Int]()
    var sno = String()
    var image = String()
    var tour = String()
    var serials = Int()
    var editTour = String()
    var amountdata = String()
    var editamount = String()
    var deleteserial = String()
    var editimage = String()
    var editreason = String()
    var edit = 0
    var tourD = String()
    var tourback  = ""
    
   
    
    var imageurl = "https://sap.sanskargroup.in/uploads/tour/"
    
    fileprivate let pickerView = ToolbarPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailsApi()
        photoview.isHidden = true
        print(tourback)
        resonTxtview.delegate = self
        //   tourBilling()
        setup()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "TourDetailsCell", bundle: nil), forCellReuseIdentifier: "TourDetailsCell")
        self.tableview.reloadData()
    }
    func setup() {
        
        //    resonTxtview.text = "Remark..."
        resonTxtview.textColor = .black
        resonTxtview.layer.cornerRadius = 10
        resonTxtview.layer.borderWidth = 0.5
        //    resonTxtview.layer.borderColor = UIColor.lightGray.cgColor
        resonTxtview.clipsToBounds = true
        
        amntTxt.textColor = .black
        amntTxt.layer.cornerRadius = 10
        amntTxt.layer.borderWidth = 0.5
        amntTxt.clipsToBounds = true
        
        TourTxt.textColor = .black
        TourTxt.layer.cornerRadius = 10
        TourTxt.layer.borderWidth = 0.5
        TourTxt.clipsToBounds = true
        
        submitbtn.layer.cornerRadius = 20
        submitbtn.clipsToBounds = true
        
        savebtn.layer.cornerRadius = 20
        savebtn.clipsToBounds = true
        
        tableview.layer.cornerRadius = 10
        tableview.clipsToBounds = true
        
        TourTxt.optionArray = TourId
        TourTxt.isSearchEnable = true
        TourTxt.listHeight = 150
        TourTxt.didSelect { selectedText, index, id in
            self.TourTxt.text = selectedText
            self.item = selectedText
        }
    }
    
    func removeData() {
        imageView.image = nil
        amntTxt.text?.removeAll()
        TourTxt.text?.removeAll()
        resonTxtview.text.removeAll()
    }
    //    }
    
    @IBAction func bckbtn(_ sender: Any) {
        dismiss(animated: true,completion: nil)
        
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
            imageView.image = selectedImage
            
        } else {
            print("Image not found")
        }
        picker.dismiss(animated: true,completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
    }
    
    
    @IBAction func SubmitBtn(_ sender: Any) {
       
        FinalSbmit()
     //   AlertController.alert(message:  "Tour billing request submit successfully")
        dismiss(animated: true,completion: nil)
      
        }
      
        func deleteItem() {
            print("Item deleted")
        }
    
    @objc
    func editOnclick(_ sender: UIButton )  {
        if edit == 0 {
            
            savebtn.setTitle("Update", for: .normal)
            EditTourDetail()
            tableview.reloadData()
        }
    }
    @objc
    func deleteOnClick(_ sender: UIButton ) {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "OK", style: .destructive) { [self] (action) in
            let row = sender.tag
            self.datalist.remove(at: row)
            self.tableview.beginUpdates()
            self.tableview.deleteRows(at: [IndexPath(row: row, section: 0)], with: .left)
            self.tableview.endUpdates()
           // self.DeleteApi()
            self.deleteItem()
            self.tableview.reloadData()
           
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
   @objc
    func ImageViewOnClick(_ sender: UIButton )  {
     
        photoview.isHidden = false
        for i in 0..<self.datalist.count{
        let season = self.datalist[i]["Billing_thumbnail"] as? String ?? ""
        self.image.append(season)
        }
        print(self.image)
        
        let img = image.replacingOccurrences(of: " ", with: "%20")
        print(img)
        PhotoImgView.sd_setImage(with: URL(string: imageurl+img))

        }
    
   
    @IBAction func CloseBtn(_ sender: UIButton) {
        photoview.isHidden = true
    }
    
    
    @IBAction func savebtn(_ sender: UIButton) {
        ApiHit()
        removeData()
        
//            if edit == 0 {
//            savebtn.setTitle("Save", for: .normal)
//            edit = 1
//            savebtn.setTitle("Update", for: .normal)
//            amntTxt.isUserInteractionEnabled = true
//            imageView.isUserInteractionEnabled = true
//            resonTxtview.isUserInteractionEnabled = true
//            TourTxt.isUserInteractionEnabled = true
//
//        }else{
//            savebtn.setTitle("Update", for: .normal)
//            amntTxt.isUserInteractionEnabled = false
//            imageView.isUserInteractionEnabled = false
//            resonTxtview.isUserInteractionEnabled = false
//            TourTxt.isUserInteractionEnabled = false
     //       EditTourDetail()
          //  edit = 0
            //   savebtn.setTitle("Update", for: .normal)
            
     //   }
    }
    
//    func deletecell(snumber:Int){
//        var dict = Dictionary<String,Any>()
//
//        dict["sno"] = String(snumber)
//        print( dict["sno"])
//        dict["Tour_Id"] = tour
//        print( dict["Tour_Id"])
//
//     //   AlertController.alert(message: "Are You Sure You Want To Delete")
//
//        DispatchQueue.main.async(execute: {Loader.showLoader()})
//        APIManager.apiCall(postData: dict as NSDictionary, url: TDelete) { result, response, error, data in
//            DispatchQueue.main.async(execute: {Loader.hideLoader()})
//            if let _ = data,(response?["status"] as? Bool == true), response != nil {
//
//               // AlertController.alert(message: (response?.validatedValue("message"))!)
//            }else{
//                print(response?["error"] as Any)
//                AlertController.alert(message: (response?.validatedValue("message"))!)            }
//            DispatchQueue.main.async {
//                self.tableview.reloadData()
//                //  self.ApiHit()
//            }
//        }
//    }
    
    func FinalSbmit(){
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
        print( dict["EmpCode"])
        dict["Tour_Id"] = tour
        print( dict["Tour_Id"])
        
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
        dict["EmpCode"] = currentUser.EmpCode
        print(dict["EmpCode"])
        dict["TourId"] = "TR/2023/IT/8328"
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
                    for i in 0..<self.datalist.count{
                    let season_thumbnails = self.datalist[i]["Sno"] as? Int ?? 0
                    self.Serial.append(season_thumbnails)
                    }
                    print(self.Serial)
                //    AlertController.alert(message: JSON.value(forKey: "message") as! String)
                    DispatchQueue.main.async {
                        
                        //                    }else{
                        //                        print(response?["error"] as Any)
                        //                    }
                        self.tableview.reloadData()
                        
                    }
                }
            }
            
        }
    }
    func EditTourDetail() {
        var dict = [String: Any]()
        dict["Sno"] = String(serials)
        dict["EmpCode"] = currentUser.EmpCode
        dict["Amount"] = amntTxt.text ?? ""
        dict["reason"] = resonTxtview.text ?? ""
        dict["TourID"] = TourTxt.text ?? ""

        // Safely handle the image upload
        if let image = imageView.image?.resizeToPhoto(250), let imageData = image.pngData() {
            dict["thumbnail"] = imageData
        }

        self.datalist.removeAll()

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
                            self.datalist = data
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


    
    func setData(amo: String,ing: String,tou: String, rea: String){
        amntTxt.text = amo
        TourTxt.text = tou
        resonTxtview.text = rea
        imageView.sd_setImage(with: URL(string: imageurl+ing))
        
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
                            //self.DataList = data
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

extension tpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.TourId.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.TourId[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.TourTxt.text = self.TourId[row]
     
    }
}
extension tpViewController: ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.TourTxt.text = self.TourId[row]
        
        self.item = self.TourId[row]
        self.TourTxt.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.TourTxt.text = nil
        self.TourTxt.resignFirstResponder()
    }
}
extension UIImage {
        func resizeToWidth(_ width:CGFloat)-> UIImage {
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
        func resizeToPhoto(_ width:CGFloat)-> UIImage {
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

extension tpViewController: UITextViewDelegate {
    
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
extension tpViewController: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourDetailsCell", for: indexPath) as! TourDetailsCell
        
        let amountdata = datalist[indexPath.row]["Amount"] as? String ?? ""
        print(amountdata)
        editreason = datalist[indexPath.row]["reason"] as? String ?? ""
        print(editreason)
        imageData = datalist[indexPath.row]["Billing_thumbnail"] as? String ?? ""
        cell.Label.text = amountdata
        serials = datalist[indexPath.row]["Sno"] as? Int ?? 0
        print(serials)
        
    //deletecell(snumber:serials)
       
                   
   //     let serialno = datalist[indexPath.row]["Sno"] as? Int ?? 0
        cell.numberLabel.text = String(serials)
        let img = imageData.replacingOccurrences(of: " ", with: "%20")
        print(img)
        cell.imageview.sd_setImage(with: URL(string: imageurl+img))
        cell.deletebtn.addTarget(self, action: #selector(deleteOnClick(_:)), for: .touchUpInside)
        cell.deletebtn.tag = indexPath.row
        cell.editbtn.tag = indexPath.row
        cell.editbtn.addTarget(self, action: #selector(editOnclick(_:)), for: .touchUpInside)
        cell.ImageBtn.addTarget(self, action: #selector(ImageViewOnClick(_:)), for: .touchUpInside)
        
        

        let amount = datalist[indexPath.row]["Amount"] as? String ?? ""
        
        
        self.tour = datalist[indexPath.row]["Tour_id"] as? String ?? ""
        print(self.tour)
            return cell
            
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        editamount = datalist[indexPath.row]["Amount"] as? String ?? ""
        editimage = datalist[indexPath.row]["Billing_thumbnail"] as? String ?? ""
        let img = imageData.replacingOccurrences(of: " ", with: "%20")
        editTour = datalist[indexPath.row]["Tour_id"] as? String ?? ""
        editreason = datalist[indexPath.row]["reason"] as? String ?? ""

        setData(amo: editamount,ing: editimage,tou: editTour, rea: editreason)
        
       // ImageViewOnClick(sender, indexPath: indexPath)
     }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


