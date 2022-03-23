//
//  GameViewController.swift
//  SceneKitPlayground iOS
//
//  Created by Alexander Voievodin on 05.03.2022.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {

    var gameView: SCNView {
        return self.view as! SCNView
    }
    
    var gameController: GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameController = GameController(sceneRenderer: gameView)
        self.gameView.allowsCameraControl = false
        self.gameView.backgroundColor = UIColor.black
    }
    
    private func dispatchTouchAction(for action: (CGPoint) -> Void, using touches: Set<UITouch>) {
        guard let point = touches.first?.location(in: gameView) else { return }
        action(point)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dispatchTouchAction(for: gameController.handleTouchesBegan, using: touches)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
