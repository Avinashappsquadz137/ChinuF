//
//  HomeVc.swift
//  SanskarEP
//
//  Created by Warln on 11/01/22.
//

import UIKit
import SDWebImage
import FSCalendar 

class HomeVc: UIViewController {
    //MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var BdayButton: UIButton!
    
    @IBOutlet var MarqueeLbl: UILabel!
    
    var empData: EmpLData?
    var status: Int?
    var noteLbl: Bool = false
    var aprove: Bool = false
    var book: Bool = false
    var task = [
        TaskManagement(taskName: "Request Managment ", taskImg: "Request (1)"),
        TaskManagement(taskName: "Reports", taskImg: "Reports"),
        TaskManagement(taskName: "Health Managment", taskImg: "Health"),
        TaskManagement(taskName: "Guest Management", taskImg: "Guest"),
        
     //   TaskManagement(taskName: "Tour Management", taskImg: "world-map"),
    ]
    //MARK: - Override Viewdidloaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BdayButton.layer.cornerRadius = 20
        BdayButton.clipsToBounds = true
        MarqueeLbl.textAlignment = .left
        MarqueeLbl.text = "Upcoming BirthDay! Hello guys !!Welcome to Sanskar Portal!!"
       // MarqueeLbl.scrollDuration = 5.0
        updateUI()
        if currentUser.Code == "H"{
            let data = TaskManagement(taskName: "Approval", taskImg: "Approved 1")
            task.insert(data, at: 4)
            aprove = true
        }
        NotificationCenter.default.post(name: NSNotification.Name("NtCount"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didNotify), name: NSNotification.Name("Note"), object: nil)
        getListData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let noteCount = UserDefaults.standard.value(forKey: "noteCount") as? Int ?? 0
        if noteCount > 0 {
            noteLbl = false
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }else{
            noteLbl = true
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    @IBAction func ButtonTapped(_ sender: Any) {
        let profile = storyboard?.instantiateViewController(withIdentifier: "ProfileVc") as! ProfileVc
        self.navigationController?.pushViewController(profile, animated: true)
    }
    
    
    @IBAction func bdaywish(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewHomeVC") as! NewHomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func BirthButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BdayViewController") as! BdayViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func approved(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
//        let sheetPresentationController = storyboard.instantiateViewController(withIdentifier: "SheetViewController1") as! SheetViewController1
//        self.present(sheetPresentationController,animated: true,completion: nil)
        if currentUser.Code == "H"{
            let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kApprove) as! ApprovalVc
            self.present(vc,animated: true,completion: nil)
           // aprove.isHidden == true
        }
//
//     //   vc.titleTxt = task[index].taskName
   //    self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK: - Update UI
    func updateUI() {
        let margin: CGFloat = 5.0
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
       guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return}
       flowLayout.minimumInteritemSpacing = margin
       flowLayout.minimumLineSpacing = margin
       flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @objc
    func didNotify () {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVc") as! NotificationVc
        vc.titleTxt = "Notification"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getListData() {
        let dict = Dictionary<String,Any>()
 //       DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: exList) { result, response, error, data in
    //        DispatchQueue.main.async(execute: {Loader.hideLoader()})
            if let json = data,(response?["status"] as? Bool == true), response != nil {
                let decode = JSONDecoder()
                do{
                    self.empData = try decode.decode(EmpLData.self, from: json)
                    self.matchList()
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func matchList() {
        guard let lists = empData?.data else {return}
        if lists.count > 0 {
            for list in lists {
                switch currentUser.EmpCode {
                case list.empCode:
                  //  let data = TaskManagement(taskName: "Booking", taskImg: "flight")
                    status = list.status
                    book = true
                  //  task.insert(data, at: 5)
                    
                    if note == true {
                        didNotify()
                    }
                default:
                    break
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.fetchData()
            }
        }
    }
    
    func fetchData() {
        var dict = Dictionary<String,Any>()
        dict["EmpCode"] = currentUser.EmpCode
 //       DispatchQueue.main.async(execute: {Loader.showLoader()})
        APIManager.apiCall(postData: dict as NSDictionary, url: notifyList) { result, response, error, data in
//            DispatchQueue.main.async(execute: {Loader.hideLoader()})
            guard let data = data , error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            do{
                let result = try JSONDecoder().decode(NotifyResponse.self, from: data)
                UserDefaults.standard.set(result.data?.count, forKey: "noteCount")
                DispatchQueue.main.async {
                    if result.data?.count == 0 {
                        self.noteLbl = true
                    }else{
                        self.noteLbl = false
                    }
                    self.collectionView.reloadData()
                }
            }catch{
                print(error.localizedDescription)
            }
            
        }
    }
}

//MARK: - UICollectionViewDataSource
extension HomeVc: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return task.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCell.home, for: indexPath) as? HomeCell else{
            return UICollectionViewCell()
        }
        let image = task[indexPath.row].taskImg
        cell.imgView.image = UIImage(named: image)
        cell.taskLbl.text = task[indexPath.row].taskName
        cell.taskBtn.tag = indexPath.row
        cell.taskBtn.addTarget(self, action: #selector(HomeVc.onClickedMapButton(_:)), for: .touchUpInside)
        shadow(cell)
        return cell
    }
    
}
//MARK: - UICollectionViewDelegate

extension HomeVc: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader :
            if let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kCell.header, for: indexPath) as? HeaderCell {
                let img = currentUser.PImg.replacingOccurrences(of: " ", with: "%20")
                if #available(iOS 13.0, *) {
                    headerCell.imgView.sd_setImage(with: URL(string:img), placeholderImage: UIImage(systemName: "person.circle.fill"), options: .refreshCached, completed: nil)
                } else {
                    // Fallback on earlier versions
                }
                let noteNo = UserDefaults.standard.value(forKey: "noteCount")
   //             headerCell.imgView.circleImg(0.1, UIColor.gray)
                headerCell.empName.text = currentUser.Name
                headerCell.empCode.text = currentUser.EmpCode
                headerCell.DOB.text = currentUser.BDay
                headerCell.InTime.text = currentUser.today_intime
                headerCell.notifyLbl.circleLbl()
                if let noteNo = noteNo as? Int {
                    headerCell.notifyLbl.text = "\(noteNo)"
                }
                if noteLbl{
                    headerCell.notifyLbl.isHidden = true
                }else{
                    headerCell.notifyLbl.isHidden = false
                }
                headerCell.serachBtn.tag = indexPath.row
                headerCell.serachBtn.addTarget(self, action: #selector(HomeVc.searchBtnPressed(_:)), for: .touchUpInside)
                return headerCell
            }
        default:
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
}

extension HomeVc: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: 120, height: 130)
    }
}
//MARK: - Extra funcationality

