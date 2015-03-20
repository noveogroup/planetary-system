//
//  ViewController.swift
//  Planetary System
//
//  Created by Maxim Zabelin on 16/03/15.
//  Copyright (c) 2015 Noveo. All rights reserved.
//

import SpriteKit
import UIKit

class ViewController: UIViewController {

    private var spriteView : SKView?
    private var scene: SKScene?

    override func viewDidLoad() {
        super.viewDidLoad()

        let spriteView: SKView = SKView()

    #if DEBUG
        spriteView.showsFPS = true
        spriteView.showsDrawCount = true
        spriteView.showsNodeCount = true
    #endif

        self.view.addSubview(spriteView)
        self.spriteView = spriteView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let spriteView = self.spriteView {
            spriteView.frame = self.view.bounds
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let spriteView = self.spriteView {
            let size: CGSize = self.view.bounds.size
            self.scene = PlanetarySystemScene(size: size)
            spriteView.presentScene(scene)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

