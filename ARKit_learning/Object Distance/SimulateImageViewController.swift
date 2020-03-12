//
//  SimulateImageViewController.swift
//  ARKit_learning
//
//  Created by 鈴木 公章 on 2019/08/25.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit
import ARKit

final class SimulateImageViewController: UIViewController {
    enum Const {
        static let simulateImage = [UIImage(named: "dan1")!,
                                    UIImage(named: "dan2")!,
                                    UIImage(named: "dan3")!,
                                    UIImage(named: "dan4")!,
                                    UIImage(named: "dan5")!,
                                    UIImage(named: "dan6")!,
                                    UIImage(named: "dan7")!,
                                    UIImage(named: "dan8")!,
                                    UIImage(named: "dan9")!,
                                    UIImage(named: "dan10")!]
    }

    @IBOutlet private weak var sceneView: ARSCNView!

    private var coilSize = CGSize()
    private var nodesArray = [SCNNode]()
    private var referenceImageName = String()

    private enum DistanceStatus {
        case zero
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
    }
    private var distanceStatus: DistanceStatus = .zero
    private let configuration: ARWorldTrackingConfiguration = {
        let conf = ARWorldTrackingConfiguration()
        conf.environmentTexturing = .automatic

        let images = ARReferenceImage.referenceImages(inGroupNamed: "AR Ninebot", bundle: nil)
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

    private func createSimulateNode(_ node: SCNNode, size: CGSize, status: DistanceStatus) -> SCNNode {
        let plane = SCNPlane(width: size.width,
                                height: size.height)
        switch status {
        case .zero:
            plane.firstMaterial?.diffuse.contents = Const.simulateImage[0]
        case .one:
            plane.firstMaterial?.diffuse.contents = Const.simulateImage[1]
        case .two:
            plane.firstMaterial?.diffuse.contents = Const.simulateImage[2]
        case .three:
            plane.firstMaterial?.diffuse.contents = Const.simulateImage[3]
        case .four:
            plane.firstMaterial?.diffuse.contents = Const.simulateImage[4]
        case .five:
            plane.firstMaterial?.diffuse.contents = Const.simulateImage[5]
        case .six:
            plane.firstMaterial?.diffuse.contents = Const.simulateImage[6]
        case .seven:
            plane.firstMaterial?.diffuse.contents = Const.simulateImage[7]
        case .eight:
            plane.firstMaterial?.diffuse.contents = Const.simulateImage[8]
        case .nine:
            plane.firstMaterial?.diffuse.contents = Const.simulateImage[9]
        }

        node.geometry = plane
        return node
    }
}

extension SimulateImageViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor {
            referenceImageName = imageAnchor.referenceImage.name!

            if (imageAnchor.referenceImage.name?.contains("coil"))! && nodesArray.isEmpty {
                coilSize = imageAnchor.referenceImage.physicalSize
                let size = imageAnchor.referenceImage.physicalSize
                let plane = SCNPlane(width: size.width, height: size.height)
                plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
                plane.cornerRadius = 0.005
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                node.name = "coil"
                node.addChildNode(planeNode)

                nodesArray.append(node)
            } else if (imageAnchor.referenceImage.name?.contains("ninebot"))! {

                if !nodesArray.isEmpty {
                    let plane = SCNPlane(width: coilSize.width, height: coilSize.height)
                    plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)

                    let planeNode = SCNNode(geometry: plane)
                    planeNode.eulerAngles.x = -.pi * 2
                    nodesArray[0].addChildNode(planeNode)
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

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if nodesArray.count == 2 {
            var node0Pos = nodesArray[0].position
            var node1Pos = nodesArray[1].position

            node0Pos.y = 0
            node0Pos.z = 0
            node1Pos.y = 0
            node1Pos.z = 0
            let positionOne = SCNVector3ToGLKVector3(node0Pos)
            let positionTwo = SCNVector3ToGLKVector3(node1Pos)
            var distance = GLKVector3Distance(positionOne, positionTwo)
            if nodesArray[1].position.x - nodesArray[0].position.x < 0 {
                distance *= -1.0
            }

            changeNode(distance: distance)
        }
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
        if distance < 1.2 && distance > 0.8 && distanceStatus != .nine {
            setNode(status: .nine)
        } else if distance < 0.8 && distance > 0.6 && distanceStatus != .eight {
            setNode(status: .eight)
        } else if distance < 0.6 && distance > 0.4 && distanceStatus != .seven {
            setNode(status: .seven)
        } else if distance < 0.4 && distance > 0.25 && distanceStatus != .six {
            setNode(status: .six)
        } else if distance < 0.25 && distance > -0.25 && distanceStatus != .five {
            setNode(status: .five)
        } else if distance < -0.25 && distance > -0.4 && distanceStatus != .four {
            setNode(status: .four)
        } else if distance < -0.4 && distance > -0.6 && distanceStatus != .three {
            setNode(status: .three)
        } else if distance < -0.6 && distance > -0.8 && distanceStatus != .two {
            setNode(status: .two)
        } else if distance < -0.8 && distance > -1.2 && distanceStatus != .one {
            setNode(status: .one)
        } else if (distance > 1.2 || distance < -1.2) && distanceStatus != .zero {
            setNode(status: .zero)
        }
    }

    private func setNode(status: DistanceStatus) {
        if nodesArray.count != 2 {
            return
        }
        for node in nodesArray[0].childNodes {
            if let name = node.name {
                if name.contains("simulate") {
                    node.removeFromParentNode()
                }
            }
        }

        var simulateNode: SCNNode?
        distanceStatus = status
        simulateNode = createSimulateNode(simulateNode!,
                                          size: CGSize(width: coilSize.width, height: coilSize.height),
                                          status: distanceStatus)
        guard let simulate = simulateNode else {
            return
        }
        nodesArray[0].addChildNode(simulate)
    }
}

