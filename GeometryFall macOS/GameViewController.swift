//
//  GameViewController.swift
//  SceneKitPlayground macOS
//
//  Created by Alexander Voievodin on 05.03.2022.
//

import Cocoa
import SceneKit
import Foundation

class GameViewController: NSViewController {
    
    var gameView: SCNView {
        return self.view as! SCNView
    }
    
    var gameController: GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameController = GameController(sceneRenderer: gameView)
        self.gameView.allowsCameraControl = false
        self.gameView.showsStatistics = false
        self.gameView.backgroundColor = NSColor.black
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let point = gameView.convert(event.locationInWindow, to: nil).cgPoint
        gameController.handleTouchesBegan(at: point)
    }
}

extension NSPoint {
    var cgPoint: CGPoint {
        .init(x: x, y: y)
    }
}
