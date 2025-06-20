//
//  Loader.swift
//  SanskarEP
//
//  Created by Warln on 10/01/22.
//

import UIKit

class Loader: NSObject {
    
    
    class  func showLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 80
        config.backgroundColor = UIColor.clear
        config.spinnerColor = .systemRed
        
        config.titleTextColor = UIColor(red:0.88, green:0.26, blue:0.18, alpha:1)
        config.spinnerLineWidth = 2.50
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.2
        
        SwiftLoader.setConfig(config: config)
        
        SwiftLoader.show(animated: true)
        
        //        delay(seconds: 3.0) { () -> () in
        //            SwiftLoader.show(title: "Loading...", animated: true)
        //        }
        //        delay(seconds: 6.0) { () -> () in
        //            SwiftLoader.hide()
        //        }
        
    }
    class  func hideLoader() {
        SwiftLoader.hide()
    }
}

