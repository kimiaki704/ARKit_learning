//
//  drawingViewController.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2019/04/18.
//  Copyright © 2019年 鈴木公章. All rights reserved.
//

import UIKit
import ARKit

final class drawingViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    private var drawingNode: SCNNode?
    
    private let configuration: ARWorldTrackingConfiguration = {
        let conf = ARWorldTrackingConfiguration()
        conf.planeDetection = .horizontal
        conf.environmentTexturing = .automatic
        return conf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let node: SCNNode
        
        if let drawingNode = self.drawingNode {
            node = drawingNode.clone()
        } else {
            let strokeNode = initBallStroke()
            self.drawingNode = strokeNode
            node = strokeNode
        }
        
        guard let location = touches.first?.location(in: sceneView) else {
            return
        }
        let screenPosition: SCNVector3 = SCNVector3(location.x, location.y, 0.996)
        let worldPosition = sceneView.unprojectPoint(screenPosition)
        
        node.position = worldPosition
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    private func initBallStroke() -> SCNNode {
        let ball = SCNSphere(radius: 0.005)
        let node = SCNNode(geometry: ball)
        
        return node
    }
}

extension drawingViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            print("heimen")
        }
    }
}
