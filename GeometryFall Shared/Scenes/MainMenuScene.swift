//
//  MainMenuScene.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 25.03.2022.
//

import Foundation
import SpriteKit

class MainMenuScene : GFSKScene {
    
    @SKNamedNode("Background")
    var backgroundNode: SKSpriteNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.physicsBody = nil
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        if self.nodesLoaded {
            self.backgroundNode.size = oldSize
        }
    }
}
