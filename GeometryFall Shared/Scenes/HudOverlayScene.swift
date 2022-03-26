//
//  HudOverlayScene.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 06.03.2022.
//

import Foundation
import SpriteKit

class HudOverlayScene : SKScene {
    
    var scoreLabelNode: SKLabelNode!
    var pauseButtonNode: ButtonNode!
    
    private let scoreLabelPadding = CGFloat(50)
    private let pauseButtonSize = CGFloat(50)
    private let scoreLabelFontScale = CGFloat(20)
    
    let pauseButtonEvent = EventEmitter<ButtonEvent>()
    
    var score: UInt = 0 {
        didSet {
            self.scoreLabelNode.text = "Score: \(score)"
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SCNColor.clear
        
        scaleMode = .aspectFill
    }
    
    private func recalculateNodesDimensions() {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        if let scoreLabel = childNode(withName: "ScoreLabel") as? SKLabelNode {
            self.scoreLabelNode = scoreLabel
        } else { return }
        
        self.scoreLabelNode.position =
            .init(x: center.x - (size.width - scoreLabelPadding), y: center.y - (size.height - scoreLabelPadding))
        
        if let pauseButton = childNode(withName: "PauseButton") as? ButtonNode {
            self.pauseButtonNode = pauseButton
        } else { return }

        self.pauseButtonNode.position = .init(x: center.x - pauseButtonSize, y: center.y - pauseButtonSize)
        self.pauseButtonNode.size = .init(width: pauseButtonSize, height: pauseButtonSize)
        self.pauseButtonNode.isUserInteractionEnabled = true
        
        self.pauseButtonNode.clickAction = { _ in self.pauseButtonEvent.emit(.KEY_DOWN) }
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        recalculateNodesDimensions()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        size = view.frame.size
        recalculateNodesDimensions()
        
        isUserInteractionEnabled = false
    }
}
