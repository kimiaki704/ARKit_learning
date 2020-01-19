//
//  UIView+Animation.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2020/01/19.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit

extension UIView {
    func transitionPosition(_ position: CGPoint, duration: Double, completed: (() -> ())? = nil) {
        UIView.animate(withDuration: duration,
                       animations: {
                        self.frame = CGRect(x: position.x, y: position.y, width: self.bounds.width, height: self.bounds.height)
                        self.layoutIfNeeded()
        }) { finished in
            completed?()
        }
    }
}
