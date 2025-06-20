//
//  BookingKathaVc.swift
//  SanskarEP
//
//  Created by Surya on 25/04/24.
//

import UIKit
import Alamofire

class BookingKathaVc: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var ChannelsView: UIView!
    @IBOutlet weak var SanskarchannelView: UIView!
    @IBOutlet weak var SatsangChannelView: UIView!
    @IBOutlet weak var SubhChannelView: UIView!
    @IBOutlet weak var Sanskarradioview: UIView!
    @IBOutlet weak var subhradioview: UIView!
    @IBOutlet weak var satsangradioview: UIView!
    @IBOutlet weak var droptype: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var Date1View: UIView!
    @IBOutlet weak var Date2View: UIView!
    @IBOutlet weak var dropTimeview: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var GstView: UIView!
    @IBOutlet weak var Gst1View: UIView!
    @IBOutlet weak var Gstradioview: UIView!
    @IBOutlet weak var nametxt: UITextField!
    @IBOutlet weak var amounttxt: UITextField!
    @IBOutlet weak var venuetxt: UITextField!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var fromdate: UITextField!
    @IBOutlet weak var todate: UITextField!
    @IBOutlet weak var sanskarimage: UIImageView!
    @IBOutlet weak var satsangimage: UIImageView!
    @IBOutlet weak var subhaimage: UIImageView!
    @IBOutlet weak var sanskarbtn: UIButton!
    @IBOutlet weak var satsangbtn: UIButton!
    @IBOutlet weak var subhabtn: UIButton!
    @IBOutlet weak var dropview: UIView!
    @IBOutlet weak var droptable: UITableView!
    @IBOutlet weak var dropbtn: UIButton!
    @IBOutlet weak var dropDView: UIView!
    @IBOutlet weak var dropTable: UITableView!
    @IBOutlet weak var droptext: UITextField!
    @IBOutlet weak var timetext: UITextField!
    @IBOutlet weak var withGstView: UIView!
    @IBOutlet weak var withGstLbl: UILabel!
    @IBOutlet weak var addview: UIView!
    @IBOutlet weak var addimage: UIImageView!
    @IBOutlet weak var view1uperconstriants: NSLayoutConstraint!
    @IBOutlet weak var customview: UIView!    
    @IBOutlet weak var view2constraints: NSLayoutConstraint!
    @IBOutlet weak var startT: UITextField!
    @IBOutlet weak var EndT: UITextField!
    @IBOutlet weak var fileLabel: UILabel!
    @IBOutlet weak var view3constraints: NSLayoutConstraint!
    @IBOutlet weak var santnameview: UIView!
    @IBOutlet weak var santtableview: UITableView!
    
    var type: String?
    var gstStatus: String?
    var timetype: String?
    var item: String?
    var selectedname: String?
    var selectedid: Int?
    
    var isSelect: Bool = false
    var Kathatype = [[String:Any]]()
    var Kathatime = [[String:Any]]()
    var santData = [[String:Any]]()
    var filteredSantData = [[String: Any]]()
    
    var gstRate: Double = 0.18
    var selectedKathaSlot: String?
    var selectedKathaSlottime: String?
    var selectedKathaCategoryID: Int?
    var selectedImage: UIImage?
    var selectedPDFURL: URL?
    var selectedExcelURL: URL?
    
    fileprivate let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        customview.isHidden = true
        selectTypeApi()
        ChannelListApi()
        timePickerSetup()
        SantnameApi()
        
        dropview.isHidden = true
        droptable.isHidden = true
        dropTable.isHidden = true
        dropDView.isHidden = true
        
     //   santnameview.isHidden = true
        santtableview.isHidden = true
        
        addview.isHidden = true
        
        droptable.dataSource = self
        droptable.delegate = self
        
        santtableview.dataSource = self
        santtableview.delegate = self
        
        dropTable.dataSource = self
        dropTable.delegate = self
        amounttxt.addTarget(self, action: #selector(amountTextChanged(_:)), for: .editingChanged)
        
        amounttxt.delegate = self
        nametxt.delegate = self 
      
               venuetxt.delegate = self
               fromdate.delegate = self
               todate.delegate = self
               startT.delegate = self
               EndT.delegate = self
    }
    

  
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
    func setup(){
        
        SanskarchannelView.layer.cornerRadius = 12
        SanskarchannelView.layer.borderWidth = 2.0
        SanskarchannelView.layer.borderColor = UIColor.systemGray4.cgColor
        
        SatsangChannelView.layer.cornerRadius = 12
        SatsangChannelView.layer.borderWidth = 2.0
        SatsangChannelView.layer.borderColor = UIColor.systemGray4.cgColor
        
        SubhChannelView.layer.cornerRadius = 12
        SubhChannelView.layer.borderWidth = 3.0
        SubhChannelView.layer.borderColor = UIColor.systemGray4.cgColor
        
        droptype.layer.cornerRadius = 10
        droptype.layer.borderWidth = 0.5
        droptype.layer.borderColor = UIColor.lightGray.cgColor
       
        addview.layer.cornerRadius = 10
        addview.layer.borderWidth = 0.5
        addview.layer.borderColor = UIColor.lightGray.cgColor
        
        Date1View.layer.cornerRadius = 10
        Date1View.layer.borderWidth = 0.5
        Date1View.layer.borderColor = UIColor.lightGray.cgColor
        
        Date2View.layer.cornerRadius = 10
        Date2View.layer.borderWidth = 0.5
        Date2View.layer.borderColor = UIColor.lightGray.cgColor
        
        dropTimeview.layer.cornerRadius = 10
        dropTimeview.layer.borderWidth = 0.5
        dropTimeview.layer.borderColor = UIColor.lightGray.cgColor
        
        startT.layer.cornerRadius = 10
        startT.layer.borderWidth = 0.5
        startT.layer.borderColor = UIColor.lightGray.cgColor
        
        EndT.layer.cornerRadius = 10
        EndT.layer.borderWidth = 0.5
        EndT.layer.borderColor = UIColor.lightGray.cgColor
        
        Date2View.layer.cornerRadius = 10
        Date2View.layer.borderWidth = 0.5
        Date2View.layer.borderColor = UIColor.lightGray.cgColor
        
        amounttxt.layer.cornerRadius = 10
        amounttxt.layer.borderWidth = 0.5
        amounttxt.layer.borderColor = UIColor.lightGray.cgColor
        
        venuetxt.layer.cornerRadius = 10
        venuetxt.layer.borderWidth = 0.5
        venuetxt.layer.borderColor = UIColor.lightGray.cgColor
        
        nametxt.layer.cornerRadius = 10
        nametxt.layer.borderWidth = 0.5
        nametxt.layer.borderColor = UIColor.lightGray.cgColor
        
        
        withGstView.layer.cornerRadius = 8
        submitbtn.layer.cornerRadius = 8
   
    
       
        customview.layer.cornerRadius = 8
        
        Sanskarradioview.circleWithBorder()
        Gstradioview.circleWithBorder()
        subhradioview.circleWithBorder()
        satsangradioview.circleWithBorder()
       
    }
    @IBAction func dropbtn(_ sender: UIButton) {
  //      self.droptable.isHidden = !self.droptable.isHidden
   //     self.dropview.isHidden = !self.dropview.isHidden
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
   
    
    
    @IBAction func selectimage(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose File", message: "Choose File from", preferredStyle: .actionSheet)
        
        let cameraBtn = UIAlertAction(title: "Camera", style: .default) { [weak self] (_) in
            self?.showImagePicker(selectedSource: .camera)
        }
        
        let galleryBtn = UIAlertAction(title: "Gallery", style: .default) { [weak self] (_) in
            self?.showImagePicker(selectedSource: .photoLibrary)
        }
        
        let fileManagerBtn = UIAlertAction(title: "File Manager", style: .default) { [weak self] (_) in
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf", "public.content", "com.microsoft.excel.sheet", "com.microsoft.excel.xls", "org.openxmlformats.spreadsheetml.sheet"], in: .import)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            self?.present(documentPicker, animated: true, completion: nil)
        }
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(cameraBtn)
        ac.addAction(galleryBtn)
        ac.addAction(fileManagerBtn)
        ac.addAction(cancelBtn)
        
        self.present(ac, animated: true, completion: nil)
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let selectedImage = info[.originalImage] as? UIImage {
//            addimage.image = selectedImage
//        } else {
//            print("Image not found")
//        }
//        picker.dismiss(animated: true,completion: nil)
//    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage,
           let imageUrl = info[.imageURL] as? URL {
            // Handle the selected image
            self.selectedImage = selectedImage
            // Display the image name with extension on a label
            fileLabel.text = imageUrl.lastPathComponent + "." + imageUrl.pathExtension
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
        EndT.inputAccessoryView = toolBar2
        EndT.inputView = timePicker
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
        EndT.text = "\(formatter.string(from: timePicker.date))"
        self.view.endEditing(true)
    }
    @IBAction func dateclick(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.fromdate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
    }
    
    
    @IBAction func Enddateclick(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
            self.todate.text = Utils.dateString(date: date, format: "yyyy-MM-dd")
        }
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
    func kathacategoryApi() {
        var dict = Dictionary<String, Any>()
         let storedIds = UserDefaults.standard.string(forKey: "selectedIds")
            print("Stored IDs: \(storedIds)")
        dict["category_id"] = storedIds
        
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
    func SantnameApi() {
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = currentUser.EmpCode
        dict["searchTerm"] = ""
        
        DispatchQueue.main.async(execute: { Loader.showLoader() })
        APIManager.apiCall(postData: dict as NSDictionary, url: santnameApi) { result, response, error, data in
            DispatchQueue.main.async(execute: { Loader.hideLoader() })
            if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true {
                print(JSON)
                if let data = JSON["data"] as? [[String:Any]] {
                    print(data)
                    self.santData = data
                    self.filteredSantData = data
                
                    DispatchQueue.main.async {
                        self.santtableview.reloadData()
                    }
                }
            }  else {
                
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
            self.santtableview.reloadData()
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
        dict["EmpCode"] = currentUser.EmpCode
        dict["name"] = selectedname
        
        if let selectedid = selectedid {
            dict["guru_ID"] = selectedid
        } else {
            dict["guru_ID"] = "0"
            dict["name"] = nametxt.text ?? ""
        }

        dict["channel"] = type
        dict["amount"] = amounttxt.text ?? ""
        dict["gst"] = gstStatus
        dict["gst_percentage"] = "18"
        dict["venue"] = venuetxt.text ?? ""
        dict["katha_to_date"] = todate.text ?? ""
        dict["katha_from_date"] = fromdate.text ?? ""
        dict["katha_category_id"] = String(selectedKathaCategoryID ?? 0)
        dict["katha_slot"] = selectedKathaSlot

        if selectedKathaSlottime == "Custom" {
            dict["start_time"] = startT.text ?? ""
            dict["end_time"] = EndT.text ?? ""
        }

        let url = BASEURL + "/" + kathabookingApi
        DispatchQueue.main.async { Loader.showLoader() }

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in dict {
                if key == "file" {
                    if let fileURL = value as? URL {
                        do {
                            let fileData = try Data(contentsOf: fileURL)
                            let mimeType = fileURL.pathExtension.lowercased() == "pdf" ? "application/pdf" : "application/vnd.ms-excel"
                            let fileName = fileURL.lastPathComponent
                            multipartFormData.append(fileData, withName: "file", fileName: fileName, mimeType: mimeType)
                        } catch {
                            print("Failed to load file data: \(error.localizedDescription)")
                            return
                        }
                    } else if let imageData = value as? Data {
                        multipartFormData.append(imageData, withName: "file", fileName: "image.png", mimeType: "image/png")
                    }
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
                        self.removeData()
                        self.navigationController?.popViewController(animated: true)
                    } 
                case .failure(let error):
                    print("Upload Failed: \(error.localizedDescription)")
                }
            }
        }
    }


    @IBAction func GSTSelectBtn(_ sender: UIButton) {

        guard let amountString = amounttxt.text, let amount = Double(amountString) else {
               return
           }
           
           // Toggle the color of Gstview
        Gstradioview.backgroundColor = Gstradioview.backgroundColor == .blue ? .clear : .blue
           // Unhide the view
           self.withGstView.isHidden = false
           
           var totalAmount: Double
           if Gstradioview.backgroundColor == .blue {
               totalAmount = amount + (amount * gstRate)
           } else {
               totalAmount = amount
           }
           // Set the amount in the label
           withGstLbl.text = "\(totalAmount)"
    }
    
    @objc func amountTextChanged(_ textField: UITextField) {
        guard let amountString = textField.text, let amount = Double(amountString) else {
               // If amount is not valid, clear both GST text field and total amount label
               withGstLbl.text = ""
            Gstradioview.backgroundColor = .clear
               return
           }
           
           // Update withGstLbl based on Gstview color
           var totalAmount: Double
           if Gstradioview.backgroundColor == .blue {
               totalAmount = amount + (amount * gstRate)
           } else {
               totalAmount = amount
           }
           
           // Set the updated amount in the label
           withGstLbl.text = "\(totalAmount)"
        }
    @IBAction func selectchbutton(_ sender: UIButton) {
        switch sender {
          case sanskarbtn:
              if Sanskarradioview.backgroundColor == .blue {
                  Sanskarradioview.backgroundColor = .clear
                  type = nil
              } else {
                  clearAllChannelSelection()
                  Sanskarradioview.backgroundColor = .blue
                  type = "1"
              }
          case satsangbtn:
              if satsangradioview.backgroundColor == .blue {
                  satsangradioview.backgroundColor = .clear
                  type = nil
              } else {
                  clearAllChannelSelection()
                  satsangradioview.backgroundColor = .blue
                  type = "2"
              }
          case subhabtn:
              if subhradioview.backgroundColor == .blue {
                  subhradioview.backgroundColor = .clear
                  type = nil
              } else {
                  clearAllChannelSelection()
                  subhradioview.backgroundColor = .blue
                  type = "3"
              }
          default:
              break
          }
    }
    func clearAllChannelSelection() {
        Sanskarradioview.backgroundColor = .clear
        satsangradioview.backgroundColor = .clear
        subhradioview.backgroundColor = .clear
    }
    
    
    @IBAction func submitbtn(_ sender: UIButton) {
        BookKathaApi()
   //         clearAllChannelSelection()
            Gstradioview.backgroundColor = .clear
      //      removeData()
    }
    
    func removeData() {
        nametxt.text?.removeAll()
        venuetxt.text?.removeAll()
        amounttxt.text?.removeAll()
        todate.text?.removeAll()
        fromdate.text?.removeAll()
        startT.text?.removeAll()
        EndT.text?.removeAll()
        droptext.text?.removeAll()
        timetext.text?.removeAll()
        withGstLbl.text?.removeAll()
        clearAllChannelSelection()
    }
}
extension BookingKathaVc: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == droptable {
            return Kathatype.count
        } else if tableView == dropTable {
            return Kathatime.count
        } else if tableView == santtableview {
            return filteredSantData.count
        }else {
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
        } else if tableView == santtableview {
            let cell = santtableview.dequeueReusableCell(withIdentifier: "SantNameCell", for: indexPath)
            cell.textLabel?.text = filteredSantData[indexPath.row]["guru_name"] as? String ?? ""
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
                let safeAreaInsetsTop = view.safeAreaInsets.top
                self.view1uperconstriants.constant = safeAreaInsetsTop + 52
            } else {
                self.addview.isHidden = true
                self.view1uperconstriants.constant = 8
                // Normal value
                self.customview.isHidden = selectedValue != "Custom"
            }
            selectedKathaCategoryID = selectedIds
            DispatchQueue.main.async {
                self.kathacategoryApi()
            }
        } else if tableView == dropTable {
            let selectedValue = Kathatime[indexPath.row]["Sno"] as? String ?? ""
            let selectedValue1 = Kathatime[indexPath.row]["SlotTiming"] as? String ?? ""
            timetext.text = selectedValue1
            self.dropTable.isHidden = true
            self.dropDView.isHidden = true
            if selectedValue1 == "Custom" {
                self.customview.isHidden = false
                let safeAreaInsetsTop = view.safeAreaInsets.top
                self.view2constraints.constant = safeAreaInsetsTop + 60
                self.view3constraints.constant = safeAreaInsetsTop + 60
            } else {
                self.customview.isHidden = true
                self.view2constraints.constant = 8
                self.view3constraints.constant = 8
            }
            selectedKathaSlot = selectedValue
            selectedKathaSlottime = selectedValue1
        }
        else if tableView == santtableview {
             selectedname = filteredSantData[indexPath.row]["guru_name"] as? String ?? ""
             selectedid = filteredSantData[indexPath.row]["guru_ID"] as? Int ?? 0
            nametxt.text = selectedname
            santtableview.isHidden = true

            
        }
        
    }
}


