//
//  DrawerMenuViewController.swift
//  SwiftTraining
//
//  Created by 鈴木 公章 on 2020/01/10.
//  Copyright © 2020 CAM, inc. All rights reserved.
//

import UIKit

protocol DrawerMenuViewControllerDelegate: class {
    func okButtonTapped(_ drawerMenuViewController: DrawerMenuViewController, sliderValue: Double)
}

final class DrawerMenuViewController: UIViewController {
    weak var delegate: DrawerMenuViewControllerDelegate?
    
    @IBOutlet private weak var sliderValueLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBAction private func okButtonTapped(_ sender: UIButton) {
        guard let sliderValue: Double = Double(self.sliderValueLabel.text!) else { return }
        delegate?.okButtonTapped(self, sliderValue: sliderValue)
    }
    @IBAction func sliderChanged(_ sender: UISlider) {
        sliderValueLabel.text = String(sender.value * 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderValueLabel.text = String(slider.value * 10)
    }
}
