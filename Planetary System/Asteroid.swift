//
//  Asteroid.swift
//  Planetary System
//
//  Created by Maxim Zabelin on 18/03/15.
//  Copyright (c) 2015 Noveo. All rights reserved.
//

import Foundation
import SpriteKit

class Asteroid: CelestialBody {
    // @public

    // @internal
    override var category: Category? {
        get {
            if (super.category == nil) {
                self.category = Category.Asteroid
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
                self.name = Name.Asteroid.rawValue
            }

            return super.name
        }
        set {
            super.name = newValue
        }
    }

    var lifetime: CGFloat = CGFloat(0)
    var drivingBlock: ((Void) -> Void) = {}

    override init() {
        super.init()

        self.configurePhysicsBody()
    }

    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        assert((size.width == size.height),
            "Only asteroids of a round shape are supported.")

        super.init(texture: texture, color: color, size: size)

        self.configurePhysicsBody()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        assert((self.size.width == self.size.height),
            "Only asteroids of a round shape are supported.")

        self.configurePhysicsBody()
    }

    // @private
    private func configurePhysicsBody() {
        let physicsBody: SKPhysicsBody =
            SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask =
            CelestialBody.Category.Asteroid.rawValue
        physicsBody.collisionBitMask =
            CelestialBody.Category.Asteroid.rawValue |
            CelestialBody.Category.Planet.rawValue
        physicsBody.contactTestBitMask =
            CelestialBody.Category.Asteroid.rawValue |
            CelestialBody.Category.Planet.rawValue
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.mass = CGFloat(
            pow(Double(self.size.width), 3.0) * M_PI_2 / 3.0 * 1.0 /*density*/
        )

        self.physicsBody = physicsBody
    }
}
