
//
//  MainScene.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox 

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    var audio = OALSimpleAudio.sharedInstance()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // sound with AVFoundation
    var audioPlayer = AVAudioPlayer()
    
    // Spaceship
    weak var ship: Ship!
    
    //Physics nodes
    weak var gamePhysicsNode : CCPhysicsNode!
    
    //Sprites
    weak var ground1 : CCSprite!
    weak var ground2 : CCSprite!
    weak var star1 : CCSprite!
    weak var star2 : CCSprite!
    
    
    //Nodes
    weak var barrier: CCNode!
    weak var gameEnd : CCNode!
    
    //Labels
    weak var scoreLabel: CCLabelTTF!
    weak var tapToJump: CCLabelTTF!
    
    
    //Buttons
    weak var restartButton: CCButton!
    
    //arrays of CCObjects
    var stars = [CCSprite]()
    var grounds = [CCSprite]()
    
    //Particle System
    var explosion: CCParticleSystem!
    var jump: CCParticleSystem!
    
    //Constants & Variables
    var gameOver: Bool = false
    var asteroidArray: [Asteroid] = []
    var stroidArray: [Stroid] = []
    let firstAsteroidPosition: CGFloat = 280
    let distanceBetweenAsteroids : CGFloat = 300
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    weak var gameEndScreen: GameEnd!
    var asteroidXVelocity = -500
    var randomItemTime: UInt32 = 1 //+ arc4random_uniform(1)
    
    // Tutorial Over
    var tutorialOver = false
    
    // score
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
            if score == 17 {
            schedule("addStroid", interval: 5)
            }
            if score == 30 {
            schedule("addStroid" , interval: 3.5)
            }
            if score == 45 {
            schedule("addStroid", interval: 2)
            }
            if score == 75 {
            schedule("addStroid", interval: 0.8)
            unschedule("addAsteroid")
            }
    
        }
    }
    // Shield PowerUp
    var hasShield: Bool = false
    var shieldTimeRemaining: Double = 0

    //Functions
    func didLoadFromCCB() {
        if VIBRATION == nil {
            VIBRATION = true
        }
        
        iAdHelper.sharedHelper()
        iAdHelper.setBannerPosition(TOP)
        
        iAdHandler.sharedInstance.loadInterstitialAd()
        
        gamePhysicsNode.collisionDelegate = self
        // gamePhysicsNode.debugDraw = true
        userInteractionEnabled = true
        stars.append(star1)
        stars.append(star2)
        ship.physicsBody.affectedByGravity = false
        if gameOver == false {
            gameEndScreen.visible = false
        }
        
    }//didLoad
    
    // User Begins Game by Tapping Screen
    func endTutorial(){
        ship.physicsBody.affectedByGravity = true
        schedule("addAsteroid",  interval: 0.3)
        schedule("addPointToScore", interval: 1)
        //schedule first item
        scheduleOnce("spawnRandomPowerUp", delay: CCTime(randomItemTime))
    }
    
    // Applies impulse to spaceship
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if tutorialOver == false {
            tutorialOver = true
            endTutorial()
        }
        // Load Jump Particle Effect
        var jump = CCBReader.load("Jump")
        jump.zOrder -= 10
        jump.positionInPoints.x = ship.positionInPoints.x
        jump.positionInPoints.y = ship.positionInPoints.y + 10
        gamePhysicsNode.addChild(jump)
       
        ship.jump()
        
        // Ship Effects
        ship.physicsBody.velocity.y = 0
        ship.physicsBody.applyImpulse(ccp(0, 12500))
        
        // plays Jump SoundEffect
        if defaults.boolForKey("musicIsSelected") {
        audio.playEffect("starship-01.wav")
        }
        // tap to jum label invisible
        tapToJump.visible = false
    }
    
    // limit spaceship vertical velocity
    override func update(delta: CCTime) {
        barrier.position.x = ship.position.x
        let velocityY = clampf(Float(ship.physicsBody.velocity.y), -Float(CGFloat.max), 300)
        ship.physicsBody.velocity = ccp(0, CGFloat(velocityY))
        
        
        // scroll stars
        for star in stars {
            if star.position.x <= (-CGFloat(840)) {
                star.position = ccp(star.position.x + CGFloat(840) * 2, star.position.y)
            }
            else {
                if gameOver == false {
                    star.position.x = star.position.x - CGFloat(200) * CGFloat(delta)
                }
            }
        }
        
        // Check if player has a shield, then check to see if the sheild time is up
        if hasShield {
            shieldTimeRemaining -= delta
            if shieldTimeRemaining < 0 {
                hasShield = false
                ship.removeChildByName("Shield")
                
            }
        }
    }
    
    // Add asteroids
    func addAsteroid() {
        // Load Asteroid Image
        var asteroid = CCBReader.load("TestStroid") as! Asteroid
        var random = arc4random_uniform(400)
        asteroid.scale = 0.5
        //add Asteroid to Asteroid array
        asteroidArray.append(asteroid)
        //println(random)
        //asteroid.position = CGPoint(x: ship.position.x + screenWidth + asteroid.contentSizeInPoints.width, y: CGFloat(clampf(Float(random), Float(screenHeight/5), Float(5*screenHeight/5))))
        asteroid.position = CGPoint(x: UIScreen.mainScreen().bounds.width + 1, y: CGFloat(random))
        gamePhysicsNode.addChild(asteroid)
    }
    
    //addStroid (flaming ball of doom)
    func addStroid() {
        //generate asteroid, give it velocity "asteroidXVelocity"
        asteroidXVelocity -= 5
        //generate random
        
        // Load Flaming Ball 
        var newStroid = CCBReader.load("Asteroid3") as! Stroid
        //add Asteroid to Asteroid array
        stroidArray.append(newStroid)
        newStroid.position = CGPoint(x: ship.position.x + screenWidth + newStroid.contentSizeInPoints.width, y: ship.position.y)
        newStroid.scale = 0.5
        gamePhysicsNode.addChild(newStroid)
        newStroid.physicsBody.velocity = ccp(-1000,0)
    }
    // Green Laser Power Up
    func placeBlastPowerUp() {
        var blast = CCBReader.load("Blast") as! Blast
        var random = 20 + arc4random_uniform(231)
        blast.position = CGPoint(x: UIScreen.mainScreen().bounds.width + 1, y: CGFloat(random))
        blast.scale = 0.3
        gamePhysicsNode.addChild(blast)
    }
    // Shield Power Up
    func placeShieldPowerup() {
        var shield = CCBReader.load("Shield") as! Shield
        var random = 20 + arc4random_uniform(231)
        shield.position = CGPoint(x: UIScreen.mainScreen().bounds.width + 1, y: CGFloat(random))
        shield.scale = 0.3
        gamePhysicsNode.addChild(shield)
    }
    // Scoring
    func addPointToScore() {
        score++
    }
    
    // Implement restart button w/ asteroid Collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, stroid nodeB: CCNode!) -> ObjCBool {
        if (gameOver  == false) {
            if !hasShield { // Check if a shield is enabled
                triggerGameOver()
                nodeB.removeFromParent()
                
                if defaults.boolForKey("musicIsSelected") {
                    audio.playEffect("Explosion.aiff")
                }
            }
            else { // If shield is on, simply remove the astroid from the scene and avoid game over
                nodeB.removeFromParent()
                
                shieldTimeRemaining = 0
            }
        }
        return true
    }
    
    // Implement restart button w/ floor Collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, floor nodeB: CCNode!) ->  ObjCBool {
        if (gameOver  == false) {
             triggerGameOver()
            
            if defaults.boolForKey("musicIsSelected") {
                audio.playEffect("Explosion.aiff")
            }
        }
        return true
    }
   
    // Destroys Stroids when leave screen
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, stroid nodeA: CCNode!, stroidNode nodeB: CCNode!) -> ObjCBool {
            nodeA.removeFromParent()
        return true
    }
    
    //Teleport Collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, teleport nodeB: CCNode!) -> ObjCBool {
        return true
    }
    
    // Collision PowerUps
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, bullet: CCNode!, stroid: CCNode!) -> ObjCBool {
        bullet.removeFromParent()
        stroid.removeFromParent()
        return true
    }
    
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, shieldItem: Shield!) -> ObjCBool {
        // Activate shield
        
        shieldTimeRemaining = 3
        hasShield = true
        
        // Load Shield Image
        var shieldSprite = CCBReader.load("ForceField")
        shieldSprite.positionInPoints = ccp(ship.contentSizeInPoints.width / 2, ship.contentSizeInPoints.height / 2)
        shieldSprite.name = "Shield"
        shieldSprite.scale = 0.4
        ship.addChild(shieldSprite)
        shieldItem.removeFromParent()
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, blastItem: CCNode!) -> ObjCBool {
       // Activate BulletsShooting
        self.schedule("shooting", interval: 0.5, repeat: 6, delay: 0)
        blastItem.removeFromParent()
        return false
    }
    
  
