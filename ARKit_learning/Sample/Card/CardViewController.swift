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
    
    enum CardType: String {
        case kingBlack = "king_black"
        case kingRed = "king_red"
    }
    
    var pentagonBlueNode: SCNNode?
    var pentagonRedNode: SCNNode?
    var imageNodes = [SCNNode]()
    var isJunping = false
    
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
        
        let pentagonBlueScene = SCNScene(named: "art.scnassets/pentagonal_blue.scn")
        let pentagonRedScene = SCNScene(named: "art.scnassets/pentagonal_red.scn")
        
        pentagonBlueNode = pentagonBlueScene?.rootNode
        pentagonRedNode = pentagonRedScene?.rootNode
        
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

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        if let imageAnchor = anchor as? ARImageAnchor {
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            plane.cornerRadius = 0.005

            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)

            var shapeNode: SCNNode?
            switch imageAnchor.referenceImage.name {
            case CardType.kingBlack.rawValue:
                shapeNode = pentagonBlueNode
            case CardType.kingRed.rawValue:
                shapeNode = pentagonRedNode
            default:
                break
            }

            let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
            let repeatSpin = SCNAction.repeatForever(shapeSpin)
            shapeNode?.runAction(repeatSpin)

            guard let shape = shapeNode else {
                return nil
            }
            node.addChildNode(shape)
            imageNodes.append(node)

            return node
        }

        return nil
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if imageNodes.count == 2 {
            let positionOne = SCNVector3ToGLKVector3(imageNodes[0].position)
            let positionTwo = SCNVector3ToGLKVector3(imageNodes[1].position)
            let distance = GLKVector3Distance(positionOne, positionTwo)
            
            if distance < 0.15 {
                spinJump(node: imageNodes[0])
                spinJump(node: imageNodes[1])
                isJunping = true
            } else {
                isJunping = false
            }
        }
    }
    
    func spinJump(node: SCNNode) {
        if isJunping { return }
        
        let shapeNode = node.childNodes[1]
        let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 1)
        shapeSpin.timingMode = .easeInEaseOut
        
        let up = SCNAction.moveBy(x: 0, y: 0.03, z: 0, duration: 0.5)
        up.timingMode = .easeInEaseOut
        
        let down = up.reversed()
        let upDown = SCNAction.sequence([down, up])
        
        shapeNode.runAction(shapeSpin)
        shapeNode.runAction(upDown)
    }
}
