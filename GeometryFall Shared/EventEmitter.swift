//
//  Observable.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 25.03.2022.
//

import Foundation
import CloudKit

typealias Action<T> = (T) -> Void

class Listener<T> {
    var action: Action<T>!
    
    init(_ action: @escaping Action<T>) {
        self.action = action
    }
}

enum PointingDeviceEvent {
    case down, up, hover, moved
}

class EventEmitter<T> {
    private var listeners: [Listener<T>] = []
    
    public func subscribe(for listener: Listener<T>) {
        self.listeners.append(listener)
    }
    
    public func subscribe(for action: @escaping Action<T>) {
        self.listeners.append(.init(action))
    }

    public func unsubscribe(from listener: Listener<T>) {
        guard let index = self.listeners.firstIndex(where: { $0 === listener }) else { return }
        self.listeners.remove(at: index)
    }
    
    public func emit(_ event: T) {
        self.listeners.forEach { $0.action(event) }
    }
}
