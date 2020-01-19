//
//  DrawerParentViewController.swift
//  SwiftTraining
//
//  Created by 鈴木 公章 on 2020/01/10.
//  Copyright © 2020 CAM, inc. All rights reserved.
//

import UIKit

final class DrawerParentViewController: UIViewController {
    /// メイン表示するコンテンツ
    private var mainViewController: UIViewController!
    /// サイドメニューのコンテンツ
    private var menuViewController: UIViewController!
    /// オーバーレイビューのインスタンス
    private var overlayView: UIView!
    /// オーバーレイビューの色
    private var overlayColor: UIColor!
    /// サイドメニューの横幅
    private var menuViewWidth: CGFloat
    /// サイドメニューが開いているかどうか
    private var isMenuOpen: Bool = false
    
    /// 初期化処理
    /// - Parameters:
    ///   - mainViewController: メインで表示するコンテンツ
    ///   - menuViewController: サイドメニューのコンテンツ
    ///   - drawerOption: ドロワーのオプション
    init(mainViewController: UIViewController, menuViewController: UIViewController, drawerOption: DrawerOption) {
        self.mainViewController = mainViewController
        self.menuViewController = menuViewController
        self.overlayColor = drawerOption.overlayColor
        self.menuViewWidth = drawerOption.menuViewWidth
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MainViewController → MenuViewController → OverlayView → Recognizer の順に
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainViewController()
        setUpMenuViewController()
        setUpOverlay()
        setUpRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        menuViewController.view.isHidden = true
        hiddenDrawerMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        menuViewController.view.isHidden = false
    }
}


// MARK: MainContent、DrawerMenu、OverLayView の生成
extension DrawerParentViewController {
    private func setUpMainViewController() {
        addChild(mainViewController)
        view.addSubview(mainViewController.view)
        mainViewController.didMove(toParent: self)
    }
    
    private func setUpMenuViewController() {
        menuViewController.view.frame = CGRect(x: 0, y: 0, width: menuViewWidth, height: view.bounds.height)
        addChild(menuViewController)
        view.addSubview(menuViewController.view!)
        menuViewController.didMove(toParent: self)
    }
    
    private func setUpOverlay() {
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = overlayColor
        overlayView.alpha = 0
        overlayView.isUserInteractionEnabled = false
        mainViewController.view.addSubview(overlayView)
    }
}

// MARK: GestureRecognizer の生成
extension DrawerParentViewController {
    private func setUpRecognizer() {
        let edgeLeftPanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipedLeft))
        edgeLeftPanGesture.edges = [.left]
        view.addGestureRecognizer(edgeLeftPanGesture)
        
        let leftPanGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        leftPanGesture.direction = .right
        view.addGestureRecognizer(leftPanGesture)
        
        let rightPanGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        rightPanGesture.direction = .left
        overlayView.addGestureRecognizer(rightPanGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapppedOverlay))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func swipedLeft() {
        if !isMenuOpen { showDrawerMenu() }
    }
    
    @objc private func swipedRight() {
        if isMenuOpen { hiddenDrawerMenu() }
    }
    
    @objc private func tapppedOverlay() {
        if isMenuOpen { hiddenDrawerMenu() }
    }
}

// MARK: Drawerメニューの開閉関数
extension DrawerParentViewController {
    func showDrawerMenu() {
        overlayView.isUserInteractionEnabled = true
        overlayView.alpha = 0.3
        self.menuViewController.view.transitionPosition(CGPoint(x: 0, y: 0), duration: 0.3)
        self.isMenuOpen = true
    }
    
    func hiddenDrawerMenu() {
        overlayView.isUserInteractionEnabled = false
        overlayView.alpha = 0
        self.menuViewController.view.transitionPosition(CGPoint(x: -view.bounds.width, y: 0), duration: 0.3)
        self.isMenuOpen = false
    }
}
