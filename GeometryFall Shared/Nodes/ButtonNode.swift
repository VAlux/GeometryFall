//
//  ButtonNode.swift
//  GeometryFall iOS
//
//  Created by Alexander Voievodin on 08.03.2022.
//

import Foundation
import SpriteKit

public class ButtonNode: SKSpriteNode {
    
    private var regularTexture: SKTexture!
    private var pressedTexture: SKTexture?
    private var disabledTexture: SKTexture?
    private var clickAction: ((ButtonNode) -> Void)?
    
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
    
    func setClickAction(with action: @escaping (ButtonNode) -> Void) {
        self.clickAction = action
    }
}

extension ButtonNode : Clickable {
    func handleTouchesBegan(at location: CGPoint) -> Bool {
        if isEnabled && frame.contains(location) {
            isPressed = true
            clickAction?(self)
            return true
        }
        
        return false
    }
    
    func handleTouchesMoved(at location: CGPoint) -> Bool {
        if isEnabled {
            if frame.contains(location) {
                isPressed = true
            } else {
                isPressed = false
            }
            
            return isPressed
        }
        
        return false
    }
    
    func handleTouchesEnded(at location: CGPoint) -> Bool {
        if isEnabled {
            isPressed = false
            return true
        }
        
        return false
    }
}
