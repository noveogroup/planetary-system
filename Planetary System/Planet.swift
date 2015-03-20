//
//  Planet.swift
//  Planetary System
//
//  Created by Maxim Zabelin on 17/03/15.
//  Copyright (c) 2015 Noveo. All rights reserved.
//

import Foundation
import SpriteKit

class Planet: CelestialBody {
// @public

// @internal
    override var category: Category? {
        get {
            if (super.category == nil) {
                self.category = Category.Planet
            }

            return super.category
        }
        set {
            super.category = newValue
        }
    }

    override var name: String? {
        get {
            if (super.name == nil) {
                self.name = Name.Planet.rawValue
            }

            return super.name
        }
        set {
            super.name = newValue
        }
    }

    override init() {
        super.init()

        self.configurePhysicsBody()
    }

    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        assert((size.width == size.height),
            "Only planets of a round shape are supported.")

        super.init(texture: texture, color: color, size: size)

        self.configurePhysicsBody()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        assert((self.size.width == self.size.height),
            "Only planets of a round shape are supported.")

        self.configurePhysicsBody()
    }

    override func configureGravityField() {
        let scaleFactor: CGFloat = CGFloat(2)
        let transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)

        let fieldSize = CGSizeApplyAffineTransform(self.size, transform)
        let fieldStrength = Float(
            (log10(fieldSize.width) + log10(fieldSize.height)) / CGFloat(2)
        )

        let gravityField: SKFieldNode = SKFieldNode.radialGravityField()
        gravityField.region = SKRegion(size: fieldSize)
        if (gravityField.strength > fieldStrength) {
            gravityField.strength = fieldStrength
        }

        self.gravityField = gravityField
    }

// @private
    private func configurePhysicsBody() {
        let physicsBody: SKPhysicsBody =
            SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody.categoryBitMask =
            CelestialBody.Category.Planet.rawValue
        physicsBody.collisionBitMask =
            CelestialBody.Category.Asteroid.rawValue |
            CelestialBody.Category.Planet.rawValue
        physicsBody.contactTestBitMask =
            CelestialBody.Category.Asteroid.rawValue |
            CelestialBody.Category.Planet.rawValue
        physicsBody.mass = CGFloat.max
        physicsBody.dynamic = false

        self.physicsBody = physicsBody
    }
}
