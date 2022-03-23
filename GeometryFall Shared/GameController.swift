//
//  GameController.swift
//  SceneKitPlayground Shared
//
//  Created by Alexander Voievodin on 05.03.2022.
//

import SceneKit
import SpriteKit

#if os(macOS)
typealias SCNColor = NSColor
#else
typealias SCNColor = UIColor
#endif

class GameController: NSObject {
    
    private let scene: GameScene
    private let cubeCreationTimeout: TimeInterval = 0.8
    
    private var hud: HudOverlayScene!
    private var cameraNode: SCNNode!
    private var cubeCreationTime: TimeInterval = 0
    private var explosionParticleSystem: SCNParticleSystem!
    
    init(sceneRenderer renderer: SCNSceneRenderer) {
        scene = GameScene(renderer: renderer)
        super.init()
        
        renderer.scene = scene
    }
    
    func handleTouchesBegan(at location: CGPoint) {
        scene.handleClick(at: location)
    }
}
