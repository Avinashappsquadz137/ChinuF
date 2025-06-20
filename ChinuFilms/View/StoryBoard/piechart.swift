//
//  piechart.swift
//  SanskarEP
//
//  Created by Surya on 28/09/24.
//


import Foundation
import UIKit

class PieChartView: UIView {
    

    var data: [CGFloat] = [30, 40, 50, 50]
    var colors: [UIColor] = [.red, .blue, .green, .yellow]
    
    override func draw(_ rect: CGRect) {
    
        let total = data.reduce(0, +)
        
      
        let centerPoint = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2
        

        var startAngle: CGFloat = -.pi / 2
        
     
        for (index, value) in data.enumerated() {
  
            let endAngle = startAngle + 2 * .pi * (value / total)
            
    
            let path = UIBezierPath()
            path.move(to: centerPoint)
            path.addArc(withCenter: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
      
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = colors[index].cgColor
            
     
            self.layer.addSublayer(shapeLayer)
            startAngle = endAngle
        }
    }
}
