//
//  ViewController.swift
//  SanskarEP
//
//  Created by Surya on 14/02/25.
//

import UIKit

extension UIViewController {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150,
                                               y: self.view.frame.size.height - 100,
                                               width: 300, height: 40))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}

