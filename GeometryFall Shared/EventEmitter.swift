//
//  Observable.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 25.03.2022.
//

import Foundation
import CloudKit

typealias Listener<T> = (_ event: T) -> Void

enum ButtonEvent {
    case KEY_DOWN, KEY_UP
}

class EventEmitter<T> {
    private var listener: Listener<T>?
    
    public func subscribe(for listener: @escaping Listener<T>) {
        self.listener = listener
    }

    public func unsubscribe() {
        self.listener = nil
    }
    
    public func emit(_ event: T) {
        listener?(event)
    }
}
