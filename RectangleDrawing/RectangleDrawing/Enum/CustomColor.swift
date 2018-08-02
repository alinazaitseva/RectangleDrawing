// 
//  CustomColor.swift
//  RectangleDrawing
//
//  Created by Alina Zaitseva on 8/1/18.
//  Copyright © 2018 Alina Zaitseva. All rights reserved.
//

import Foundation
import UIKit

enum CustomColor {
    case cyanCustom
    case yellowCustom
    
    var color: UIColor {
        switch self {
        case .cyanCustom:
            return UIColor(red: 59.0 / 255.0, green: 194.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
        case .yellowCustom:
            return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        }
        
    }
}
