//
//  setShipViewController.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2019/04/18.
//  Copyright © 2019年 鈴木公章. All rights reserved.
//

import UIKit
import ARKit

final class setShipViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let ship = SCNScene(named: "art.scnassets/ship.scn")!
        let shipNode = ship.rootNode.childNodes.first!
        shipNode.scale = SCNVector3(0.1, 0.1, 0.1)
        
//        guard let location = touches.first?.location(in: sceneView) else {
//            return
//        }
//        let screenPosition: SCNVector3 = SCNVector3(location.x, location.y, 0.996)
//        let worldPosition = sceneView.unprojectPoint(screenPosition)
        
        let infrontCamera = SCNVector3Make(0, 0, -0.3)
        
        guard let cameraNode = sceneView.pointOfView else {
            return
        }
        let pointInWorld = cameraNode.convertPosition(infrontCamera, to: nil)
        var screenPosition = sceneView.projectPoint(pointInWorld)
        
        guard let location = touches.first?.location(in: sceneView) else {
            return
        }
        
        screenPosition.x = Float(location.x)
        screenPosition.y = Float(location.y)
        
        let worldPosition = sceneView.unprojectPoint(screenPosition)
        
        shipNode.eulerAngles = cameraNode.eulerAngles
        
        shipNode.position = worldPosition
        sceneView.scene.rootNode.addChildNode(shipNode)
    }
}

extension setShipViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            print("heimen")
        }
    }
}
