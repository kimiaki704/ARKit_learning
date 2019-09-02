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
    
    @IBOutlet private weak var sceneView: ARSCNView!
    
    private var pentagonBlueNode: SCNNode?
    private var pentagonRedNode: SCNNode?
    private var pentagonYellowNode: SCNNode?
    private var pentagonGreenNode: SCNNode?
    private var pentagonPurpleNode: SCNNode?
    private var pentagonBlackNode: SCNNode?
    private var nodesArray = [SCNNode]()
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
        conf.environmentTexturing = .automatic
        
        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Tranp", bundle: nil)
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

extension ObjectDistanceViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let imageAnchor = anchor as? ARImageAnchor {
//            let size = imageAnchor.referenceImage.physicalSize
//            let plane = SCNPlane(width: size.width, height: size.height)
//            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
//            plane.firstMaterial?.diffuse.contents = UIImage(named: "test")!.alpha(0.5)
//            plane.cornerRadius = 0.005
//
//            let planeNode = SCNNode(geometry: plane)
//            planeNode.eulerAngles.x = -.pi / 2
//            planeNode.position = SCNVector3(0, 0, 20)
//            node.addChildNode(planeNode)
            
            print("---------------")
            print(imageAnchor.referenceImage.name)
            print("Anchor ID = \(imageAnchor.identifier)")
            print(imageAnchor.transform.columns)
            
//            let nodeHolder = SCNNode()
//            let nodeGeometry = SCNBox(width: 0.02, height: 0.02, length: 0.02, chamferRadius: 0)
//            nodeGeometry.firstMaterial?.diffuse.contents = UIColor.cyan
//            nodeHolder.geometry = nodeGeometry
//            let pos = SCNVector3(imageAnchor.transform.columns.3.x,
//                                imageAnchor.transform.columns.3.y,
//                                imageAnchor.transform.columns.3.z)
//            nodeHolder.position = pos
//            sceneView?.scene.rootNode.addChildNode(nodeHolder)
//
//            let nodeHolder2 = SCNNode()
//            let nodeGeometry2 = SCNBox(width: 0.02, height: 0.02, length: 0.02, chamferRadius: 0)
//            nodeGeometry2.firstMaterial?.diffuse.contents = UIColor.red
//            nodeHolder2.geometry = nodeGeometry2
//            let pos2 = SCNVector3(imageAnchor.transform.columns.3.x - 0.01,
//                                 imageAnchor.transform.columns.3.y,
//                                 imageAnchor.transform.columns.3.z)
//            nodeHolder2.position = pos2
//            sceneView?.scene.rootNode.addChildNode(nodeHolder2)
//
//            let nodeHolder3 = SCNNode()
//            let nodeGeometry3 = SCNBox(width: 0.02, height: 0.02, length: 0.02, chamferRadius: 0)
//            nodeGeometry3.firstMaterial?.diffuse.contents = UIColor.yellow
//            nodeHolder3.geometry = nodeGeometry3
//            let pos3 = SCNVector3(imageAnchor.transform.columns.3.x,
//                                 imageAnchor.transform.columns.3.y - 0.01,
//                                 imageAnchor.transform.columns.3.z)
//            nodeHolder3.position = pos3
//            sceneView?.scene.rootNode.addChildNode(nodeHolder3)
//
//            let nodeHolder4 = SCNNode()
//            let nodeGeometry4 = SCNBox(width: 0.02, height: 0.02, length: 0.02, chamferRadius: 0)
//            nodeGeometry4.firstMaterial?.diffuse.contents = UIColor.blue
//            nodeHolder4.geometry = nodeGeometry4
//            let pos4 = SCNVector3(imageAnchor.transform.columns.3.x,
//                                 imageAnchor.transform.columns.3.y,
//                                 imageAnchor.transform.columns.3.z - 0.01)
//            nodeHolder4.position = pos4
//            sceneView?.scene.rootNode.addChildNode(nodeHolder4)
            
            
            referenceImageName = imageAnchor.referenceImage.name!
            switch imageAnchor.referenceImage.name {
            case "coil":
                let size = imageAnchor.referenceImage.physicalSize
                let plane = SCNPlane(width: size.width, height: size.height)
                plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
                plane.cornerRadius = 0.005
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                node.name = "coil"
                node.addChildNode(planeNode)

                nodesArray.append(node)

            default:
                var shapeNode: SCNNode?
                shapeNode = pentagonRedNode

                let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
                let repeatSpin = SCNAction.repeatForever(shapeSpin)
                shapeNode?.runAction(repeatSpin)

                guard let shape = shapeNode else {
                    return
                }
                node.name = "mob"
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
            print("---------------")
            print(imageAnchor.referenceImage.name)

            switch imageAnchor.referenceImage.name {
            case "coil":
                break
            default:
                if referenceImageName != imageAnchor.referenceImage.name {
                    referenceImageName = imageAnchor.referenceImage.name!
                    nodesArray.removeLast()

                    var shapeNode: SCNNode?
                    shapeNode = pentagonRedNode

                    let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
                    let repeatSpin = SCNAction.repeatForever(shapeSpin)
                    shapeNode?.runAction(repeatSpin)

                    guard let shape = shapeNode else {
                        return
                    }
                    node.name = "mob"
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

    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if nodesArray.count == 2 {
            let positionOne = SCNVector3ToGLKVector3(nodesArray[0].position)
            let positionTwo = SCNVector3ToGLKVector3(nodesArray[1].position)
            var distance = GLKVector3Distance(positionOne, positionTwo)

            if nodesArray[1].position.x - nodesArray[0].position.x < 0 {
                distance *= -1.0
            }

            print("----------------------------------")
//            print(nodesArray[0].position)
//            print(nodesArray[1].position)
            print(distance)
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
        if distance < 0.12 && distance > 0.06 && distanceStatus != .five {
            setNode(status: .five)
        } else if distance < 0.06 && distance > 0.025 && distanceStatus != .four {
            setNode(status: .four)
        } else if distance < 0.025 && distance > -0.025 && distanceStatus != .three {
            setNode(status: .three)
        } else if distance < -0.025 && distance > -0.06 && distanceStatus != .two {
            setNode(status: .two)
        } else if distance < -0.06 && distance > -0.12 && distanceStatus != .one {
            setNode(status: .one)
        } else if (distance > 0.12 || distance < -0.12) && distanceStatus != .zero {
            setNode(status: .zero)
        }
    }
    
    private func setNode(status: DistanceStatus) {
        nodesArray[1].childNodes.first!.removeFromParentNode()
        
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
