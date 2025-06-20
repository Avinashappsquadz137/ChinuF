//
//  NewBooking1Vc.swift
//  SanskarEP
//
//  Created by Surya on 19/03/24.
//

import UIKit
import iOSDropDown
import Alamofire

class NewBooking1Vc: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var sanskarview:UIView!
    @IBOutlet weak var satsangview:UIView!
    @IBOutlet weak var shubhView:UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var amounttext: UITextField!
    @IBOutlet weak var venuetext: UITextField!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var Gstview: UIView!
    @IBOutlet weak var menuTxtf: UITextField!
    @IBOutlet weak var sanskarbtn: UIButton!
    @IBOutlet weak var satsangbtn: UIButton!
    @IBOutlet weak var subhabtn: UIButton!
    @IBOutlet weak var sanskarimage: UIImageView!
    @IBOutlet weak var satsangimage: UIImageView!
    @IBOutlet weak var subhaimage: UIImageView!
    @IBOutlet weak var StartD: UITextField!
    @IBOutlet weak var EndDate:UITextField!
    @IBOutlet weak var dateview: UIView!
    @IBOutlet weak var custumview:UIView!
    @IBOutlet weak var kathatimedropdownview:UIView!
    @IBOutlet weak var addview: UIView!
    @IBOutlet weak var addimageview: UIImageView!
    
    @IBOutlet weak var dropview: UIView!
    @IBOutlet weak var droptable: UITableView!
    @IBOutlet weak var dopbtn: UIButton!
    @IBOutlet weak var droptext: UITextField!
    @IBOutlet weak var timetext: UITextField!
    @IBOutlet weak var dropTable: UITableView!
    @IBOutlet weak var dropDView: UIView!
    @IBOutlet weak var startT: UITextField!
    @IBOutlet weak var endT: UITextField!
    
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var withGstView: UIView!
    @IBOutlet weak var SelectDropView: UIView!
    @IBOutlet weak var withGstLbl: UILabel!
    
    
    fileprivate let timePicker = UIDatePicker()
    fileprivate let pickerView = ToolbarPickerView()
    
    var type: String?
    var timetype: String?
    var item: String?
    var isSelect: Bool = false
    var Kathatype = [[String:Any]]()
    var Kathatime = [[String:Any]]()
    var gstRate: Double = 0.18
    var gstStatus: String = ""
    var idVariable: Int?
    var selectedKathaCategoryID: Int?
    var selectedKathaSlot: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        selectTypeApi()
        
        ChannelListApi()
        timePickerSetup()

        custumview.isHidden = true
        dropview.isHidden = true
        droptable.isHidden = true
        
        dropTable.isHidden = true
        dropDView.isHidden = true
        addview.isHidden = true
      //  withGstView.isHidden = true
        
        droptable.dataSource = self
        droptable.delegate = self
        
        dropTable.dataSource = self
        dropTable.delegate = self
        
        amounttext.addTarget(self, action: #selector(amountTextChanged(_:)), for: .editingChanged)
    }
    
    
    func setup(){
        amounttext.layer.cornerRadius = 8
        venuetext.layer.cornerRadius = 8
        menuTxtf.layer.cornerRadius = 8
     
        submitbtn.layer.cornerRadius = 8
        view1.layer.cornerRadius = 8
        view2.layer.cornerRadius = 8
        view3.layer.cornerRadius = 8
        view4.layer.cornerRadius = 8
        dateview.layer.cornerRadius = 8
        kathatimedropdownview.layer.cornerRadius = 8
        dropview.layer.cornerRadius = 8
        withGstView.layer.cornerRadius = 8
        SelectDropView.layer.cornerRadius = 8
        
        sanskarview.circleWithBorder()
        Gstview.circleWithBorder()
        satsangview.circleWithBorder()
        shubhView.circleWithBorder()

        
    }
    func timePickerSetup() {
        let toolBar = UIToolbar()
        let toolBar2 = UIToolbar()
        toolBar.sizeToFit()
        toolBar2.sizeToFit()
        let doneBtn1 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnClicK))
        let doneBtn2 = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnClicK1))
        toolBar.items = [doneBtn1]
        toolBar2.items = [doneBtn2]
        startT.inputAccessoryView = toolBar
        startT.inputView = timePicker
        endT.inputAccessoryView = toolBar2
        endT.inputView = timePicker
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc
    func doneBtnClicK() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm a"
        startT.text = "\(formatter.string(from: timePicker.date))"
        self.view.endEditing(true)
    }
    
    @objc
    func doneBtnClicK1() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "HH:mm a"
        endT.text = "\(formatter.string(from: timePicker.date))"
        self.view.endEditing(true)
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func dropbtn(_ sender: UIButton) {
//        self.droptable.isHidden = !self.droptable.isHidden
//        self.dropview.isHidden = !self.dropview.isHidden
        if addview.isHidden {
                // If addview is hidden, show droptable and dropview
                self.droptable.isHidden = false
                self.dropview.isHidden = false
            } else {
                // If addview is visible, hide addview and show droptable and dropview
                addview.isHidden = true
                self.droptable.isHidden = false
                self.dropview.isHidden = false
            }
    }
    
    @IBAction func drop1btn(_ sender: UIButton) {
        self.dropTable.isHidden = !self.dropTable.isHidden
        self.dropDView.isHidden = !self.dropDView.isHidden
    }
    
    @IBAction func dateclick(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.StartD.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    
    
    @IBAction func Enddateclick(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.EndDate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    

    @IBAction func addcamerabtn(_ sender: UIButton) {
        let ac = UIAlertController(title: "Select Image", message: "Select Image from", preferredStyle: .actionSheet)
        
        let cameraBtn = UIAlertAction(title: "Camera", style: .default) { [weak self] (_) in
            self?.showImagePicker(selectedSource: .camera)
        }
        
        let galleryBtn = UIAlertAction(title: "Gallery", style: .default) { [weak self] (_) in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        
        let fileManagerBtn = UIAlertAction(title: "File Manager", style: .default) { [weak self] (_) in
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.image", "public.pdf"], in: .import)
            documentPicker.delegate = self as! any UIDocumentPickerDelegate
            documentPicker.modalPresentationStyle = .formSheet
            self?.present(documentPicker, animated: true, completion: nil)
        }
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(cameraBtn)
        ac.addAction(galleryBtn)
        ac.addAction(fileManagerBtn)
        ac.addAction(cancelBtn)
        
        self.present(ac, animated: true, completion: nil)
        
    }
    
//    @IBAction func selectfilebtn(_ sender: UIButton) {
//        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
//                documentPicker.delegate = self
//                documentPicker.allowsMultipleSelection = false
//                present(documentPicker, animated: true, completion: nil)
//    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            addimageview.image = selectedImage
        } else {
            print("Image not found")
        }
        picker.dismiss(animated: true,completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true,completion: nil)
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
    func ChannelListApi() {
        var dict = Dictionary<String, Any>()
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: ChannelApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let data = data, let responseData = response, responseData["status"] as? Bool == true {
                if let dataArray = responseData["data"] as? [[String: Any]] {
                    for (index, channelData) in dataArray.enumerated() {
                        if let channelThumbnail = channelData["channel_thumbnail"] as? String {
                            // Perform any further action with the image here, such as displaying it
                            self.setImageForChannel(index: index, thumbnail: channelThumbnail)
                        }
                    }
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }

    func setImageForChannel(index: Int, thumbnail: String) {
        switch index {
        case 0:
            self.sanskarimage.image = UIImage(named: thumbnail)
        case 1:
            self.satsangimage.image = UIImage(named: thumbnail)
        case 2:
            self.subhaimage.image = UIImage(named: thumbnail)
        default:
            break
        }
    }
    


    func selectTypeApi() {
        let dict = [String:Any]()
        APIManager.apiCall(postData: dict as NSDictionary, url: kathatypeApi) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }
            if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true {
                print(JSON)
                if let data = JSON["data"] as? [[String:Any]] {
                    print(data)
                    self.Kathatype = data
                    print(self.Kathatype)
                    
                    // Extracting GST rate
                    if let firstItem = data.first, let gstString = firstItem["GST"] as? String, let gst = Double(gstString.replacingOccurrences(of: "%", with: "")) {
                        self.gstRate = gst / 100.0 // Assuming GST string is in percentage format like "18%"
                    }
                    
                    if let firstItem = data.first, let id = firstItem["ID"] as? Int {
                        self.idVariable = id
                    }
                    
                    DispatchQueue.main.async {
                        self.droptable.reloadData()
                    }
                }
            } else {
                print(response?["error"] as Any)
            }
        }
    }


    func BookKathaApi() {
        var dict = [String: Any]()
        dict["name"] = menuTxtf.text ?? ""
        dict["channel"] = type
        dict["amount"] = amounttext.text ?? ""
        dict["gst"] = gstStatus
        dict["gst_percentage"] = "18"
        dict["venue"] = venuetext.text ?? ""
        dict["katha_to_date"] = StartD.text ?? ""
        dict["katha_from_date"] = EndDate.text ?? ""
        dict["katha_category_id"] = String(selectedKathaCategoryID ?? 0)
        dict["katha_slot"] = selectedKathaSlot

        if selectedKathaSlot == "Custom" {
            dict["katha_slot"] = "4"
            dict["start_time"] = startT.text ?? ""
            dict["end_time"] = endT.text ?? ""
        }

        let url = BASEURL + "/" + kathabookingApi
        DispatchQueue.main.async { Loader.showLoader() }

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in dict {
                if key == "image", let image = value as? UIImage, let imageData = image.pngData() {
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

                        AlertController.alert(message: JSON["message"] as? String ?? "Success")
                        self.navigationController?.popViewController(animated: true)
                    } 
                case .failure(let error):
                    print("Upload Failed: \(error.localizedDescription)")
                }
            }
        }
    }



    
    func kathacategoryApi() {
        var dict = Dictionary<String, Any>()
         let storedIds = UserDefaults.standard.string(forKey: "selectedIds")
            print("Stored IDs: \(storedIds)")
        dict["CategoryId"] = storedIds
        
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: kathatimingApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true {
                print(JSON)
                if let data = JSON["data"] as? [[String:Any]] {
                    print(data)
                    self.Kathatime = data
                    print(self.Kathatime)
                    DispatchQueue.main.async {
                        self.dropTable.reloadData()
                    }
                }
            }  else {
                
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
            self.dropTable.reloadData()
        }
    }

    
    
    @IBAction func selectchbutton(_ sender: UIButton) {
        switch sender {
          case sanskarbtn:
              if sanskarview.backgroundColor == .blue {
                  sanskarview.backgroundColor = .clear
                  type = nil
              } else {
                  clearAllChannelSelection()
                  sanskarview.backgroundColor = .blue
                  type = "1"
              }
          case satsangbtn:
              if satsangview.backgroundColor == .blue {
                  satsangview.backgroundColor = .clear
                  type = nil
              } else {
                  clearAllChannelSelection()
                  satsangview.backgroundColor = .blue
                  type = "2"
              }
          case subhabtn:
              if shubhView.backgroundColor == .blue {
                  shubhView.backgroundColor = .clear
                  type = nil
              } else {
                  clearAllChannelSelection()
                  shubhView.backgroundColor = .blue
                  type = "3"
              }
          default:
              break
          }
    }
    
    func clearAllChannelSelection() {
        sanskarview.backgroundColor = .clear
        satsangview.backgroundColor = .clear
        shubhView.backgroundColor = .clear
    }
    
    @IBAction func GSTSelectBtn(_ sender: UIButton) {

        guard let amountString = amounttext.text, let amount = Double(amountString) else {
               return
           }
           
           // Toggle the color of Gstview
           Gstview.backgroundColor = Gstview.backgroundColor == .blue ? .clear : .blue
           // Unhide the view
           self.withGstView.isHidden = false
           
           var totalAmount: Double
           if Gstview.backgroundColor == .blue {
               totalAmount = amount + (amount * gstRate)
               gstStatus = "Yes"
           } else {
               totalAmount = amount
               gstStatus = "No"
           }
           // Set the amount in the label
           withGstLbl.text = "\(totalAmount)"
    }
    
    @objc func amountTextChanged(_ textField: UITextField) {
            guard let amountString = textField.text, let amount = Double(amountString) else {
                return
            }
            
            // Update withGstLbl based on Gstview color
            var totalAmount: Double
            if Gstview.backgroundColor == .blue {
                totalAmount = amount + (amount * gstRate)
                gstStatus = "Yes"
            } else {
                totalAmount = amount
                gstStatus = "No"
            }
            
            // Set the updated amount in the label
            withGstLbl.text = "\(totalAmount)"
        }
    
    @IBAction func submitbtn(_ sender: UIButton) {
        BookKathaApi()
    }
}

