//
//  InputDispatcher.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 21.03.2022.
//

import Foundation
import SceneKit

class InputDispatcher {
    
    private var inputRegistry = Array<Clickable>()
    
    public func register(target: Clickable) {
        self.inputRegistry.append(target)
    }
    
    private func dispatchInputHandling(for action: (Clickable) -> Bool) -> Bool {
        return inputRegistry.contains(where: action)
    }
    
    func handleTouchesBegan(at location: CGPoint) -> Bool {
        return dispatchInputHandling(for: { $0.handleTouchesBegan(at: location) })
    }
    
    func handleTouchesMoved(at location: CGPoint) -> Bool {
        return dispatchInputHandling(for: { $0.handleTouchesMoved(at: location) })
    }
    
    func hadleTouchesEnded(at location: CGPoint) -> Bool {
        return dispatchInputHandling(for: { $0.handleTouchesEnded(at: location) })
    }
}
