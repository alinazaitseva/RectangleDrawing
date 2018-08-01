// 
//  RandomColorPicker.swift
//  GesturesAndRectDrawing
//
//  Created by Alina Zaitseva on 8/1/18.
//  Copyright © 2018 Alina Zaitseva. All rights reserved.
//

import UIKit

class RandomColorPicker: CustomStringConvertible {
    
    class func getColor() -> UIColor {
        
        let red = CGFloat(arc4random_uniform(256))/255
        let green = CGFloat(arc4random_uniform(256))/255
        let blue = CGFloat(arc4random_uniform(256))/255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    var description: String {
        return "Random UIColor"
    }
}
