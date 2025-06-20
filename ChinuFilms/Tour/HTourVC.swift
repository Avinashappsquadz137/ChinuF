//
//  HTourVC.swift
//  SanskarEP
//
//  Created by Surya on 10/10/23.
//

import UIKit

class HTourVC: UIViewController {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "HTourCell", bundle: nil), forCellReuseIdentifier: "HTourCell")
    }
    
    @objc
    func BtnOnclick(_ sender: UIButton )  {
        let tour = storyboard?.instantiateViewController(withIdentifier: "ATourVC") as! ATourVC
      present(tour, animated: true)
    }

    @IBAction func backbtn(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
    

}
extension HTourVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HTourCell", for: indexPath) as! HTourCell
        cell.PendingB.addTarget(self, action: #selector(BtnOnclick(_:)), for: .touchUpInside)
        return cell
    }
    
}
