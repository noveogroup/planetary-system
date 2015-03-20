//
//  CelestialBody.swift
//  Planetary System
//
//  Created by Maxim Zabelin on 17/03/15.
//  Copyright (c) 2015 Noveo. All rights reserved.
//

import Foundation
import SpriteKit

class CelestialBody: SKSpriteNode {
// @public

// @internal
    enum Category : UInt32 {
        case Asteroid   = 0x01
        case Planet     = 0x10
    }

    enum Name : String {
        case Asteroid   = "Asteroid"
        case Planet     = "Planet"
    }

    var category: Category? {
        get {
            return category_
        }
        set {
            category_ = newValue
        }
    }

    var gravityField: SKFieldNode? {
        get {
            return gravityField_
        }
        set {
            if let oldGravityField = gravityField_ {
                oldGravityField.removeFromParent()
            }
            if let newGravityField = newValue {
                self.addChild(newGravityField)
            }
            gravityField_ = newValue
        }
    }

    override init() {
        super.init()

        self.configureGravityField()
    }

    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)

        self.configureGravityField()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.configureGravityField()
    }

    func configureGravityField() {
        /**
         *  @remarks    Intentionally doing nothing.
         */
    }

// @private
    private var category_: Category? = nil
    private weak var gravityField_: SKFieldNode? = nil
}