extension UIImage {
        func resizeToWidth4(_ width:CGFloat)-> UIImage {
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
extension NewBooking1Vc: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == droptable {
            return Kathatype.count
        } else if tableView == dropTable {
            return Kathatime.count  // Assuming `Kathatime` is another array holding time data
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == droptable {
            let cell1 = droptable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell1.textLabel?.text = Kathatype[indexPath.row]["KathaName"] as? String ?? ""
            return cell1
        } else if tableView == dropTable {
            let cell = dropTable.dequeueReusableCell(withIdentifier: "dropCell", for: indexPath)
            cell.textLabel?.text = Kathatime[indexPath.row]["SlotTiming"] as? String ?? ""
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == droptable {
            let selectedValue = Kathatype[indexPath.row]["KathaName"] as? String ?? ""
            let selectedIds = Kathatype[indexPath.row]["ID"] as? Int ?? 0

            UserDefaults.standard.set(selectedIds, forKey: "selectedIds")
            
            droptext.text = selectedValue
            self.droptable.isHidden = true
            self.dropview.isHidden = true
            
            if selectedValue == "Ads" {
                self.addview.isHidden = false
                self.custumview.isHidden = true
            } else {
                self.addview.isHidden = true
                self.custumview.isHidden = selectedValue != "Custom"
            }
            
            selectedKathaCategoryID = selectedIds
            DispatchQueue.main.async {
                self.kathacategoryApi()
            }

            
        } else if tableView == dropTable {
            let selectedValue = Kathatime[indexPath.row]["SlotTiming"] as? String ?? ""
            timetext.text = selectedValue
            self.dropTable.isHidden = true
            self.dropDView.isHidden = true
            
            if selectedValue == "Custom" {
                self.custumview.isHidden = false
            } else {
                self.custumview.isHidden = true
            }
            selectedKathaSlot = selectedValue
        }
    }
    

}

extension NewBooking1Vc: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        // Handle the selected file URL here
        // You can upload the file to your backend or perform any other necessary action
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Handle cancellation if needed
    }
}
