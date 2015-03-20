//
//  PlanetarySystemScene.swift
//  Planetary System
//
//  Created by Maxim Zabelin on 16/03/15.
//  Copyright (c) 2015 Noveo. All rights reserved.
//

import SpriteKit
import UIKit

class PlanetarySystemScene: SKScene, SKPhysicsContactDelegate {

    private struct Auxiliaries {
        static func skRandf() -> CGFloat {
            return CGFloat(rand()) / CGFloat(RAND_MAX)
        }

        static func skRand(low: CGFloat, high: CGFloat) -> CGFloat {
            return skRandf() * (high - low) + low
        }
    }

    private struct Constants {
        static let planetRadius: CGFloat = CGFloat(32)
        static let planetDiameter: CGFloat = CGFloat(planetRadius * 2)
        static let planetSize: CGSize = CGSizeMake(planetDiameter, planetDiameter)

        static let asteroidRadiusRange = (low: CGFloat(2), high: CGFloat(6))
    }

    private var contentCreated: Bool?

    private func launchAsteroid() {
        let asteroidRadius: CGFloat = Auxiliaries.skRand(
            Constants.asteroidRadiusRange.low,
            high: Constants.asteroidRadiusRange.high
        )
        let asteroidDiameter: CGFloat = CGFloat(asteroidRadius * 2)
        let asteroidSize: CGSize = CGSizeMake(asteroidDiameter, asteroidDiameter)

        var vector: CGVector = CGVectorMake(0, 0)
        let asteroid: Asteroid = Asteroid(color: SKColor.brownColor(), size: asteroidSize)
        if (Auxiliaries.skRand(0, high: 1) < CGFloat(0.5)) {
            if (Auxiliaries.skRand(0, high: 1) < CGFloat(0.5)) {
                asteroid.position = CGPointMake(
                    0,
                    Auxiliaries.skRand(0, high: self.size.height)
                )
                vector = CGVectorMake(1, 1)
            }
            else {
                asteroid.position = CGPointMake(
                    self.size.width,
                    Auxiliaries.skRand(0, high: self.size.height)
                )
                vector = CGVectorMake(-1, -1)
            }
        }
        else {
            if (Auxiliaries.skRand(0, high: 1) < CGFloat(0.5)) {
                asteroid.position = CGPointMake(
                    Auxiliaries.skRand(0, high: self.size.width),
                    0
                )
                vector = CGVectorMake(1, 1)
            }
            else {
                asteroid.position = CGPointMake(
                    Auxiliaries.skRand(0, high: self.size.width),
                    self.size.height
                )
                vector = CGVectorMake(-1, -1)
            }
        }

        let refreshRate: CGFloat = Auxiliaries.skRand(0.05, high: 0.25)

        asteroid.drivingBlock = { [weak asteroid] (Void) -> Void in
            if let strongAsteroid = asteroid {
                let t: CGFloat = strongAsteroid.lifetime

                var position: CGPoint = strongAsteroid.position
                position.x += vector.dx * (asteroidRadius * (t - sin(t))) % asteroidRadius
                position.y += vector.dy * (asteroidRadius * (1 - cos(t))) % asteroidRadius
                strongAsteroid.position = position

                strongAsteroid.lifetime += refreshRate
            }
        }
        let drive: SKAction = SKAction.sequence([
            SKAction.runBlock { [weak asteroid] () -> Void in
                if let strongAsteroid = asteroid {
                    strongAsteroid.drivingBlock()
                }
            },
            SKAction.waitForDuration(NSTimeInterval(refreshRate))
        ])

        self.addChild(asteroid)

        self.runAction(SKAction.repeatActionForever(drive))
    }

    private func createSceneContents() {
        self.backgroundColor = SKColor.blackColor()
        self.physicsWorld.contactDelegate = self
        self.scaleMode = SKSceneScaleMode.AspectFit

        let planet: Planet = Planet(color: SKColor.grayColor(), size: Constants.planetSize)
        planet.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))

        let rotation: SKAction = SKAction.rotateByAngle(0.25, duration: 1.0)
        planet.runAction(SKAction.repeatActionForever(rotation))

        self.addChild(planet)

        let launchAsteroids: SKAction = SKAction.sequence([
                SKAction.runBlock({ [weak self] () -> Void in
                    if let strongSelf = self {
                        strongSelf.launchAsteroid()
                    }
                }),
                SKAction.waitForDuration(0.25)
            ])
        self.runAction(SKAction.repeatActionForever(launchAsteroids))
    }

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        if (self.contentCreated == nil) {
            self.createSceneContents()
            self.contentCreated = true
        }
    }

    override func didSimulatePhysics() {
        super.didSimulatePhysics()

        self.enumerateChildNodesWithName(CelestialBody.Name.Asteroid.rawValue,
            usingBlock: { (rock: SKNode!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                if (rock.position.x < 0) || (rock.position.y < 0) ||
                   (rock.position.x > self.size.width) || (rock.position.y > self.size.height) {
                    rock.removeFromParent()
                }
            })
    }

    func didBeginContact(contact: SKPhysicsContact) {
        let blast: SKNode = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(16, 16))
        blast.position = contact.contactPoint

        let fadeIn: SKAction = SKAction.fadeInWithDuration(0.5)
        let scale: SKAction = SKAction.scaleBy(2, duration: 0.5)
        let group: SKAction = SKAction.group([fadeIn, scale])
        blast.alpha = 0

        addChild(blast)

        blast.runAction(group, completion: { [weak blast] () -> Void in
            if let blast_ = blast {
                blast_.removeFromParent()
            }
        })

        if (contact.bodyA.categoryBitMask == CelestialBody.Category.Asteroid.rawValue) {
            if let node = contact.bodyA.node {
                node.removeFromParent()
            }
        }
        if (contact.bodyB.categoryBitMask == CelestialBody.Category.Asteroid.rawValue) {
            if let node = contact.bodyB.node {
                node.removeFromParent()
            }
        }
    }
}
