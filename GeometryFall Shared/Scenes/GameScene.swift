//
//  GameScene.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 07.03.2022.
//

import Foundation
import SceneKit

class GameScene : SCNScene, SCNSceneRendererDelegate {
    
    private var renderer: SCNSceneRenderer!
    private var hud: HudOverlayScene!
    private var cameraNode: SCNNode!
    private var cubeCreationTime: TimeInterval = 0
    private let cubeCreationTimeout: TimeInterval = 0.8
    private var explosionParticleSystem: SCNParticleSystem!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(renderer sceneRenderer: SCNSceneRenderer) {
        super.init()
        renderer = sceneRenderer
        renderer.autoenablesDefaultLighting = true
        renderer.delegate = self
        physicsWorld.contactDelegate = self
        
        explosionParticleSystem = loadParticleSystem(from: "ExplosionParticleSystem.scn", withName: "explosion")
        cameraNode = createCameraNode()
        
        let floorNode = FloorNode(width: 200,
                                  height: 200,
                                  position: .init(0, -10, 0),
                                  rotation: .init(-1, 0, 0, Float.pi/2))
        
        hud = HudOverlayScene(size: (sceneRenderer as! SCNView).bounds.size)
        sceneRenderer.overlaySKScene = hud
        
        rootNode.addChildNode(cameraNode)
        rootNode.addChildNode(floorNode)
    }
    
    private func createCameraNode() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 400
        cameraNode.position = .init(x: 3, y: 35, z: 50)
        return cameraNode
    }
    
    private func loadParticleSystem(from sceneName: String, withName systemName: String) -> SCNParticleSystem {
        guard let particleSystem = SCNScene(named: sceneName)?
                .rootNode
                .childNode(withName: systemName, recursively: true)?
                .particleSystems?
                .first else { fatalError("Was not able to load particle system!") }
        
        return particleSystem
    }
    
    private func createParticleNode(at position: SCNVector3) -> SCNNode {
        let particleNode = SCNNode()
        particleNode.position = position
        particleNode.addParticleSystem(explosionParticleSystem)
        return particleNode
    }
    
    func handleHit(at location: CGPoint) {
        if let node = renderer.hitTest(location, options: nil).first?.node as? GameBoxNode {
            let explosion = createParticleNode(at: node.presentation.position)
            rootNode.addChildNode(explosion)
            node.removeFromParentNode()
            if node.isTarget {
                if hud.score > 0 {
                    hud.score -= 1
                }
            } else {
                hud.score += 1
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > cubeCreationTime {
            let node = GameBoxNode(target: arc4random_uniform(2) == 1)
            let randomDirection = CGFloat(arc4random_uniform(10)) - 5
            node.physicsBody?.applyForce(.init(CGFloat(randomDirection), 40, 0), at: .init(0.5, 0.5, 0.5), asImpulse: true)
            rootNode.addChildNode(node)
            cubeCreationTime = time + cubeCreationTimeout
        }
    }
}

class FloorNode : SCNNode {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(width: CGFloat, height: CGFloat, position: SCNVector3, rotation: SCNVector4) {
        super.init()
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = SCNColor.green
        
        self.geometry = plane
        self.position = position
        self.rotation = rotation
        self.physicsBody = .init(type: .static, shape: nil)
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.collisionBitMask = 2
        self.physicsBody?.contactTestBitMask = 2
    }
}

class GameBoxNode : SCNNode {
    
    let isTarget: Bool
    
    required init?(coder: NSCoder) {
        isTarget = false
        super.init(coder: coder)
    }
    
    init(target: Bool) {
        isTarget = target
        super.init()
        
        let cube = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0)
        cube.materials.first?.diffuse.contents = isTarget ? SCNColor.red : SCNColor.green
        geometry = cube
        position = position
        physicsBody = .init(type: .dynamic, shape: nil)
        physicsBody?.categoryBitMask = 2
        physicsBody?.collisionBitMask = 3
        physicsBody?.contactTestBitMask = 1
    }
}

extension GameScene: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if contact.nodeA is GameBoxNode, contact.nodeB is FloorNode {
            contact.nodeA.removeFromParentNode()
        } else if contact.nodeA is FloorNode, contact.nodeB is GameBoxNode {
            contact.nodeB.removeFromParentNode()
        }
    }
}