//
//  GameViewController.swift
//  SceneKitPlayground macOS
//
//  Created by Alexander Voievodin on 05.03.2022.
//

import Cocoa
import SceneKit

class GameViewController: NSViewController {
    
    var gameView: SCNView {
        return self.view as! SCNView
    }
    
    var gameController: GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameController = GameController(sceneRenderer: gameView)
        
        // Allow the user to manipulate the camera
        self.gameView.allowsCameraControl = false
        
        // Show statistics such as fps and timing information
        self.gameView.showsStatistics = false
        
        // Configure the view
        self.gameView.backgroundColor = NSColor.black
        
        // Add a click gesture recognizer
        let clickGesture = NSPressGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        clickGesture.minimumPressDuration = 0
        var gestureRecognizers = gameView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        self.gameView.gestureRecognizers = gestureRecognizers
    }
    
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        gameController.handleHit(at: gestureRecognizer.location(in: gameView))
    }
}
