//
//  NodeGroup.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 29.03.2022.
//

import Foundation
import SpriteKit

class ClickableNode: SKNode {
    var clickAction: ((ClickableNode) -> Void)?
}
