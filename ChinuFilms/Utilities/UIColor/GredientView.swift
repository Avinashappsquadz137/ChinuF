//
//  GredientView.swift
//  SanskarEP
//
//  Created by Warln on 11/01/22.
//

import Foundation
import UIKit

@IBDesignable
class GredientView: UIView {
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet{
            updateView()
        }
        
    }
    
    @IBInspectable var thirdColor: UIColor = UIColor.clear {
        didSet{
            updateView()
        }
        
    }
    
    @IBInspectable var isHorizontal: Bool = true {
        didSet{
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    func updateView() {
        
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor,secondColor,thirdColor].map{$0.cgColor}
        if isHorizontal {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint(x: 1, y: 0.5)
        }else{
            layer.startPoint = CGPoint(x: 0.3, y: 0)
            layer.endPoint = CGPoint(x: 0.5, y: 0.8)
            
        }
        
        
    }
    
}
