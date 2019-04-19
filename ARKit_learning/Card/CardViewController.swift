//
//  CardViewController.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2019/04/18.
//  Copyright © 2019年 鈴木公章. All rights reserved.
//

import UIKit
import ARKit

final class CardViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    private let configuration: ARWorldTrackingConfiguration = {
        let conf = ARWorldTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        conf.detectionImages = images
        conf.planeDetection = .horizontal
        conf.environmentTexturing = .automatic
        return conf
    }()
    
    private let imageConfiguration: ARImageTrackingConfiguration = {
        let conf = ARImageTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        conf.trackingImages = images!
        return conf
    }()
    
    private var actionButtonNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        actionButtonNode = SCNScene(named: "art.scnassets/action_button.scn")!.rootNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(imageConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension CardViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        
        node.addChildNode(actionButtonNode)
    }
}