//MARK: Power up Functions and Spawning
    func spawnRandomPowerUp() {
        var powerUpTypeRandom = arc4random_uniform(2) + 1
        
        if powerUpTypeRandom == 1 {
            placeBlastPowerUp()
        } else if powerUpTypeRandom == 2 {
            placeShieldPowerup()
        }
        
        randomItemTime = 6 + arc4random_uniform(15)
        scheduleOnce("spawnRandomPowerUp", delay: CCTime(randomItemTime))
    }
    
    // Laser Function
    func shooting() {
        var greenLaser = CCBReader.load("Laser")
        gamePhysicsNode.addChild(greenLaser)
        greenLaser.positionInPoints = ccp(ship.position.x, ship.position.y)
        greenLaser.runAction(CCActionMoveBy(duration: 1, position: CGPoint(x: CCDirector.sharedDirector().viewSize().width, y: greenLaser.position.y)))
       
        
       
    }
    
    // everything that should happen when the game ends
    func triggerGameOver() {
        println("Game Over")
        if (gameOver  == false) {
            
            switch (iAdHandler.sharedInstance.interstitialActionIndex % 3) {
                case 0:
                    iAdHandler.sharedInstance.displayInterstitialAd()
                default:
                    break
            }
            
            iAdHandler.sharedInstance.interstitialActionIndex++
            gameEndScreen.visible = true
            scoreLabel.visible = false
            gameOver = true
            
            // Unschedule Functions
            unschedule("addPointToScore")
            unschedule("addAsteroid")
            unschedule("addStroid")
            unschedule("spawnRandomPowerUp")
            
            // Disable User Interaction
            userInteractionEnabled = false
            ship.physicsBody.allowsRotation = false
            
            // Vibration
            if !VIBRATION {
            AudioServicesPlayAlertSound(1352)
            }
            
            // Explosion Particle Effect
            var explosion = CCBReader.load("Explosion")
            explosion.position = ship.positionInPoints
            ship.explosion()
            addChild(explosion)
        
            // GamoverTimeline
            if animationManager.runningSequenceName != "Gameover Timeline" {
                animationManager.runAnimationsForSequenceNamed("Gameover Timeline")
                gameEndScreen.saveHighScore(score)
            }
            
            // just in case
            ship.stopAllActions()
            
            // Gameover Screen Movement Effect
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 0)))
            let moveBack = CCActionEaseBounceOut(action: move.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
}






