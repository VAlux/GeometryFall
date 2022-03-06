//
//  GameController.swift
//  SceneKitPlayground Shared
//
//  Created by Alexander Voievodin on 05.03.2022.
//

import SceneKit

#if os(macOS)
typealias SCNColor = NSColor
#else
typealias SCNColor = UIColor
#endif

class GameController: NSObject, SCNSceneRendererDelegate {
    
    let scene: SCNScene
    let sceneRenderer: SCNSceneRenderer
    private var cameraNode: SCNNode!
    private var cubeCreationTime: TimeInterval = 0
    private let cubeCreationTimeout: TimeInterval = 0.8
    private var explosionParticleSystem: SCNParticleSystem!
    
    init(sceneRenderer renderer: SCNSceneRenderer) {
        sceneRenderer = renderer
        scene = SCNScene()
        
        super.init()
        
        explosionParticleSystem = loadParticleSystem(sceneName: "ParticleSystem.scn", systemName: "explosion")
        sceneRenderer.delegate = self
        sceneRenderer.scene = scene
        sceneRenderer.autoenablesDefaultLighting = true
        
        cameraNode = createCameraNode()
        scene.rootNode.addChildNode(cameraNode)
        
        let floorNode = FloorNode(width: 200,
                                  height: 200,
                                  position: .init(0, -10, 0),
                                  rotation: .init(-1, 0, 0, Float.pi/2))
        
        scene.rootNode.addChildNode(floorNode)
        scene.physicsWorld.contactDelegate = self
    }
    
    private func createCameraNode() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 400
        cameraNode.position = SCNVector3(x: 3, y: 35, z: 50)
        return cameraNode
    }
    
    private func loadParticleSystem(sceneName: String, systemName: String) -> SCNParticleSystem {
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
        if let node = sceneRenderer.hitTest(location, options: nil).first?.node as? GameBoxNode {
            let explosion = createParticleNode(at: node.presentation.position)
            scene.rootNode.addChildNode(explosion)
            node.removeFromParentNode()
            if node.isTarget {
                scene.background.contents = node.geometry?.materials.first?.diffuse.contents
            } else {
                scene.background.contents = SCNColor.black
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > cubeCreationTime {
            let node = GameBoxNode(target: arc4random_uniform(2) == 1)
            let randomDirection = CGFloat(arc4random_uniform(10)) - 5
            node.physicsBody?.applyForce(.init(CGFloat(randomDirection), 40, 0), at: .init(0.5, 0.5, 0.5), asImpulse: true)
            scene.rootNode.addChildNode(node)
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

extension GameController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if contact.nodeA is GameBoxNode, contact.nodeB is FloorNode {
            contact.nodeA.removeFromParentNode()
        } else if contact.nodeA is FloorNode, contact.nodeB is GameBoxNode {
            contact.nodeB.removeFromParentNode()
        }
    }
}
