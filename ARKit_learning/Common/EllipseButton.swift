//
//  EllipseButton.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2020/01/22.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit

@IBDesignable
final class EllipseButton: UIButton {
    @IBInspectable var buttonColor: UIColor = .black {
        didSet {
            backgroundColor = buttonColor
        }
    }
    @IBInspectable var textColor: UIColor = .white {
        didSet {
            tintColor = textColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
