//
//  TourDetail'sVc.swift
//  SanskarEP
//
//  Created by Surya on 08/12/23.
//

import UIKit

class TourDetail_sVc: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var HeaderLbl: UILabel!
    
  
    var titletext: String?
    var TourTask = [
        TourDetail(title: "My Submited Tour's", image: "approve"),
        TourDetail(title: "Approved / Rejected Tour's", image: "Approved 1"),
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        HeaderLbl.text = titletext
        tableview.register(UINib(nibName: kCell.GuestManage, bundle: nil), forCellReuseIdentifier: kCell.GuestManage)
     
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = .clear
        tableview.reloadData()

    }
    

    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
}
extension TourDetail_sVc: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TourTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kCell.GuestManage, for: indexPath) as? GuestManageCell else {
                return UITableViewCell()
            }
            
            let image = UIImage(named: TourTask[indexPath.row].image)
            cell.ImageView.image = image
            cell.Label.text = TourTask[indexPath.row].title
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .clear
            return cell
        }
    }
extension TourDetail_sVc: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let index = indexPath.row
        switch index {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "AllDetail2VC") as! AllDetail2VC
            vc.type = "1"
       //     vc.titleTxt = TourTask[index].title
            navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "ApprovedTourVC") as! ApprovedTourVC
            vc.type = "4"
       //     vc.titleTxt = TourTask[index].title
            navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        default:
            print(index)
        }
    }
}
