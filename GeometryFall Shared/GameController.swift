//
//  GameController.swift
//  SceneKitPlayground Shared
//
//  Created by Alexander Voievodin on 05.03.2022.
//

import SceneKit

#if os(watchOS)
import WatchKit
#endif

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
    
    init(sceneRenderer renderer: SCNSceneRenderer) {
        sceneRenderer = renderer
        scene = SCNScene()
        
        super.init()
        
        sceneRenderer.delegate = self
        sceneRenderer.scene = scene
        sceneRenderer.autoenablesDefaultLighting = true
        
        cameraNode = createCameraNode()
        scene.rootNode.addChildNode(cameraNode)
        scene.rootNode.addChildNode(createPlane())
        
        scene.physicsWorld.contactDelegate = self
    }
    
    private func createCameraNode() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 400
        cameraNode.position = SCNVector3(x: 3, y: 35, z: 50)
        return cameraNode
    }
    
    private func createPlane() -> SCNNode {
        let plane = SCNPlane(width: 200, height: 200)
        plane.materials.first?.diffuse.contents = SCNColor.green
        let node = SCNNode(geometry: plane)
        node.position = .init(0, -10, 0)
        node.rotation = .init(-1, 0, 0, Float.pi/2)
        node.physicsBody = .init(type: .static, shape: nil)
        node.physicsBody?.categoryBitMask = 1
        node.physicsBody?.collisionBitMask = 2
        node.physicsBody?.contactTestBitMask = 2
        node.name = "floor"
        return node
    }
    
    func handleHit(at location: CGPoint) {
        if let node = sceneRenderer.hitTest(location, options: nil).first?.node as? GameBoxNode {
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
        if contact.nodeA is GameBoxNode, contact.nodeB.name == "floor" {
            contact.nodeA.removeFromParentNode()
        } else if contact.nodeA.name == "floor", contact.nodeB is GameBoxNode {
            contact.nodeB.removeFromParentNode()
        }
    }
}
