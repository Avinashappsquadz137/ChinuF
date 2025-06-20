//
//  NewRequestVc.swift
//  SanskarEP
//
//  Created by Surya on 25/06/24.
//

import UIKit

class NewRequestVc: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var headerview: UILabel!
    
    var NewRequestTask = [
        NewRequestManage(title: "Leave Request", image: "exit_198141"),
    //    NewRequestManage(title: "Booking", image: "booking"),
        NewRequestManage(title: "Other's", image: "other"),
    ]
    var titleSt: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "NewReqCell", bundle: nil), forCellReuseIdentifier: "NewReqCell")
        headerview.text = titleSt
        tableview.dataSource = self
        tableview.delegate = self
//        tableview.backgroundColor = .clear
//        tableview.reloadData()
        
        if currentUser.Code == "H" {
            let data = NewRequestManage(title: "Booking", image: "booking")
            NewRequestTask.insert(data, at: 1)
        }
    }
    

    
    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    
}
extension NewRequestVc: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NewRequestTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewReqCell", for: indexPath) as? NewReqCell else {
                return UITableViewCell()
            }
            
            let image = UIImage(named: NewRequestTask[indexPath.row].image)
            cell.imageview.image = image
            cell.HeadLabel.text = NewRequestTask[indexPath.row].title
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .clear
            return cell
        }
    }

extension NewRequestVc: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let index = indexPath.row
               
               if currentUser.Code == "H" {
                   switch index {
                   case 0:
                       let vc = storyboard?.instantiateViewController(withIdentifier: idenity.requestVc) as! RequestMgVc
                       navigationController?.pushViewController(vc, animated: true)
                       self.present(vc, animated: true, completion: nil)
                   case 1:
                       let vc = storyboard?.instantiateViewController(withIdentifier: "KathaVC") as! KathaVC
                       navigationController?.pushViewController(vc, animated: true)
                       self.present(vc, animated: true, completion: nil)
                   case 2:
                       let vc = storyboard?.instantiateViewController(withIdentifier: "OthersVC") as! OthersVC
                       navigationController?.pushViewController(vc, animated: true)
                       self.present(vc, animated: true, completion: nil)
                   default:
                       print(index)
                   }
               } else {
                   switch index {
                   case 0:
                       let vc = storyboard?.instantiateViewController(withIdentifier: idenity.requestVc) as! RequestMgVc
                       navigationController?.pushViewController(vc, animated: true)
                       self.present(vc, animated: true, completion: nil)
                   case 1:
                       let vc = storyboard?.instantiateViewController(withIdentifier: "OthersVC") as! OthersVC
                       navigationController?.pushViewController(vc, animated: true)
                       self.present(vc, animated: true, completion: nil)
                   default:
                       print(index)
                   }
               }
           }
}
