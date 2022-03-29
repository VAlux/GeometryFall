//
//  SKScene+ResourceLoader.swift
//  GeometryFall
//
//  Created by Alexander Voievodin on 27.03.2022.
//

import Foundation
import SpriteKit

protocol NamedResource {
    func load(from scene: SKScene)
}

@propertyWrapper
class SKNamedScene<T: SKScene> {
    private(set) var wrappedValue: T!
    
    init(_ fileName: String) {
        guard let scene = SKScene(fileNamed: fileName) as? T
        else { fatalError("Was not able to load scene with name: \(fileName)") }
        
        self.wrappedValue = scene
    }
}

@propertyWrapper
class SKNamedNode<T: SKNode>: NamedResource {
    private(set) var wrappedValue: T!
    private let name: String
    
    init(_ resource: String) {
        self.name = resource
    }
    
    func load(from scene: SKScene) {
        if wrappedValue != nil { return }
        
        guard let node = scene.childNode(withName: name) as? T
        else { fatalError("Was not able to load node with name: \(name)") }

        self.wrappedValue = node
    }
}

class GFSKScene: SKScene {
    override init() {
        super.init()
        loadNodes()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        loadNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNodes()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        loadNodes()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        loadNodes()
    }
    
    private func loadNodes() {
        Mirror(reflecting: self).children
            .compactMap { $0.value as? NamedResource }
            .forEach { $0.load(from: self) }
    }
}
