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
    
    var remake : TimeInterval = 0
    var game = GameHelper.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScnView()
        configScene()
        configCamera()
        createHUD()
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
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
        scnView.delegate = self
        scnView.isPlaying = true
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
        
        let randomX = Float.random(min: -2.0, max: 2.0)
        let randomY = Float.random(min: 10, max: 8)
        
        let force = SCNVector3(x: randomX, y: randomY, z:0)
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        
        let color = UIColor.random()
        geometry.materials.first?.diffuse.contents = color
        
        let trailEmitter = createtrail(color, geometry)
        geometryNode.addParticleSystem(trailEmitter)
        
        if color == .black {
            geometryNode.name = "坏"
        } else {
            geometryNode.name = "好"
        }
        
        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        scn.rootNode.addChildNode(geometryNode)
        
    }
    
    func clearScene() {
    
        for node in scn.rootNode.childNodes {
            if node.presentation.position.y < -2 {
                node.removeFromParentNode()
            }
        }
    
    }
    
    func createtrail(_ color: UIColor,_ geometry: SCNGeometry) -> SCNParticleSystem {
        
        let trail = SCNParticleSystem(named: "Trail.scnp", inDirectory: nil)
        trail?.particleColor = color
        trail?.emitterShape = geometry
        return trail!
        
    }
    
    func createExpode(_ geometry: SCNGeometry, _ position: SCNVector3, _ rotate: SCNVector4) {
        let explode = SCNParticleSystem(named: "Explode.scnp", inDirectory: nil)!
        explode.emitterShape = geometry
        explode.birthLocation = .surface
        let rotateMatrix = SCNMatrix4MakeRotation(rotate.w, rotate.x, rotate.y, rotate.z)
        let transformMatrix = SCNMatrix4MakeTranslation(position.x, position.y, position.z)
        let convertMatrix = SCNMatrix4Mult(rotateMatrix, transformMatrix)
        scn.addParticleSystem(explode, transform: convertMatrix)
    }
    
    func tapHandle(_ node: SCNNode) {
        if node.name == "好" {
            game.score += 1
            createExpode(node.geometry!, node.presentation.position, node.presentation.rotation)
            node.removeFromParentNode()
        } else if node.name == "坏" {
            game.lives -= 1
            createExpode(node.geometry!, node.presentation.position, node.presentation.rotation)
            node.removeFromParentNode()
        }
    }
    
    func createHUD() {
        
        game.hudNode.position = SCNVector3(x: 0.0, y: 10.0, z: 0)
        scn.rootNode.addChildNode(game.hudNode)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tap = touches.first
        let position = tap?.location(in: scnView)
        let testResult = scnView.hitTest(position!, options: nil)
        if testResult.count > 0 {
            let result = testResult.first!
            tapHandle(result.node)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

extension GameViewController : SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > remake {
            genGeometry()
            
            remake = time + TimeInterval(Float.random(min: 0.2, max: 1.5))
        }
        clearScene()
        game.updateHUD()
    }

}

