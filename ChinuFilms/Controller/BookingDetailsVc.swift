//
//  BookingDetailsVc.swift
//  SanskarEP
//
//  Created by Surya on 30/04/24.
//

import UIKit

class BookingDetailsVc: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var titletext: String?
    var BookingTask = [
        BookingDetail(title: "Submited Booking's", image: "approve"),
        BookingDetail(title: "Approved / Rejected Booking's", image: "Approved 1"),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "BookingDetailCell", bundle: nil), forCellReuseIdentifier: "BookingDetailCell")
     
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = .clear
        tableview.reloadData()
       
    }
    

    @IBAction func backbtn(_ sender: UIButton) {
      dismiss(animated: true,completion: nil)
    }
    

}
extension BookingDetailsVc: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookingTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingDetailCell", for: indexPath) as! BookingDetailCell
            
            let image = UIImage(named: BookingTask[indexPath.row].image)
            cell.imageview.image = image
            cell.Label.text = BookingTask[indexPath.row].title
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .clear
            return cell
        }
    }
extension BookingDetailsVc: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let index = indexPath.row
        switch index {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "SaveListVc") as! SaveListVc
       //     vc.type = "1"
         //   vc.titleTxt = TourTask[index].title
            navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "ApprovedTourVC") as! ApprovedTourVC
     //       vc.type = "4"
       //     vc.titleTxt = TourTask[index].title
            navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        default:
            print(index)
        }
    }
}
