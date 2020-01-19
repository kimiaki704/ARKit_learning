//
//  DrawerAppViewController.swift
//  SwiftTraining
//
//  Created by 鈴木 公章 on 2020/01/10.
//  Copyright © 2020 CAM, inc. All rights reserved.
//

import UIKit

final class DrawerAppViewController: UIViewController {
    private var mainViewController: DrawerNavigationController!
    private var menuViewController: UIViewController!
    private var drawerViewController: DrawerParentViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainViewController = DrawerNavigationController(rootViewController: UIStoryboard.instantiate(name: "SCNBox"), leftBarIcon: UIImage(named: "navbar_icon")!)
        menuViewController = UIStoryboard.instantiate(name: "DrawerMenu")
        drawerViewController = DrawerParentViewController(mainViewController: mainViewController,
                                                          menuViewController: menuViewController,
                                                          drawerOption: DrawerOption(menuViewWidth: view.bounds.width * 0.7))
        mainViewController.drawerDelegate = self
        
        addChild(drawerViewController)
        view.addSubview(drawerViewController.view)
        drawerViewController.didMove(toParent: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: DrawerNavigationController ナビゲーションアイテムの通知
extension DrawerAppViewController: DrawerNavigationControllerDelegate {
    func tappedLeftBarButton(_ drawerNavigationController: DrawerNavigationController) {
        drawerViewController.showDrawerMenu()
    }
}
