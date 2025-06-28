//
//  PunchHistoryOut.swift
//  SanskarEP
//
//  Created by Vaibhav on 21/03/25.
//

import UIKit

class PunchHistoryOut: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var frombtn: UIButton!
    @IBOutlet weak var tobtn: UIButton!
    @IBOutlet weak var sendbtn: UIButton!
    @IBOutlet weak var Headrview: UIView!
    @IBOutlet weak var filtertableview: UITableView!
 
    
    
    let headers = ["Date", "In Time", "Out Time", "Location"]
 //   let image = #imageLiteral(resourceName: "location (2)")
  
    var PunchHistoryModel = [Attendance]()
    
    var Days = ["7 Days","15 Days","1 Month","3 Months","6 Months","Custom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        getDetails()
        reset()
        filtertableview.register(UINib(nibName: "AssignListCell", bundle: nil), forCellReuseIdentifier: "AssignListCell")
        filtertableview.isHidden = true
        sendbtn.isHidden = true
    }
    func reset() {
        
        frombtn.layer.cornerRadius = 10
        frombtn.clipsToBounds = true
        frombtn.layer.borderWidth = 1.0
        frombtn.layer.borderColor = UIColor.darkGray.cgColor
        
//        Headrview.layer.cornerRadius = 8
//        Headrview.clipsToBounds = true
//        Headrview.layer.borderWidth = 1.0
//        Headrview.layer.borderColor = UIColor.darkGray.cgColor
        
        
        tobtn.layer.cornerRadius = 10
        tobtn.clipsToBounds = true
        tobtn.layer.borderWidth = 1.0
        tobtn.layer.borderColor = UIColor.darkGray.cgColor
    }
    func getDetails() {
        
        var dict: [String: Any] = [:]
        dict["EmpCode"] = currentUser.EmpCode

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        dateFormatter.timeZone = TimeZone.current

        let fromDateText = frombtn.title(for: .normal) ?? ""
        let toDateText = tobtn.title(for: .normal) ?? ""

        let currentDate = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)

        if let fromDate = dateFormatter.date(from: fromDateText),
           let toDate = dateFormatter.date(from: toDateText),
           fromDateText != "From Date",
           toDateText != "To Date" {
            
            let fromEpoch = String(Int(fromDate.timeIntervalSince1970 * 1000))
            if let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate) {
                let toEpoch = String(Int(endOfDay.timeIntervalSince1970 * 1000))
                dict["to_date"] = toEpoch
            }



            dict["from_date"] = fromEpoch
            dict["month"] = "-1"
            dict["year"] = "\(currentYear)" 
        } else {
            dict["month"] = String(format: "%02d", currentMonth)
            dict["year"] = "\(currentYear)"
        }

        DispatchQueue.main.async { Loader.showLoader() }
        APIManager.apiCall(postData: dict as NSDictionary, url: monthwisedetailapi) { result, response, error, data in
            DispatchQueue.main.async { Loader.hideLoader() }
            guard let data = data, error == nil else {
                AlertController.alert(message: error?.localizedDescription ?? "Unknown error")
                return
            }
            do {
                let json = try JSONDecoder().decode(ChinuFilms.PunchHistoryModel.self, from: data)
                self.PunchHistoryModel.removeAll()

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yy"
                let today = dateFormatter.string(from: currentDate)

                let filteredData = json.data?.filter { attendance in
                    if let dateStr = attendance.date1, let date = dateFormatter.date(from: dateStr) {
                        return date <= dateFormatter.date(from: today)!
                    }
                    return false
                } ?? []

                self.PunchHistoryModel.append(contentsOf: filteredData)

                // **Set from date & to date**
                if let firstDate = filteredData.first?.date1 {
                    DispatchQueue.main.async {
                        self.frombtn.setTitle(firstDate, for: .normal)
                    }
                }

                DispatchQueue.main.async {
                    self.tobtn.setTitle(today, for: .normal)
                    self.tableView.reloadData()
                }

            } catch {
                print("Decoding Error: \(error.localizedDescription)")
            }
        }
    }
    @objc func CheckboxTapped(_ sender: UIButton) {
        let index = sender.tag
            let rowData = PunchHistoryModel[index]

            let locationIn = rowData.locationIn ?? "N/A"
            let locationOut = rowData.locationOut ?? "N/A"

            let alertMessage = "1.Punch In: \(locationIn) \n2.Punch Out: \(locationOut)"
            
            let alert = UIAlertController(title: "Location Details", message: alertMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)

            self.present(alert, animated: true, completion: nil)
        }
    

   
    @IBAction func fromdateonclick(_ sender: UIButton) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
               let selectedDate = Utils.dateString(date: date, format: "dd-MM-yy")
               self.frombtn.setTitle(selectedDate, for: .normal)
           }
    }
    
    @IBAction func todateclick(_ sender: Any) {
        IosDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { date in
                let selectedDate = Utils.dateString(date: date, format: "dd-MM-yy")
                self.tobtn.setTitle(selectedDate, for: .normal)
            }
    }
    
    @IBAction func sendOnclck(_ sender: UIButton) {
        getDetails()
    }
    
    @IBAction func filterOnClick(_ sender: UIButton) {
        self.filtertableview.isHidden = !self.filtertableview.isHidden
        self.filtertableview.reloadData()
    }
    
    func getDayFromDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd"
            return dateFormatter.string(from: date)
        }
        return dateString
    }

}
// MARK: - UITableViewDataSource
extension PunchHistoryOut: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return PunchHistoryModel.count
        } else if tableView == self.filtertableview {
            return Days.count
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PunchCell", for: indexPath) as! PunchHistoryTableViewCell
            let rowData = PunchHistoryModel[indexPath.row]
            
            let fullDate = rowData.date1 ?? ""
            let dayOnly = getDayFromDate(dateString: fullDate)
                    
            cell.dateLabel.text = dayOnly
            cell.inTimeLabel.text = rowData.inTime?.isEmpty == false ? rowData.inTime : "-"
            cell.outTimeLabel.text = rowData.outTime?.isEmpty == false ? rowData.outTime : "-"
            
            let locationIn = rowData.locationIn ?? "-"
            let locationOut = rowData.locationOut ?? "-"
            
            cell.locationLabel.setTitle("\(locationIn), \(locationOut)", for: .normal)

            cell.locationLabel.tag = indexPath.row
            cell.locationLabel.addTarget(self, action: #selector(CheckboxTapped(_:)), for: .touchUpInside)
            
            return cell
        } else if tableView == self.filtertableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AssignListCell", for: indexPath) as! AssignListCell
            cell.locationview.isHidden = true
            cell.AssignLbl.text = Days[indexPath.row]
            cell.AssignLbl.textAlignment = .left
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.filtertableview {
            let selectedDays = Days[indexPath.row]
            let currentDate = Date()
            var fromDate: Date?

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yy"

            if selectedDays == "Custom" {
                frombtn.setTitle("From Date", for: .normal)
                tobtn.setTitle("To Date", for: .normal)
                sendbtn.isHidden = false
            } else {
                switch selectedDays {
                case "7 Days":
                    fromDate = Calendar.current.date(byAdding: .day, value: -6, to: currentDate)
                case "15 Days":
                    fromDate = Calendar.current.date(byAdding: .day, value: -14, to: currentDate)
                case "1 Month":
                    fromDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
                case "3 Months":
                    fromDate = Calendar.current.date(byAdding: .month, value: -2, to: currentDate)
                case "6 Months":
                    fromDate = Calendar.current.date(byAdding: .month, value: -6, to: currentDate)
                default:
                    return
                }
                if let fromDate = fromDate {
                    frombtn.setTitle(dateFormatter.string(from: fromDate), for: .normal)
                }
                if let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: currentDate) {
                    tobtn.setTitle(dateFormatter.string(from: endOfDay), for: .normal)
                }

                sendbtn.isHidden = true
                getDetails()
            }
            filtertableview.isHidden = true
        }
    }


    
}

// MARK: - UITableViewDelegate
extension PunchHistoryOut: UITableViewDelegate {
    
     
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tableView {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
            headerView.backgroundColor = UIColor.darkGray

            let stackView = UIStackView(frame: headerView.bounds)
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .center

            let headers = ["Date", "In Time", "Out Time", "Location"]

            for title in headers {
                let label = UILabel()
                label.text = title
                label.textColor = UIColor.white
                label.textAlignment = .center
                label.font = UIFont.boldSystemFont(ofSize: 16)
                stackView.addArrangedSubview(label)
            }

            headerView.addSubview(stackView)
            return headerView
        }
        
        return nil
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView {
            return 50
        }
        return 0
    }

}


