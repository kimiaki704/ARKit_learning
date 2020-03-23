//
//  ObjectDistance2ViewController.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2019/09/03.
//  Copyright © 2019 鈴木公章. All rights reserved.
//

import UIKit
import ARKit

final class ObjectDistance2ViewController: UIViewController {
    
    @IBOutlet private weak var sceneView: ARSCNView!
    
    private var pentagonBlueNode: SCNNode?
    private var pentagonRedNode: SCNNode?
    private var pentagonYellowNode: SCNNode?
    private var pentagonGreenNode: SCNNode?
    private var pentagonPurpleNode: SCNNode?
    private var pentagonBlackNode: SCNNode?
    private var nodesArray = [SCNNode]()
    private var coilPosition = SCNVector3()
    private var referenceImageName = String()
    private var isJunping = false
    
    private enum DistanceStatus {
        case zero
        case one
        case two
        case three
        case four
        case five
    }
    private var distanceStatus: DistanceStatus = .zero
    
    //    private let imageConfiguration: ARImageTrackingConfiguration = {
    //        let conf = ARImageTrackingConfiguration()
    //
    //        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Tranp", bundle: nil)
    //        conf.trackingImages = images!
    //        conf.maximumNumberOfTrackedImages = 1
    //        return conf
    //    }()
    private let configuration: ARWorldTrackingConfiguration = {
        let conf = ARWorldTrackingConfiguration()
//        conf.environmentTexturing = .automatic
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Car", bundle: nil)
        conf.detectionImages = images!
        conf.maximumNumberOfTrackedImages = 1
        
        return conf
    }()
    
    override var prefersStatusBarHidden: Bool { return true }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        sceneView.delegate = self
        
        let pentagonBlueScene = SCNScene(named: "art.scnassets/pentagonal_blue.scn")
        let pentagonRedScene = SCNScene(named: "art.scnassets/pentagonal_red.scn")
        let pentagonYellowScene = SCNScene(named: "art.scnassets/pentagonal_yellow.scn")
        let pentagonGreenScene = SCNScene(named: "art.scnassets/pentagonal_green.scn")
        let pentagonPurpleScene = SCNScene(named: "art.scnassets/pentagonal_purple.scn")
        let pentagonBlackScene = SCNScene(named: "art.scnassets/pentagonal_black.scn")
        
        pentagonBlueNode = pentagonBlueScene?.rootNode.childNodes.first!
        pentagonRedNode = pentagonRedScene?.rootNode.childNodes.first!
        pentagonYellowNode = pentagonYellowScene?.rootNode.childNodes.first!
        pentagonGreenNode = pentagonGreenScene?.rootNode.childNodes.first!
        pentagonPurpleNode = pentagonPurpleScene?.rootNode.childNodes.first!
        pentagonBlackNode = pentagonBlackScene?.rootNode.childNodes.first!
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

extension ObjectDistance2ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            print("---------------")
            print(imageAnchor.referenceImage.name)
            
            
            referenceImageName = imageAnchor.referenceImage.name!
            
            if (imageAnchor.referenceImage.name?.contains("rail"))! && nodesArray.isEmpty {
                let size = imageAnchor.referenceImage.physicalSize
                /// width:1 = 1m
                /// imageAnchorに対して正面をみたとき
                /// width: 横幅
                /// height: 奥行き
                /// length: 縦幅
                let box = SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0)
                box.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
                
                let plane = SCNPlane(width: size.width, height: size.height)
                plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
                plane.cornerRadius = 0.005
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                
                node.name = "rail"
                coilPosition = SCNVector3(imageAnchor.transform.columns.3.x,
                                          imageAnchor.transform.columns.3.y,
                                          imageAnchor.transform.columns.3.z)
//                node.addChildNode(planeNode)
                
                /// width:0.24525
                /// height: 0.087
                /// imageAnchorに対して正面をみたとき
                /// x: 横 - 右側に正
                /// y: 奥行き - 手前側に正
                /// z: 縦 - 下側に正
                for i in 0...24 {
                    for j in 0...8 {
                        for k in 0...5 {
                            let boxNode = SCNNode(geometry: box)
                            boxNode.position = SCNVector3(boxNode.position.x - 0.122625 + (Float(i) * 0.01), boxNode.position.y + (Float(k) * 0.01), boxNode.position.z - 0.0435 + (Float(j) * 0.01))
                            node.addChildNode(boxNode)
                        }
                    }
                }
//                boxNode.position = SCNVector3(coilPosition.x - 0.05, boxNode.position.y, boxNode.position.z)
//                node.addChildNode(boxNode)
                
