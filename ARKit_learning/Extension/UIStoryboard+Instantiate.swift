//
//  UIStoryboard+Instantiate.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2020/01/19.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instantiate(name: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: name, bundle: nil)
        guard let viewController = storyBoard.instantiateInitialViewController() else {
            fatalError()
        }
        
        return viewController
    }
}
