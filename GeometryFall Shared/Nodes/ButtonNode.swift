//
//  ButtonNode.swift
//  GeometryFall iOS
//
//  Created by Alexander Voievodin on 08.03.2022.
//

import Foundation
import SpriteKit

class ButtonNode: SKSpriteNode {
    
    private var regularTexture: SKTexture!
    private var pressedTexture: SKTexture?
    private var disabledTexture: SKTexture?
    private var clickAction: ((SKSpriteNode) -> Void)!
    
    var isEnabled: Bool = true {
        didSet {
            if disabledTexture != nil {
                texture = isEnabled ? regularTexture : disabledTexture
            }
        }
    }
    
    var isPressed: Bool = false {
        didSet {
            if pressedTexture != nil {
                texture = isPressed ? pressedTexture : regularTexture
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(regularTexture: SKTexture, pressedTexture: SKTexture?, disabledTexture: SKTexture?) {
        super.init(texture: regularTexture, color: SKColor.white, size: regularTexture.size())
        
        self.regularTexture = regularTexture
        self.pressedTexture = pressedTexture
        self.disabledTexture = disabledTexture
        self.isUserInteractionEnabled = true
    }
    
    func setClickAction(with action: @escaping (SKSpriteNode) -> Void) {
        self.clickAction = click
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            isPressed = true
            clickAction(self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            guard let touchLocation = touches.first?.location(in: parent!) else { return }
            if frame.contains(touchLocation) {
                isPressed = true
            } else {
                isPressed = false
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled {
            isPressed = false
        }
    }
}
