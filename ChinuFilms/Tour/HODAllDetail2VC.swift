//
//  HODAllDetail2VC.swift
//  SanskarEP
//
//  Created by Surya on 23/10/23.
//

import UIKit

class HODAllDetail2VC: UIViewController  {
    
    @IBOutlet weak var Header:   UILabel!
    @IBOutlet weak var tableview:UITableView!
    @IBOutlet weak var Appbtn:   UIButton!
    @IBOutlet weak var decBtn:   UIButton!
    @IBOutlet weak var Deview:   UIView!
    @IBOutlet weak var remTxt:   UITextView!
    @IBOutlet weak var apprvltxt:UITextField!
    @IBOutlet weak var tourid:   UILabel!
    @IBOutlet weak var empname:  UILabel!
    @IBOutlet weak var empcode:  UILabel!
    @IBOutlet weak var status:   UILabel!
    @IBOutlet weak var date1:    UILabel!
    @IBOutlet weak var date2:    UILabel!
    @IBOutlet weak var reqmat:   UILabel!
    @IBOutlet weak var appamt:   UILabel!
    @IBOutlet weak var amnt:     UITextField!
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var Himage:   UIImageView!
    @IBOutlet weak var LabelTxt: UILabel!
    @IBOutlet weak var reasonview: UIView!
    @IBOutlet weak var Location1: UILabel!
    @IBOutlet weak var AlertView: UIView!
    @IBOutlet weak var canclebtn: UIButton!
    @IBOutlet weak var approvebtn: UIButton!
    @IBOutlet weak var AlerMsg: UILabel!
    @IBOutlet weak var declineview: UIView!
    @IBOutlet weak var DAlertMsg: UILabel!
    @IBOutlet weak var remarkmainview: UIView!
    @IBOutlet weak var amntmainview: UIView!
    @IBOutlet weak var remarkbtnview: NSLayoutConstraint!
    @IBOutlet weak var appbuttonview: UIView!
    @IBOutlet weak var oneview: UIView!
    
    
    
    var datalist  = [[String:Any]]()
    var serials   = Int()
    var Serial    = [Int]()
    var imageData = String()
    var imageurl  = "https://sap.sanskargroup.in/uploads/tour/"
    var heamt     = ""
    var hemn      = ""
    var hemco     = ""
    var htour     = ""
    var hdat1     = ""
    var hdat2     = ""
    var haamt     = ""
    var hst       = ""
    var hsno      = ""
    var remarkLi = String()
    var imageBb  = String()
    var location = ""
    
    var selectedIndices = Set<Int>()
    var totalAmount: Double = 0.0
    var editCounter: Int = 0
 //   var originalColors: [UIView: UIColor] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newDetailApi()
      
       
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.register(UINib(nibName: "tourdetCell", bundle: nil), forCellReuseIdentifier: "tourdetCell")
        
        reset()
        
        
        tourid.text    = htour
        Location1.text = location
        empname.text = hemn
        empcode.text = hemco
        status.text  = hst
        date1.text   = hdat1
        date2.text   = hdat2
        reqmat.text  =  heamt + ".00"
   //     appamt.text  = "₹ " + haamt + ".00"
        
   //     amnt.text    = heamt
        
//        reasonL.isHidden = true
//        reas.isHidden = true
        AlertView.isHidden = true
        
        if hst == "0" {
            status.text = "Submit"
            status.textColor = UIColor.red
        } else if hst == "Approved" {
            status.text = hst
            status.textColor = UIColor.green
        }
        mainview.isHidden = true
        reasonview.isHidden = true
        declineview.isHidden = true
        
//        originalColors = [
//                   mainview: mainview.backgroundColor ?? UIColor.white,
//                   Deview: Deview.backgroundColor ?? UIColor.white,
//                   tableview: tableview.backgroundColor ?? UIColor.white,
//                   reasonview: reasonview.backgroundColor ?? UIColor.white,
//                   remTxt: remTxt.backgroundColor ?? UIColor.white,
//                   appbuttonview:appbuttonview.backgroundColor ?? UIColor.white,
//                   remarkmainview:remarkmainview.backgroundColor ?? UIColor.white,
//                   amntmainview:amntmainview.backgroundColor ?? UIColor.white
//               ]
    }
    
