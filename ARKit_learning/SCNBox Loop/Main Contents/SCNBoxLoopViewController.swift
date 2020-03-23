//
//  SCNBoxLoopViewController.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2020/01/16.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit
import ARKit

final class SCNBoxLoopViewController: UIViewController {
    
    @IBOutlet private weak var sceneView: ARSCNView!
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
        
        if let vc = parent?.parent?.children[1] as? DrawerMenuViewController {
            vc.delegate = self
        }
        
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
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

extension SCNBoxLoopViewController: ARSCNViewDelegate {
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
                
                for y in 0...7 {
                    for z in 0...8 {
                        for x in 0...24 {
                            let heatArray = commonSetting.initHeatMapArray(y: y, z: z)
                            let box = SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0)
                            box.firstMaterial?.diffuse.contents = commonSetting.getHeatColor(data: heatArray[x]).withAlphaComponent(0.5)
                            let boxNode = SCNNode(geometry: box)
                            boxNode.position = SCNVector3(boxNode.position.x - 0.122625 + (Float(x) * 0.01), boxNode.position.y + (Float(y) * 0.01), boxNode.position.z - 0.0435 + (Float(z) * 0.01))
                            boxNode.name = String(heatArray[x])
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

extension SCNBoxLoopViewController: DrawerMenuViewControllerDelegate {
    func okButtonTapped(_ drawerMenuViewController: DrawerMenuViewController, sliderValue: Double) {
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
