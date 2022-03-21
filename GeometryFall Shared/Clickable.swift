//
//  Clickable.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 20.03.2022.
//

import Foundation
import SceneKit

protocol Clickable {
    func handleTouchesBegan(at location: CGPoint) -> Bool
    func handleTouchesMoved(at location: CGPoint) -> Bool
    func handleTouchesEnded(at location: CGPoint) -> Bool
}