//    let myView = UIView()
//           myView.backgroundColor = UIColor.systemBlue
//           myView.frame = CGRect(x: 50, y: 100, width: 200, height: 100)
//           self.view.addSubview(myView)
//           
//           let path = UIBezierPath(roundedRect: approvebtn.bounds,
//                                   byRoundingCorners: [.topRight],
//                                   cornerRadii: CGSize(width: 20, height: 20))
//           let maskLayer = CAShapeLayer()
//           maskLayer.path = path.cgPath
//           approvebtn.layer.mask = maskLayer
    
    func reset() {
        Deview.layer.cornerRadius = 10
        Deview.clipsToBounds = true
        
        Appbtn.layer.cornerRadius = 10
        Appbtn.clipsToBounds = true
        
        decBtn.layer.cornerRadius = 10
        decBtn.clipsToBounds = true
        
        remTxt.layer.cornerRadius = 8
        remTxt.clipsToBounds = true
        
        apprvltxt.layer.cornerRadius = 8
        apprvltxt.clipsToBounds = true
        
        mainview.layer.cornerRadius = 10
        mainview.clipsToBounds = true
        
        AlertView.layer.cornerRadius = 10
        AlertView.clipsToBounds = true
        
        declineview.layer.cornerRadius = 10
        declineview.clipsToBounds = true
        
        remarkmainview.clipsToBounds = true
        remarkmainview.layer.cornerRadius = 8
        remarkmainview.layer.borderWidth = 1.0
        remarkmainview.layer.borderColor = UIColor.gray.cgColor
        
        amntmainview.clipsToBounds = true
        amntmainview.layer.cornerRadius = 8
        amntmainview.layer.borderWidth = 1.0
        amntmainview.layer.borderColor = UIColor.systemBlue.cgColor
        oneview.isHidden = true
    }
    
    func setData(amo: String,ing: String){
        LabelTxt.text = amo
        Himage.sd_setImage(with: URL(string: imageurl+ing))
        mainview.isHidden = false
        
    }
    
    @IBAction func backbtn(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    
    @IBAction func approvebtn(_ sender: UIButton) {
        self.TourApp("1")
 //       resetToOriginalColors()
        oneview.isHidden = false
    }
    
    @IBAction func canclebtn(_ sender: UIButton) {
        AlertView.isHidden = true
   //     resetToOriginalColors()
        oneview.isHidden = true
    }
    
    @IBAction func Approvedbtn(_ sender: UIButton) {
        
        AlertView.isHidden = false
        AlerMsg.text =  "Total Amount Approved is ₹ \(totalAmount)"
     //   applyDimmedEffect()
        oneview.isHidden = false
    }
    @IBAction func clearbtn(_ sender: UIButton) {
        mainview.isHidden = true
    }
    
    @IBAction func reasonclearbtn(_ sender: UIButton) {
        reasonview.isHidden = true
    }
    
    @IBAction func disapprove(_ sender: UIButton) {
     
        declineview.isHidden = false
        DAlertMsg.text =  "Tour bill request has been declined."
        oneview.isHidden = false
    }
    
    @IBAction func Dcancelbtn(_ sender: UIButton) {
        declineview.isHidden = true
        oneview.isHidden = true
    }
    
    @IBAction func Declinebtn(_ sender: UIButton) {
        self.TourApp("2")
        oneview.isHidden = true
    
    }
    
//    func applyDimmedEffect() {
//           let lightGrayColor = UIColor.lightGray
//           
//           mainview.backgroundColor = lightGrayColor
//           Deview.backgroundColor = lightGrayColor
//           tableview.backgroundColor = lightGrayColor
//           reasonview.backgroundColor = lightGrayColor
//           remTxt.backgroundColor = lightGrayColor
//           appbuttonview.backgroundColor = lightGrayColor
//           amntmainview.backgroundColor = lightGrayColor
//           remarkmainview.backgroundColor = lightGrayColor
//       }
       
       // Function to reset views to original colors
//       func resetToOriginalColors() {
//           for (view, color) in originalColors {
//               view.backgroundColor = color
//           }
//       }
    
    func TourApp(_ status: String) {
        var dict = Dictionary<String,Any>()
        dict["Sno"] = hsno
        dict["TourID"] = htour
        dict["Approval_status"] = status
        dict["Approval_amount"] = apprvltxt.text!
        dict["Hod_remarks"] = remTxt.text!
        
        DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: tourAppro) { result, response, error, data in
            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let JSON = response as? NSDictionary {
                if JSON.value(forKey: "status") as? Bool == true {
                    print(JSON)
                    
                    let data = (JSON["data"] as? [[String:Any]] ?? [[:]])
                    print(data)
                    
                    self.datalist = data
                    print(self.datalist)
                }
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }else {
                AlertController.alert(message: (response?.validatedValue("message"))!)
            }
            self.tableview.reloadData()
        }
    }
    
    func newDetailApi() {
        var dict = Dictionary<String,Any>()
        dict["TourId"] = htour
        dict["type"] =  "1"
        APIManager.apiCall(postData: dict as NSDictionary, url: tupdatet) { result, response, error, data in
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
                        self.selectedIndices.insert(i)
                   }
                   print(self.Serial)
                    self.updateTotalAmount()
                //    AlertController.alert(message: JSON.value(forKey: "message") as! String)
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                }
            }
        }
    }
    @objc
    func imageOnclick(_ sender: UIButton) {
        let indexPathRow = sender.tag
           let selectedData = datalist[indexPathRow]
           let imageBb = selectedData["Billing_thumbnail"] as? String ?? ""
           let img = imageBb.replacingOccurrences(of: " ", with: "%20")
           Himage.sd_setImage(with: URL(string: imageurl + img))
           mainview.isHidden = false
    }
    
    @objc
    func remarkOnclick(_ sender: UIButton) {
        let indexPathRow = sender.tag
           let selectedData = datalist[indexPathRow]
           let remarkLi = selectedData["reason"] as? String ?? ""
           LabelTxt.text = remarkLi
           reasonview.isHidden = false
    }
    func updateTotalAmount() {
            totalAmount = 0.0
            
            for index in selectedIndices {
                if let amountString = datalist[index]["Amount"] as? String, let amount = Double(amountString) {
                    totalAmount += amount
                }
            }
            
            amnt.text = "\(totalAmount)"
           appamt.text = "\(totalAmount)"
        }
    }

