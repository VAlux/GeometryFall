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
    private var pauseButtonNode: ButtonNode!
    
    var pauseButton = ClickableNode()

    let pauseButtonClickEvent = EventEmitter<PointingDeviceEvent>()
    
    private let scoreLabelPadding = CGFloat(50)
    private let pauseButtonSize = CGFloat(50)
    private let scoreLabelFontScale = CGFloat(20)
    
    var score: UInt = 0 {
        didSet {
            self.scoreLabelNode.text = "Score: \(score)"
        }
    }
    
    private func recalculateNodesDimensions() {
        guard self.nodesLoaded else { return }
        
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        self.scoreLabelNode.position = .init(
            x: center.x - (size.width - scoreLabelPadding),
            y: center.y - (size.height - scoreLabelPadding))
        
        self.pauseButton.position = .init(x: center.x - pauseButtonSize, y: center.y - pauseButtonSize)
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        self.isUserInteractionEnabled = false
        self.pauseButton.isUserInteractionEnabled = true
        
        let buttonSize = CGSize(width: pauseButtonSize, height: pauseButtonSize)
        
        self.pauseButtonNode.position = .zero
        self.pauseButtonNode.size = buttonSize
        self.pauseButtonNode.isUserInteractionEnabled = false
        self.pauseButtonNode.removeFromParent()
        
        self.pauseButton.size = buttonSize
        
        pauseButton.addChild(self.pauseButtonNode)
        addChild(pauseButton)
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        recalculateNodesDimensions()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        recalculateNodesDimensions()
    }
}
