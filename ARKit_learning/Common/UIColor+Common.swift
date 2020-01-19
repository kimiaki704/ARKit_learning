//
//  UIColor+Common.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2020/01/18.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func initWithDecimal(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return initWithDecimal(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func initWithDecimal(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
    static func initWithHex(color24: NSInteger) -> UIColor {
        let r: Int = (color24 >> 16)
        let g: Int = (color24 >> 8 & 0xFF)
        let b: Int = (color24 & 0xFF)
        return initWithDecimal(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
    }
    
    static func initWithHex(color24: Int, alpha: CGFloat) -> UIColor {
        let r: Int = (color24 >> 16)
        let g: Int = (color24 >> 8 & 0xFF)
        let b: Int = (color24 & 0xFF)
        return initWithDecimal(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(alpha))
    }
}
