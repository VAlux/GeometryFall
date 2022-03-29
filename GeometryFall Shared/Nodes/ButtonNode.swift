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
    
    var clickAction: ((ButtonNode) -> Void)?
    
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
        self.regularTexture = self.texture
        if let pressed = self.userData?["pressed"] as? String {
            self.pressedTexture = .init(imageNamed: pressed)
        }
        
        if let disabled = self.userData?["disabled"] as? String {
            self.disabledTexture = .init(imageNamed: disabled)
        }
    }
    
    init(regularTexture: SKTexture, pressedTexture: SKTexture?, disabledTexture: SKTexture?) {
        super.init(texture: regularTexture, color: SKColor.white, size: regularTexture.size())
        
        self.regularTexture = regularTexture
        self.pressedTexture = pressedTexture
        self.disabledTexture = disabledTexture
    }
    
    private func handleEnabled() {
        if isEnabled {
            isPressed = true
            clickAction?(self)
        }
    }
    
    private func handleDisabled() {
        if isEnabled {
            isPressed = false
        }
    }
    
#if os(macOS)
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        handleEnabled()
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        handleDisabled()
    }
#elseif os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleEnabled()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        handleDisabled()
    }
#endif
}
