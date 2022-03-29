//
//  HudOverlayScene.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 06.03.2022.
//

import Foundation
import SpriteKit

class HudOverlayScene : GFSKScene {
    
    @SKNamedNode("ScoreLabel")
    var scoreLabelNode: SKLabelNode!
    
    @SKNamedNode("PauseButton")
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
    
    private func recalculateNodesDimensions() {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        self.scoreLabelNode.position =
            .init(x: center.x - (size.width - scoreLabelPadding), y: center.y - (size.height - scoreLabelPadding))
        
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
