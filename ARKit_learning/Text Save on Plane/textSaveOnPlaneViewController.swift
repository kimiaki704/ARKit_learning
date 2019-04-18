//
//  textSaveOnPlaneViewController.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2019/04/18.
//  Copyright © 2019年 鈴木公章. All rights reserved.
//

import UIKit
import ARKit

final class textSaveOnPlaneViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    private let configuration: ARWorldTrackingConfiguration = {
        let conf = ARWorldTrackingConfiguration()
        conf.planeDetection = .horizontal
        conf.environmentTexturing = .automatic
        return conf
    }()
    
    lazy var textSaveURL: URL = {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
            .appendingPathComponent("map.arexperience")
        } catch {
            fatalError("cant get file save URL: \(error.localizedDescription)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        buttonsInit()
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
        guard let location = touches.first?.location(in: sceneView) else {
            return
        }
        guard let hitTest = sceneView.hitTest(location, types: [.existingPlane]).first else {
            return
        }
        let textAnchor = ARAnchor(name: "Text", transform: hitTest.worldTransform)
        sceneView.session.add(anchor: textAnchor)
    }
    
    private func buttonsInit() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        loadButton.addTarget(self, action: #selector(loadButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped(_ sender: UIButton) {
        sceneView.session.getCurrentWorldMap(completionHandler: { worldMap, error in
            guard let map = worldMap else {
                return
            }
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try data.write(to: self.textSaveURL)
            } catch {
                print(error)
            }
        })
    }
    
    @objc private func loadButtonTapped(_ sender: UIButton) {
        do {
            let data = try Data(contentsOf: textSaveURL)
            let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
            
            guard let map = worldMap else {
                return
            }
            setWorldMapToSession(worldMap: map)
        } catch {
            
        }
    }
    
    private func setWorldMapToSession(worldMap: ARWorldMap) {
        let configration = ARWorldTrackingConfiguration()
        configration.initialWorldMap = worldMap
        sceneView.session.run(configration, options: [])
    }
}

extension textSaveOnPlaneViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor.name == "Text" {
            let textGeometory = SCNText(string: "たくけん", extrusionDepth: 10)
            let textNode = SCNNode(geometry: textGeometory)
            textNode.scale = SCNVector3(0.005, 0.005, 0.005)
            
            node.addChildNode(textNode)
        }
    }
}

