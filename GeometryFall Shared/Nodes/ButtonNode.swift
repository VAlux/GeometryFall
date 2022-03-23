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
    public override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        handleEnabled()
    }
    
    public override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        handleDisabled()
    }
#elseif os(iOS)
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleEnabled()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        handleDisabled()
    }
#endif
}
