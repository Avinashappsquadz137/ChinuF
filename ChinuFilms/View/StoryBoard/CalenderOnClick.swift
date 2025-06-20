//
//  CalenderOnClick.swift
//  SanskarEP
//
//  Created by Surya on 21/08/24.
//

import UIKit

class CalenderOnClick: UIViewController {

    @IBOutlet weak var requestTypeView: UIView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var leaveContainerview: UIView!
    @IBOutlet weak var BookingContainerview: UIView!
    @IBOutlet weak var TourContainerview: UIView!
    @IBOutlet weak var PayslipContainerview: UIView!
    @IBOutlet weak var AdvanceContainerview: UIView!
    @IBOutlet weak var StationaryContainerview: UIView!
    @IBOutlet weak var HealthContainerview: UIView!
    @IBOutlet weak var GuestContainerview: UIView!
    @IBOutlet weak var ReportContainerview: UIView!
    @IBOutlet weak var OtherContainerview: UIView!
    @IBOutlet weak var ApprovalContainerview: UIView!
    @IBOutlet weak var RequestContainerview: UIView!
    @IBOutlet weak var InventoryContainerview: UIView!
    @IBOutlet weak var PrivacyPolicyContanierview: UIView!
    @IBOutlet weak var TerminateContanierview: UIView!
    @IBOutlet weak var cancelContanierview: UIView!
    @IBOutlet weak var SelfContanierview: UIView!
    @IBOutlet weak var PunchHistoryContanierview: UIView!
    @IBOutlet weak var collectionviewD: UICollectionView!
    
    
    
    var leavecontainerviewdata = CalendersheetVC.self
    var aprove: Bool = false
    var ReqType  = [[String:Any]]()
    
    var selectedRequestType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTypeView.layer.cornerRadius = 10
        
        SideBarApi()

           
        collectionviewD.register(UINib(nibName: "MainHeaderCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionviewD.dataSource = self
        collectionviewD.delegate = self
        
        hideAllContainerViews()


    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self.view)
            if !requestTypeView.frame.contains(location) {
                requestTypeView.isHidden = true
                collectionviewD.isHidden = true
            }
        }
    }
    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func SideBarApi() {
            var dict = Dictionary<String, Any>()
            dict["EmpCode"] = currentUser.EmpCode
       
            DispatchQueue.main.async { Loader.showLoader() }
            APIManager.apiCall(postData: dict as NSDictionary, url: sidebarapi) { result, response, error, data in
                DispatchQueue.main.async { Loader.hideLoader() }
                if let JSON = response as? NSDictionary, let status = JSON["status"] as? Bool, status == true,
                   let data = JSON["data"] as? [[String: Any]] {
                    self.ReqType = data
                    DispatchQueue.main.async {
                        self.collectionviewD.reloadData()
                        self.showApprovalIfNeeded()
                    }
                } else {
                    if let message = response?.validatedValue("message") as? String {
                       AlertController.alert(message: message)
                    } else {
                        AlertController.alert(message: "An unexpected error occurred.")
                    }
                }
            }
        }
    func showApprovalIfNeeded() {
           if ReqType.contains(where: { $0["name"] as? String == "Approval" }) {
               aprove = true
           }
       }
    
    
  
    
    func showContainerView(for name: String) {
        hideAllContainerViews()
        
        let viewMapping: [String: UIView] = [
            "Approval": ApprovalContainerview,
            "Leave": leaveContainerview,
            "Booking": BookingContainerview,
            "Inventory": InventoryContainerview,
            "Request": RequestContainerview,
            "Tour": TourContainerview,
            "Reports": ReportContainerview,
            "Guest": GuestContainerview,
            "Advance": AdvanceContainerview,
            "Stationary": StationaryContainerview,
            "Health": HealthContainerview,
            "Pay Slip": PayslipContainerview,
            "Other": OtherContainerview,
            "Privacy Policy": PrivacyPolicyContanierview,
            "Delete Account": TerminateContanierview,
            "Leave cancellation": cancelContanierview,
            "Self Punch": SelfContanierview,
            "Punch History": PunchHistoryContanierview
        ]

        
        if let selectedView = viewMapping[name] {
            selectedView.isHidden = false
        }
    }

    
    func updateSheetHeight() {
        guard let vc = self.presentedViewController as? CalenderOnClick else { return }
        
        if let sheet = vc.sheetPresentationController {
            let detentHeight: CGFloat = (selectedRequestType == "Self Punch" || selectedRequestType == "Punch History") ? 700 : 575
            if #available(iOS 16.0, *) {
                let customDetent = UISheetPresentationController.Detent.custom { _ in
                    return detentHeight
                }
                sheet.detents = [customDetent]
            } else {
                sheet.detents = (selectedRequestType == "Self Punch" || selectedRequestType == "Punch History") ? [.medium(), .large()] : [.medium()]
            }
        }
    }
    
    func hideAllContainerViews() {
           let allContainers = [
               leaveContainerview, BookingContainerview, TourContainerview,
               PayslipContainerview, AdvanceContainerview, StationaryContainerview,
               HealthContainerview, GuestContainerview, ReportContainerview,
               OtherContainerview, ApprovalContainerview, RequestContainerview,
               InventoryContainerview,PrivacyPolicyContanierview,TerminateContanierview,cancelContanierview,SelfContanierview,PunchHistoryContanierview
           ]
           allContainers.forEach { $0?.isHidden = true }
       }
    @IBAction func RequestBtnclick(_ sender: UIButton) {
        hideAllContainerViews()
        self.requestTypeView.isHidden = !self.requestTypeView.isHidden
        self.collectionviewD.isHidden = !self.collectionviewD.isHidden
    }
}

extension CalenderOnClick: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return ReqType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MainHeaderCell else {
            return UICollectionViewCell()
        }

        let item = ReqType[indexPath.row]
        let name = item["name"] as? String ?? ""
        let id = item["id"] as? Int ?? 0

        cell.namelable.text = name

       
        switch id {
        case 1:
            cell.image.image = UIImage(named: "approved")
        case 2:
            cell.image.image = UIImage(named: "Leave")
        case 3:
            cell.image.image = UIImage(named: "booking 1")
        case 4:
            cell.image.image = UIImage(named: "Inventory")
        case 5:
            cell.image.image = UIImage(named: "interview")
        case 6:
            cell.image.image = UIImage(named: "Tour 1")
        case 7:
            cell.image.image = UIImage(named: "Reports")
        case 8:
            cell.image.image = UIImage(named: "Guest 2")
        case 11:
            cell.image.image = UIImage(named: "healthcare")
        case 14:
            cell.image.image = UIImage(named: "Privacy Policy")
        case 24:
            cell.image.image = UIImage(named: "biometric-attendance")
        case 25:
            cell.image.image = UIImage(named: "attendance")
        default:
            cell.image.image = UIImage(named: "default") 
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSearchResult = ReqType[indexPath.row]["name"] as? String ?? ""
        typeLbl.text = selectedSearchResult
        showContainerView(for: selectedSearchResult)
        requestTypeView.isHidden = true
        collectionviewD.isHidden = true
        updateSheetHeight()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: 120, height: 130)
    }

}
