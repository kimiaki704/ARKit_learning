//
//  BLEARKitViewController.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2020/01/22.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit
import ARKit

final class BLEARKitViewController: UIViewController {
    
    @IBOutlet private weak var sceneView: ARSCNView!
    private var sensorData: [[[Double]]] = []
    private var boxNodes: [SCNNode] = []
    
    private let configuration: ARWorldTrackingConfiguration = {
        let conf = ARWorldTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Car", bundle: nil)
        conf.detectionImages = images!
        conf.maximumNumberOfTrackedImages = 1
        
        return conf
    }()
    
    override var prefersStatusBarHidden: Bool { return true }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vc = parent?.parent?.children[1] as? BLEARKitMenuViewController {
            vc.delegate = self
        }
        
        sceneView.showsStatistics = true
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetSceneView()
    }
}

extension BLEARKitViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            if (imageAnchor.referenceImage.name?.contains("rail"))! {
                /// width:1 = 1m
                /// imageAnchorに対して正面をみたとき
                /// width: 横幅
                /// height: 奥行き
                /// length: 縦幅
                
                node.name = "rail"
                
                /// width:0.24525
                /// height: 0.087
                /// imageAnchorに対して正面をみたとき
                /// x: 横 - 右側に正
                /// y: 奥行き - 手前側に正
                /// z: 縦 - 下側に正
                let commonSetting = Common()
                
                if sensorData.isEmpty { return }
                for (yIndex, yData) in sensorData.enumerated() {
                    for (zIndex, zData) in yData.enumerated() {
                        for (xIndex, xData) in zData.enumerated() {
                            let box = SCNBox(width: BLEARKitSettings.scnBoxSizeX,
                                             height: BLEARKitSettings.scnBoxSizeY,
                                             length: BLEARKitSettings.scnBoxSizeZ,
                                             chamferRadius: 0)
                            box.firstMaterial?.diffuse.contents = commonSetting.getHeatColor(data: xData).withAlphaComponent(0.5)
                            let boxNode = SCNNode(geometry: box)
                            boxNode.position = SCNVector3(boxNode.position.x - 0.122625 + (Float(xIndex) * 0.01),
                                                          boxNode.position.y + (Float(yIndex) * 0.01),
                                                          boxNode.position.z - 0.0435 + (Float(zIndex) * 0.01))
                            boxNode.name = String(xData)
                            boxNodes.append(boxNode)
                            node.addChildNode(boxNode)
                        }
                    }
                }
            }
        }
    }
    
    private func resetSceneView() {
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }

        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
}

extension BLEARKitViewController: BLEARKitMenuViewControllerDelegate {
    func completedBLE(_ data: [[[Double]]]) {
        sensorData = data
    }
    
    func okButtonTapped(_ BLEARKitMenuViewController: BLEARKitMenuViewController, sliderValue: Double) {
        if boxNodes.isEmpty { return }
        
        for boxNode in boxNodes {
            guard let value = Double(boxNode.name!) else { return }
            
            if sliderValue >= value {
                boxNode.isHidden = true
            } else {
                boxNode.isHidden = false
            }
        }
    }
}
