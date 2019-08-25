//
//  ObjectDistanceViewController.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2019/08/25.
//  Copyright © 2019 鈴木公章. All rights reserved.
//

import UIKit
import ARKit

final class ObjectDistanceViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    enum CardType: String {
        //        case kingBlack = "king_black"
        //        case kingRed = "king_red"
        case kingBlack = "ninebot_1"
        case kingRed = "ninebot_2"
    }
    
    var pentagonBlueNode: SCNNode?
    var pentagonRedNode: SCNNode?
    var imageNodes = [SCNNode]()
    var isJunping = false
    
    private let configuration: ARWorldTrackingConfiguration = {
        let conf = ARWorldTrackingConfiguration()
        
        guard let object = ARReferenceObject.referenceObjects(inGroupNamed: "AR Objects", bundle: nil) else {
            fatalError()
        }
        conf.detectionObjects = object
        
        return conf
    }()
    
    private let imageConfiguration: ARImageTrackingConfiguration = {
        let conf = ARImageTrackingConfiguration()
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Ninebot", bundle: nil)
        conf.trackingImages = images!
        conf.maximumNumberOfTrackedImages = 2
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
        
        
        sceneView.session.run(configuration)
        //        sceneView.session.run(imageConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension ObjectDistanceViewController: ARSCNViewDelegate {
    //    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    //        guard let imageAnchor = anchor as? ARImageAnchor else {
    //            return
    //        }
    //        print(node.worldPosition)
    //        print(imageAnchor)
    //        node.addChildNode(actionButtonNode)
    //    }
    
    //    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    //        let node = SCNNode()
    //
    //        if let objectAnchor = anchor as? ARObjectAnchor {
    //            let size = objectAnchor.referenceObject.accessibilityFrame
    //            let plane = SCNPlane(width: size.width, height: size.height)
    //            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
    //            //            plane.firstMaterial?.diffuse.contents = UIImage(named: "test")!.alpha(0.5)
    //            plane.cornerRadius = 0.005
    //
    //            let planeNode = SCNNode(geometry: plane)
    //            planeNode.eulerAngles.x = -.pi / 2
    //            //            planeNode.position = SCNVector3(0, 0, 20)
    //            node.addChildNode(planeNode)
    //
    //            var shapeNode: SCNNode?
    //            //            switch imageAnchor.referenceImage.name {
    //            //            case CardType.kingBlack.rawValue:
    //            //                shapeNode = pentagonBlueNode
    //            //            case CardType.kingRed.rawValue:
    //            //                shapeNode = pentagonRedNode
    //            //            default:
    //            //                break
    //            //            }
    //
    //            print("---------------")
    //            print(objectAnchor.referenceObject.name)
    //            shapeNode = pentagonBlueNode
    //
    //            let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
    //            let repeatSpin = SCNAction.repeatForever(shapeSpin)
    //            shapeNode?.runAction(repeatSpin)
    //
    //            guard let shape = shapeNode else {
    //                return nil
    //            }
    //            node.addChildNode(shape)
    //            imageNodes.append(node)
    //
    //            return node
    //        }
    //
    //        if let imageAnchor = anchor as? ARImageAnchor {
    //            let size = imageAnchor.referenceImage.physicalSize
    //            let plane = SCNPlane(width: size.width, height: size.height)
    //            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
    ////            plane.firstMaterial?.diffuse.contents = UIImage(named: "test")!.alpha(0.5)
    //            plane.cornerRadius = 0.005
    //
    //            let planeNode = SCNNode(geometry: plane)
    //            planeNode.eulerAngles.x = -.pi / 2
    ////            planeNode.position = SCNVector3(0, 0, 20)
    //            node.addChildNode(planeNode)
    //
    //            var shapeNode: SCNNode?
    ////            switch imageAnchor.referenceImage.name {
    ////            case CardType.kingBlack.rawValue:
    ////                shapeNode = pentagonBlueNode
    ////            case CardType.kingRed.rawValue:
    ////                shapeNode = pentagonRedNode
    ////            default:
    ////                break
    ////            }
    //
    //            print("---------------")
    //            print(imageAnchor.referenceImage.name)
    //            shapeNode = pentagonBlueNode
    //
    //            let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
    //            let repeatSpin = SCNAction.repeatForever(shapeSpin)
    //            shapeNode?.runAction(repeatSpin)
    //
    //            guard let shape = shapeNode else {
    //                return nil
    //            }
    //            node.addChildNode(shape)
    ////            imageNodes.append(node)
    //
    //            return node
    //        }
    //
    //        return nil
    //    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //        let node = SCNNode()
        
        if let objectAnchor = anchor as? ARObjectAnchor {
            let size = objectAnchor.referenceObject.accessibilityFrame
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
            //            plane.firstMaterial?.diffuse.contents = UIImage(named: "test")!.alpha(0.5)
            plane.cornerRadius = 0.005
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            //            planeNode.position = SCNVector3(0, 0, 20)
            node.addChildNode(planeNode)
            
            var shapeNode: SCNNode?
            //            switch imageAnchor.referenceImage.name {
            //            case CardType.kingBlack.rawValue:
            //                shapeNode = pentagonBlueNode
            //            case CardType.kingRed.rawValue:
            //                shapeNode = pentagonRedNode
            //            default:
            //                break
            //            }
            
            print("---------------")
            print(node.worldPosition)
            print(objectAnchor.referenceObject.name)
            shapeNode = pentagonBlueNode
            
            let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
            let repeatSpin = SCNAction.repeatForever(shapeSpin)
            shapeNode?.runAction(repeatSpin)
            
            guard let shape = shapeNode else {
                return
            }
            node.addChildNode(shape)
            imageNodes.append(node)
            
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if imageNodes.count == 2 {
            let positionOne = SCNVector3ToGLKVector3(imageNodes[0].position)
            let positionTwo = SCNVector3ToGLKVector3(imageNodes[1].position)
            let distance = GLKVector3Distance(positionOne, positionTwo)
            print(distance)
            print(imageNodes[1].eulerAngles)
            
            //            if distance < 0.15 {
            //                spinJump(node: imageNodes[0])
            //                spinJump(node: imageNodes[1])
            //                isJunping = true
            //            } else {
            //                isJunping = false
            //            }
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
