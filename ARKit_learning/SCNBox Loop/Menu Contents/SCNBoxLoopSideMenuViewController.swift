//
//  SCNBoxLoopSideMenuViewController.swift
//  ARKit_learning
//
//  Created by 鈴木 公章 on 2020/03/23.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit

protocol SCNBoxLoopSideMenuViewControllerDelegate: class {
    func okButtonTapped(_ drawerMenuViewController: SCNBoxLoopSideMenuViewController, sliderValue: Double)
}

final class SCNBoxLoopSideMenuViewController: UIViewController {
    weak var delegate: SCNBoxLoopSideMenuViewControllerDelegate?

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
