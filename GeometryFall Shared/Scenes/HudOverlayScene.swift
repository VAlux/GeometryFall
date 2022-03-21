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
    var pauseButton: ButtonNode!
    var dispatcher: InputDispatcher!
    
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
    
    init(size: CGSize, dispatcher inputDispatcher: InputDispatcher) {
        self.dispatcher = inputDispatcher
        
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
        
        pauseButton = ButtonNode(
            regularTexture: SKTexture(imageNamed: "Pause Button"),
            pressedTexture: SKTexture(imageNamed: "Play Button"),
            disabledTexture: nil)
        
        pauseButton.position = .init(x: 50, y: 50)
        pauseButton.size = .init(width: 50, height: 50)
        dispatcher.register(target: pauseButton)
       
        addChild(scoreNode)
        addChild(pauseButton)
    }
}