extension HomeVc {
    
    @objc func searchBtnPressed(_ sender: UIButton) {
        print(sender.tag)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVc") as! NotificationVc
        vc.titleTxt = "Notification"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onClickedMapButton(_ sender: UIButton) {
        print(sender.tag)
        let index = sender.tag
        if book == true || aprove == true {
            switch sender.tag {
            case 0 :
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.requestVc) as! RequestMgVc
               vc.titleSt = task[index].taskName
                print(vc.titleSt)
               // self.navigationController?.pushViewController(vc, animated: true)
       //         self.present(vc,animated: true,completion: nil)
               self.navigationController?.pushViewController(vc, animated: true)
            case 1 :
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.leave ) as! LeaveMangeVc
                vc.titletext = task[index].taskName
               self.navigationController?.pushViewController(vc, animated: true)
              //  self.present(vc,animated: true,completion: nil)
//                let vc = CalenderVC()
////                vc.title = "Calender"
//                self.navigationController?.pushViewController(vc, animated: true)
            case 2 :
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.healthVc) as! HealthVc
              //  vc.titleTxt = task[index].taskName
             //   self.present(vc,animated: true,completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            case 3 :
               let vc = storyboard?.instantiateViewController(withIdentifier: idenity.GuestManage) as! GuestManageVc
               vc.titleText = task[index].taskName
                
            //    self.present(vc,animated: true,completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            case 4 :
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.kApprove) as! ApprovalVc
                vc.titleTxt = task[index].taskName
                self.present(vc,animated: true,completion: nil)
                
              // self.navigationController?.pushViewController(vc, animated: true)
//           case 4 :
//               let vc = storyboard?.instantiateViewController(withIdentifier: idenity.tour ) as! TourManageVc
//               vc.titleTxt = task[index].taskName
//
//                self.navigationController?.pushViewController(vc, animated: true)
           
//            case 5 :
//              let vc = storyboard?.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
       //         self.present(vc,animated: true,completion: nil)
         //     vc.status = status
//                vc.text = task[index].taskName
             //   self.navigationController?.pushViewController(sheetPresentationController, animated: true)
            default:
                break
            }
            
        }else{
            switch sender.tag {
            case 0 :
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.requestVc) as! RequestMgVc
               vc.titleSt = task[index].taskName
                print(vc.titleSt)
               // self.navigationController?.pushViewController(vc, animated: true)
                self.present(vc,animated: true,completion: nil)
      //         self.navigationController?.pushViewController(vc, animated: true)
//            case 1 :
//                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.leave ) as! LeaveMangeVc
//                vc.titleText = task[index].taskName
//              // self.navigationController?.pushViewController(vc, animated: true)
//                self.present(vc,animated: true,completion: nil)
//                let vc = CalenderVC()
////                vc.title = "Calender"
//                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.leave) as! LeaveMangeVc
                vc.titletext = task[index].taskName
         //       self.present(vc,animated: true,completion: nil)
               self.navigationController?.pushViewController(vc, animated: true)
            case 2 :
               let vc = storyboard?.instantiateViewController(withIdentifier: idenity.healthVc) as! HealthVc
               vc.titleTxt = task[index].taskName
                
            //    self.present(vc,animated: true,completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            case 3 :
                let vc = storyboard?.instantiateViewController(withIdentifier: idenity.GuestManage) as! GuestManageVc
                vc.titleText = task[index].taskName
         //       self.present(vc,animated: true,completion: nil)
                
               self.navigationController?.pushViewController(vc, animated: true)
//           case 4 :
//               let vc = storyboard?.instantiateViewController(withIdentifier: idenity.tour ) as! TourManageVc
//               vc.titleTxt = task[index].taskName
//
//                self.navigationController?.pushViewController(vc, animated: true)
           
//            case 5 :
//              let vc = storyboard?.instantiateViewController(withIdentifier: "BookingVC") as! BookingVC
       //         self.present(vc,animated: true,completion: nil)
         //     vc.status = status
//                vc.text = task[index].taskName
             //   self.navigationController?.pushViewController(sheetPresentationController, animated: true)
            default:
                break
            }
            
        }

    }
}