                nodesArray.append(node)
            }
            
            if (imageAnchor.referenceImage.name?.contains("car"))! && nodesArray.count >= 1 {
//                let size = imageAnchor.referenceImage.physicalSize
//                let plane = SCNPlane(width: size.width, height: size.height)
//                plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
//                plane.cornerRadius = 0.005
//                let planeNode = SCNNode(geometry: plane)
//                planeNode.eulerAngles.x = -.pi / 2
//                node.name = "car"
//                node.addChildNode(planeNode)
                var shapeNode: SCNNode?
                shapeNode = pentagonRedNode

                let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
                let repeatSpin = SCNAction.repeatForever(shapeSpin)
                shapeNode?.runAction(repeatSpin)

                guard let shape = shapeNode else {
                    return
                }
                node.name = imageAnchor.referenceImage.name!
                node.addChildNode(shape)
                
                if !nodesArray.isEmpty {
                    if nodesArray.count == 2 {
                        nodesArray[1] = node
                    } else {
                        nodesArray.append(node)
                    }
                } else {
                    resetSceneView()
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {

            if (imageAnchor.referenceImage.name?.contains("car"))! && nodesArray.count >= 1 {
                if referenceImageName != imageAnchor.referenceImage.name {
                    referenceImageName = imageAnchor.referenceImage.name!
                    if nodesArray.count == 2 {
                        nodesArray.removeLast()
                    }
                    
                    node.name = imageAnchor.referenceImage.name!
                    node.enumerateChildNodes { (child, _) in
                        if child.name?.contains("pentagonal") ?? false {
                            child.removeFromParentNode()
                        }
                    }

                    if !nodesArray.isEmpty {
                        if nodesArray.count == 2 {
                            nodesArray[1] = node
                        } else {
                            nodesArray.append(node)
                        }
                    } else {
                        resetSceneView()
                    }
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if nodesArray.count == 2 {
            let positionOne = SCNVector3ToGLKVector3(coilPosition)
            let positionTwo = SCNVector3ToGLKVector3(nodesArray[1].position)
            var distance = GLKVector3Distance(positionOne, positionTwo)
            
            if nodesArray[1].position.x - coilPosition.x < 0 {
                distance *= -1.0
            }
            
            print("----------------------------------")
            //            print(nodesArray[0].position)
            //            print(nodesArray[1].position)
            print(distance)
//            print(nodesArray[1].childNodes)
            print("----------------------------------")
            
            changeNode(distance: distance)
        }
    }
    
    private func spinJump(node: SCNNode) {
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
    
    private func resetSceneView() {
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        nodesArray = []
        distanceStatus = .zero
        
        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
    
    private func changeNode(distance: Float) {
        if distance < 0.075 && distance > 0.045 && distanceStatus != .five {
            setNode(status: .five)
        } else if distance < 0.045 && distance > 0.02 && distanceStatus != .four {
            setNode(status: .four)
        } else if distance < 0.02 && distance > -0.02 && distanceStatus != .three {
            setNode(status: .three)
        } else if distance < -0.02 && distance > -0.045 && distanceStatus != .two {
            setNode(status: .two)
        } else if distance < -0.045 && distance > -0.075 && distanceStatus != .one {
            setNode(status: .one)
        } else if (distance > 0.075 || distance < -0.075) && distanceStatus != .zero {
            setNode(status: .zero)
        }
    }
    
    private func setNode(status: DistanceStatus) {
        nodesArray[1].enumerateChildNodes { (child, _) in
            if child.name?.contains("pentagonal") ?? false {
                child.removeFromParentNode()
            }
        }
        
        var shapeNode: SCNNode?
        
        let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
        let repeatSpin = SCNAction.repeatForever(shapeSpin)
        shapeNode?.runAction(repeatSpin)
        
        switch status {
        case .zero:
            shapeNode = pentagonRedNode
            guard let shape = shapeNode else {
                return
            }
            nodesArray[1].addChildNode(shape)
            distanceStatus = .zero
            
        case .one:
            shapeNode = pentagonGreenNode
            guard let shape = shapeNode else {
                return
            }
            nodesArray[1].addChildNode(shape)
            distanceStatus = .one
            
        case .two:
            shapeNode = pentagonBlueNode
            guard let shape = shapeNode else {
                return
            }
            nodesArray[1].addChildNode(shape)
            distanceStatus = .two
            
        case .three:
            shapeNode = pentagonPurpleNode
            guard let shape = shapeNode else {
                return
            }
            nodesArray[1].addChildNode(shape)
            distanceStatus = .three
            
        case .four:
            shapeNode = pentagonYellowNode
            guard let shape = shapeNode else {
                return
            }
            nodesArray[1].addChildNode(shape)
            distanceStatus = .four
            
        case .five:
            shapeNode = pentagonBlackNode
            guard let shape = shapeNode else {
                return
            }
            nodesArray[1].addChildNode(shape)
            distanceStatus = .five
            
        }
    }
}
