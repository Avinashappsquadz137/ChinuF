//
//  filterVC.swift
//  SanskarEP
//
//  Created by Warln on 09/05/22.
//

import UIKit

protocol FilterVCDelegate {
    func didGetDate(with start: String, with end: String)
}

class FilterVC: UIViewController {
    private let startD: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Start Date"
        txt.borderStyle = .roundedRect
        txt.clipsToBounds = true
        return txt
    }()
    
    private let endD: UITextField = {
        let txt = UITextField()
        txt.placeholder = "End Date"
        txt.borderStyle = .roundedRect
        txt.clipsToBounds = true
        return txt
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let SubmitBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var delegate: FilterVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(SubmitBtn)
        view.addSubview(stack)
        SubmitBtn.addTarget(self, action: #selector(didBtnTap), for: .touchUpInside)
        datepicker()
        datepicker2()
        setConstraint()
    }
    
    @objc
    private func didBtnTap () {
        guard let start = startD.text , let end = endD.text else { return }
        if start.isEmpty == true && end.isEmpty == true {
            AlertController.alert(message: "Please add proper date")
        }else{
            delegate?.didGetDate(with: start, with: end)
            self.dismiss(animated: true)
        }
    }
    
    private func setConstraint() {
        stack.addArrangedSubview(startD)
        stack.addArrangedSubview(endD)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stack.heightAnchor.constraint(equalToConstant: 60),
            SubmitBtn.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
            SubmitBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            SubmitBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            SubmitBtn.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    func datepicker () {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {

        }
        datePicker.addTarget(self, action: #selector(datePickerValue(_:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 250)
        startD.inputView = datePicker
    }
    
    @objc
    func datePickerValue(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        startD.text = dateFormatter.string(from: sender.date)
    }
    
    func datepicker2 () {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {

        }
        datePicker.addTarget(self, action: #selector(datePickerValue2(_:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 250)
        endD.inputView = datePicker
    }
    
    @objc
    func datePickerValue2(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        endD.text = dateFormatter.string(from: sender.date)
    }
    

}
