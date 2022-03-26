//
//  GameScene.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 07.03.2022.
//

import Foundation
import SceneKit
import SpriteKit

class GameScene : SCNScene, SCNSceneRendererDelegate {
    
    private var renderer: SCNSceneRenderer!
    private var hud: HudOverlayScene!
    private var menu: MainMenuScene!
    private var cameraNode: SCNNode!
    private var cubeCreationTime: TimeInterval = 0
    private let cubeCreationTimeout: TimeInterval = 0.8
    private var explosionParticleSystem: SCNParticleSystem!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(renderer sceneRenderer: SCNSceneRenderer) {
        super.init()
        
        self.renderer = sceneRenderer
        self.renderer.autoenablesDefaultLighting = true
        self.renderer.delegate = self
        
        self.physicsWorld.contactDelegate = self
        
        self.explosionParticleSystem = loadParticleSystem(from: "ExplosionParticleSystem.scn", withName: "explosion")
        self.cameraNode = createCameraNode()
        
        let floorNode = FloorNode(width: 200,
                                  height: 200,
                                  position: .init(0, -10, 0),
                                  rotation: .init(-1, 0, 0, Float.pi/2))
        
        self.hud = loadSKScene(withName: "HUDScene")
        self.menu = loadSKScene(withName: "MainMenuScene")
        
        self.renderer.overlaySKScene = hud
        self.hud.pauseButtonEvent.subscribe(for: { _ in self.toggleMenu() })
        
        self.rootNode.addChildNode(cameraNode)
        self.rootNode.addChildNode(floorNode)
    }
    
    private func toggleMenu() {
        self.isPaused = !self.isPaused
        
        if self.isPaused {
            self.hud.addChild(self.menu)
        } else {
            self.menu.removeFromParent()
        }
    }
    
    private func createCameraNode() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 400
        cameraNode.position = .init(x: 3, y: 35, z: 50)
        return cameraNode
    }
    
    private func loadSKScene<T: SKScene>(withName fileName: String) -> T? {
        guard let scene = SKScene(fileNamed: fileName) as? T
        else { fatalError("Was not able to load scene with name: \(fileName)") }
        
        return scene
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
    
    private func spawnParticle(at position: SCNVector3) {
        let explosion = createParticleNode(at: position)
        let chain = SCNAction.sequence([
            SCNAction.run { _ in self.rootNode.addChildNode(explosion) } ,
            SCNAction.wait(duration: explosion.particleSystems!.first!.emissionDuration),
            SCNAction.run { _ in explosion.removeFromParentNode() }
        ])
        
        rootNode.runAction(chain)
    }
    
    func handleClick(at location: CGPoint) {
        if self.isPaused { return }
        
        if let node = renderer.hitTest(location, options: nil).first?.node as? GameBoxNode {
            spawnParticle(at: node.presentation.position)
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

private class FloorNode : SCNNode {
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

private class GameBoxNode : SCNNode {
    
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
