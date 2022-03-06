//
//  HudOverlayScene.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 06.03.2022.
//

import Foundation
import SpriteKit

class HudOverlayScene : SKScene {
    
    var scoreNode: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreNode.text = "Score: \(score)"
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SCNColor.clear
        
        isUserInteractionEnabled = false
        
        scoreNode = SKLabelNode(text: "Score: 0")
        scoreNode.fontColor = SCNColor.white
        scoreNode.fontSize = 24
        scoreNode.position = .init(x: size.width / 8, y: 10)
        
        addChild(scoreNode)
    }
}
