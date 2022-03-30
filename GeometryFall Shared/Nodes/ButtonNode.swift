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
}

extension ButtonNode: ClickEventConsumer {
    func consumeClickEvent(for event: EventEmitter<PointingDeviceEvent>) {
        event.subscribe { evt in self.isPressed = evt == .down }
    }
}
