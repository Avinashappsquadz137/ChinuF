//
//  GuestManageVc.swift
//  SanskarEP
//
//  Created by Sanskar IOS Dev on 09/08/23.
//

import UIKit

class GuestManageVc: UIViewController {
    
    @IBOutlet var tittleLbl: UILabel!
    @IBOutlet var TableView: UITableView!
    
    var titleText: String?
    var GuestTask = [
        GuestManage(title: "New Guest", image: "Guest"),
        GuestManage(title: "Your Guest List", image: "Guest"),
        GuestManage(title: "Your Visitor List", image: "Guest"),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        TableView.register(UINib(nibName: kCell.GuestManage, bundle: nil), forCellReuseIdentifier: kCell.GuestManage)
        tittleLbl.text = titleText
        TableView.dataSource = self
        TableView.delegate = self
        TableView.backgroundColor = .clear
        TableView.reloadData()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func BackBtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
}
extension GuestManageVc: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GuestTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: kCell.GuestManage, for: indexPath) as? GuestManageCell else {
                return UITableViewCell()
            }
            
            let image = UIImage(named: GuestTask[indexPath.row].image)
            cell.ImageView.image = image
            cell.Label.text = GuestTask[indexPath.row].title
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .clear
            return cell
        }
    }

extension GuestManageVc: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let index = indexPath.row
        switch index {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "GuestVc") as! GuestVc
            vc.titleTxt = GuestTask[index].title
            navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "GuestHistoryVc") as! GuestHistoryVc
            vc.titleTxt = GuestTask[index].title
            navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: "VistorHistoryVC") as! VistorHistoryVC
            vc.titleText = GuestTask[index].title
            navigationController?.pushViewController(vc, animated: true)
            self.present(vc,animated: true,completion: nil)
        default:
            print(index)
        }
    }
}
