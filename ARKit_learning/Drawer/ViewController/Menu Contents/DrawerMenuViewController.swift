//
//  DrawerMenuViewController.swift
//  SwiftTraining
//
//  Created by 鈴木 公章 on 2020/01/10.
//  Copyright © 2020 CAM, inc. All rights reserved.
//

import UIKit

final class DrawerMenuViewController: UIViewController {
    @IBOutlet weak private var backToHomeButton: UIButton!
    @IBAction private func backToHomeButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
