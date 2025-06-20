//
//  RoundUIView.swift
//  SanskarEP
//
//  Created by Warln on 12/01/22.
//

import UIKit

@IBDesignable

class RoundUIView: UIView {
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
}


@IBDesignable
class RoundUIButton: UIButton {
    // MARK: - Properties
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowOffsetWidth: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowOffsetHeight: CGFloat = 1.8 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.30 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 3.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var shadowLayer: CAShapeLayer = CAShapeLayer() {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        shadowLayer.path = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = backgroundColor?.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: shadowOffsetWidth,
                                          height: shadowOffsetHeight)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        layer.insertSublayer(shadowLayer, at: 0)
    }
}