extension HODAllDetail2VC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Ensure only numeric characters are allowed
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

extension HODAllDetail2VC: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tourdetCell", for: indexPath) as! tourdetCell
        
//        let requestAmount = datalist[indexPath.row]["Amount"] as? String ?? ""
//        cell.amounttxt.text = "RS " + amount
        
            cell.amounttxt.keyboardType = .numberPad
            cell.amounttxt.delegate = self
        
        if let requestAmount = datalist[indexPath.row]["Amount"] as? String {
            cell.amounttxt.text = requestAmount + ".00"
        } else {
            cell.amounttxt.text = "₹ 0" // or handle the case where the amount is not found
        }

      //  cell."RS = " + amounttxt.text = requestAmount
        let serials = datalist[indexPath.row]["Sno"] as? Int ?? 0
        cell.SLabel.text = String(serials)
        print(serials)
        let remark = datalist[indexPath.row]["reason"] as? String ?? ""
        cell.remarkL.text = String(remark)
        imageData = datalist[indexPath.row]["Billing_thumbnail"] as? String ?? ""
        let img = imageData.replacingOccurrences(of: " ", with: "%20")
        print(img)
        cell.TImage.sd_setImage(with: URL(string: imageurl+img))
        cell.imagebutton.tag = indexPath.row
        cell.remarkbtn.tag = indexPath.row
        
        
        
        if selectedIndices.contains(indexPath.row) {
            
            cell.checkmarkImage.image = UIImage(named: "check-mark 1")
           
        } else {
            cell.checkmarkImage.image = UIImage(named: "checkmark")
            cell.configureCell(isEditable: false)
        }
        
        cell.imagebutton.addTarget(self, action: #selector(imageOnclick(_:)), for: .touchUpInside)
        cell.remarkbtn.addTarget(self, action: #selector(remarkOnclick(_:)), for: .touchUpInside)
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndices.contains(indexPath.row) {
            // Deselecting the row
            selectedIndices.remove(indexPath.row)
            
            // Add reject message to remTxt
            if let serial = datalist[indexPath.row]["Sno"] as? Int,
               let amount = datalist[indexPath.row]["Amount"] as? String {
                let rejectMessage = "Rejected amount for SNo \(serial) is ₹\(amount)"
                updateMessage(for: serial, with: rejectMessage)
            }
        } else {
            // Selecting the row
            selectedIndices.insert(indexPath.row)
            
            // Add approved message to remTxt
            if let serial = datalist[indexPath.row]["Sno"] as? Int,
               let amount = datalist[indexPath.row]["Amount"] as? String {
                let approveMessage = ""
                updateMessage1(for: serial, with: approveMessage)
            }
        }
        
        updateTotalAmount()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    func updateMessage(for serial: Int, with newMessage: String) {
        var messages = remTxt.text.components(separatedBy: "\n")
      
        if let existingMessageIndex = messages.firstIndex(where: { $0.contains("SNo \(serial)") }) {
            messages[existingMessageIndex] = newMessage
        } else {
            messages.append(newMessage)
        }
        remTxt.text = messages.joined(separator: "")
    }
    
    func updateMessage1(for serial: Int, with newMessage: String) {
        var messages = remTxt.text.components(separatedBy: "\n")
        if let existingMessageIndex = messages.firstIndex(where: { $0.contains("SNo \(serial)") }) {
            messages[existingMessageIndex] = newMessage
        } else {
            messages.append(newMessage)
        }
        remTxt.text = messages.joined(separator: "")
    }
}

    extension HODAllDetail2VC: tourdetCellDelegate {
        func amountDidChange(_ cell: tourdetCell, serial: String, amount: String) {
            guard let indexPath = tableview.indexPath(for: cell) else { return }
            
            // Update the amount in the datalist
            datalist[indexPath.row]["Amount"] = amount
            updateTotalAmount()
            
            // Check if the cell is selected
            if selectedIndices.contains(indexPath.row) {
                // Check if there's already a message for the current serial
                var existingMessageIndex: Int?
                for (index, message) in remTxt.text.components(separatedBy: "\n").enumerated() {
                    if message.contains("SNo \(serial)") {
                        existingMessageIndex = index
                        break
                    }
                }
                
                let newMessage = "Edited amount for SNo \(serial) is ₹\(amount)"
                
                if let index = existingMessageIndex {
                    // Update existing message
                    var messages = remTxt.text.components(separatedBy: "\n")
                    messages[index] = newMessage
                    remTxt.text = messages.joined(separator: "\n")
                } else {
                    // Add new message
                    remTxt.text += newMessage + "\n"
                }
            }
        }
    }
