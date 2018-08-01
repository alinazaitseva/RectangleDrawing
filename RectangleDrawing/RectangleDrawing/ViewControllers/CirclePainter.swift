// 
//  CirclePainter.swift
//  GesturesAndRectDrawing
//
//  Created by Alina Zaitseva on 8/1/18.
//  Copyright © 2018 Alina Zaitseva. All rights reserved.
//

import UIKit

class CirclePainter: CustomStringConvertible {
    
    class func drawCircle(center: CGPoint , radius: CGFloat,start: CGFloat, end : CGFloat) -> CAShapeLayer {
        let pathToCircle = UIBezierPath(arcCenter: center,
                                        radius: radius,
                                        startAngle: start,
                                        endAngle: end,
                                        clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = pathToCircle.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = 2.0
        
        return (shapeLayer)
    }
    
    var description: String {
        return "color: yellow"
    }
}
