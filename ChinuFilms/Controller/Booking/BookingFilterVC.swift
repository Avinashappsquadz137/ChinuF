//
//  BookingFilterVC.swift
//  SanskarEP
//
//  Created by Warln on 09/05/22.
//

import UIKit

class BookingFilterVC: UIViewController {
    
    private let channelTxt: UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "Channel"
        return text
    }()
    
    private let nameTxt: UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "Name"
        return text
    }()
    
    private let statusTxt: UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "Status"
        return text
    }()
    
    private let fromDate: UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "From Date"
        return text
    }()
    
    private let toDate: UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = "To Date"
        return text
    }()
    
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5                                       
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    

}
