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
    
    private let scoreLabelPadding = 10
    private let scoreLabelFontScale = CGFloat(20)
    
    var score: UInt = 0 {
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
        scaleMode = .aspectFit
        
        scoreNode = SKLabelNode(text: "Score: 0")
        scoreNode.fontColor = SCNColor.white
        scoreNode.fontSize = size.height / scoreLabelFontScale
        scoreNode.verticalAlignmentMode = .bottom
        scoreNode.horizontalAlignmentMode = .left
        scoreNode.position = .init(x: scoreLabelPadding, y: scoreLabelPadding)
       
        addChild(scoreNode)
    }
}