extension BookingKathaVc: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amounttxt {
            let allowedCharacters = "0123456789"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let isNumeric = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return isNumeric
        }
        
        if textField == nametxt {
            let allowedCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: " "))
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let isAlphabetic = allowedCharacters.isSuperset(of: typedCharacterSet)

            guard let text = textField.text else { return true }
            guard let rangeOfText = Range(range, in: text) else { return true }

            let updatedText = text.replacingCharacters(in: rangeOfText, with: string)

           
            filterSantData(with: updatedText)
            
          
            santtableview.isHidden = filteredSantData.isEmpty || updatedText.isEmpty
          
            
            return isAlphabetic
        }

        
        return true
    }
    func filterSantData(with text: String) {
           if text.isEmpty {
               filteredSantData = santData
           } else {
               filteredSantData = santData.filter { ($0["guru_name"] as? String ?? "").lowercased().contains(text.lowercased()) }
           }
           santtableview.reloadData()
       }
   }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }



extension UIImage {
        func resizeToWidth5 (_ width:CGFloat)-> UIImage {
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
extension BookingKathaVc: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        
        if selectedFileURL.pathExtension == "pdf" {
            selectedPDFURL = selectedFileURL
            fileLabel.text = selectedFileURL.lastPathComponent
            
        } else if selectedFileURL.pathExtension == "xls" || selectedFileURL.pathExtension == "xlsx" {
            selectedExcelURL = selectedFileURL
            fileLabel.text = selectedFileURL.lastPathComponent
        } else {
            let alert = UIAlertController(title: "Unsupported File Format", message: "Please select a PDF or Excel file.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
                 

    }
    
}
