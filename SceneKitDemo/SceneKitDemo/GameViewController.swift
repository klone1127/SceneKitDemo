//
//  GameViewController.swift
//  SceneKitDemo
//
//  Created by CF on 2017/5/7.
//  Copyright © 2017年 klone. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var scnView : SCNView!
    var scn : SCNScene!
    var cameraNode : SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScnView()
        configScene()
        configCamera()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func configScnView() {
        scnView = self.view as! SCNView
//        scnView.backgroundColor = UIColor.white
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.delegate = self
    }
    
    func configScene() {
        scn = SCNScene()
        scnView.scene = scn
        scn.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
    }
    
    func configCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10)
        scn.rootNode.addChildNode(cameraNode)
    }
    
    func genGeometry() {
        var geometry : SCNGeometry
        switch shape.randomShape() {
        case shape.box :
            geometry = SCNBox(width: 0.8, height: 1.0, length: 0.5, chamferRadius: 0.0)
        case shape.tube :
            geometry = SCNBox(width: 1.0, height: 1.0, length: 0.5, chamferRadius: 0.5)
        case shape.cone:
            geometry = SCNBox(width: 0.8, height: 1.0, length: 0.5, chamferRadius: 0.0)
        case shape.torus:
            geometry = SCNBox(width: 0.8, height: 1.0, length: 0.5, chamferRadius: 0.0)
        case shape.capsule:
            geometry = SCNBox(width: 0.8, height: 1.0, length: 0.5, chamferRadius: 0.0)
        case shape.pyramid:
            geometry = SCNBox(width: 1.0, height: 0.6, length: 0.8, chamferRadius: 0.0)
        case shape.sphere:
            geometry = SCNBox(width: 0.8, height: 1.0, length: 0.5, chamferRadius: 0.5)
        default:
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        }
        
        let geometryNode = SCNNode(geometry: geometry)
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        geometry.materials.first?.diffuse.contents = UIColor.random()
        
        let randomX = Float.random(min: -2.0, max: 2.0)
        let randomY = Float.random(min: 10, max: 8)
        
        let force = SCNVector3(x: randomX, y: randomY, z:0)
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        
        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        scn.rootNode.addChildNode(geometryNode)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

extension GameViewController : SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
         genGeometry()
    }

}

