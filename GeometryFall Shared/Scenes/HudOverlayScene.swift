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
    
    private let scoreLabelPadding = 10
    private let pauseButtonSize = CGFloat(50)
    private let scoreLabelFontScale = CGFloat(20)
    
    var score: UInt = 0 {
        didSet {
            scoreNode.text = "Score: \(score)"
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.scoreNode = coder.decodeObject(of: SKLabelNode.self, forKey: "ScoreLabel")
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
        
        pauseButton = ButtonNode(
            regularTexture: SKTexture(imageNamed: "Pause Button"),
            pressedTexture: SKTexture(imageNamed: "Play Button"),
            disabledTexture: nil)
        
        pauseButton.position = .init(x: frame.width - pauseButtonSize, y: frame.height - pauseButtonSize)
        pauseButton.size = .init(width: pauseButtonSize, height: pauseButtonSize)
       
        addChild(scoreNode)
        addChild(pauseButton)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        childNode(withName: "")
    }
}
