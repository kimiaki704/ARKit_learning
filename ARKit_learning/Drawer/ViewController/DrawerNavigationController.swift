//
//  DrawerNavigationController.swift
//  SwiftTraining
//
//  Created by 鈴木 公章 on 2020/01/14.
//  Copyright © 2020 CAM, inc. All rights reserved.
//

import UIKit

protocol DrawerNavigationControllerDelegate: class {
    func tappedLeftBarButton(_ drawerNavigationController: DrawerNavigationController)
}

final class DrawerNavigationController: UINavigationController {
    
    weak var drawerDelegate: DrawerNavigationControllerDelegate?
    
    init(rootViewController: UIViewController, leftBarIcon: UIImage) {
        super.init(rootViewController: rootViewController)
        
        topViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarIcon, style: .plain, target: self, action: #selector(tappedLeftBarButton))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tappedLeftBarButton() {
        drawerDelegate?.tappedLeftBarButton(self)
    }
}
