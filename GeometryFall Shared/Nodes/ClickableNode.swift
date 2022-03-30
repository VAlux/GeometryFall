//
//  NodeGroup.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 29.03.2022.
//

import Foundation
import SpriteKit

protocol ClickEventProducer {
    func clickEvent() -> EventEmitter<PointingDeviceEvent>
}

protocol ClickEventConsumer {
    func consumeClickEvent(for event: EventEmitter<PointingDeviceEvent>)
}

class ClickableNode: SKSpriteNode {
    
    let click = EventEmitter<PointingDeviceEvent>()
    
    private func handleDown() {
        click.emit(.down)
    }
    
    private func handleUp() {
        click.emit(.up)
    }
    
    override func addChild(_ node: SKNode) {
        super.addChild(node)
        if let clickConsumer = node as? ClickEventConsumer {
            clickConsumer.consumeClickEvent(for: click)
        }
    }
    
#if os(macOS)
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        handleDown()
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        handleUp()
    }
#elseif os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleDown()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        handleUp()
    }
#endif
}

extension ClickableNode: ClickEventProducer {
    func clickEvent() -> EventEmitter<PointingDeviceEvent> {
        self.click
    }
}
