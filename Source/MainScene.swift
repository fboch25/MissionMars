import Foundation
import AVFoundation
import AudioToolbox 

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    var audio = OALSimpleAudio.sharedInstance()
    let defaults = NSUserDefaults.standardUserDefaults()
    // sound with AVFoundation
    var audioPlayer = AVAudioPlayer()
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
    
    var tutorialOver = false
    
    // score
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
            if score == 17 {
            schedule("addStroid", interval: 5)
            if score == 20 {
            schedule("addStroid" , interval: 3)
            if score == 33 {
            schedule("addStroid", interval: 1.5)
            if score >= 45 {
            schedule("addStroid", interval: 0.8)
            unschedule("addAsteroid")
          }
        }
      }
    }
  }
}

    //Functions
    func didLoadFromCCB() {
        iAdHelper.sharedHelper()
        iAdHelper.setBannerPosition(TOP)
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
    
    func endTutorial(){
        ship.physicsBody.affectedByGravity = true
        schedule("addAsteroid",  interval: 0.3)
        schedule("addPointToScore", interval: 1)
    }
    
    // applies impulse to spaceship
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if tutorialOver == false {
            tutorialOver = true
            endTutorial()
        }
        
        ship.physicsBody.velocity.y = 0
        ship.physicsBody.applyImpulse(ccp(0, 12500))
        if defaults.boolForKey("musicToggleKey") {
        audio.playEffect("starship-01.wav")
        }
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
    }
    
    // Add asteroids
    func addAsteroid() {
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
        //if random is 1, send badAssteroid
        var newStroid = CCBReader.load("Asteroid3") as! Stroid
        //add Asteroid to Asteroid array
        stroidArray.append(newStroid)
        newStroid.position = CGPoint(x: ship.position.x + screenWidth + newStroid.contentSizeInPoints.width, y: ship.position.y)
        newStroid.scale = 0.5
        gamePhysicsNode.addChild(newStroid)
        newStroid.physicsBody.velocity = ccp(-1000,0)
    }    
    // Scoring
    func addPointToScore() {
        score++
    }
    
    // Implement restart button w/ asteroid Collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, stroid nodeB: CCNode!) -> ObjCBool {
        if (gameOver  == false) {
            triggerGameOver()
            nodeB.removeFromParent()
            if defaults.boolForKey("musicToggleKey") {
                audio.playEffect("Explosion.aiff")
            }
            
        }
        return true
    }
    
    // Implement restart button w/ floor Collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, floor nodeB: CCNode!) ->  ObjCBool {
        if (gameOver  == false) {
            triggerGameOver()
            if defaults.boolForKey("musicToggleKey") {
                audio.playEffect("Explosion.aiff")
            }
        }
        return true
    }
    
    // Destroys Stroids when leave screen
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, stroid nodeA: CCNode!, stroidNode nodeB: CCNode!) -> ObjCBool {
//        if (gameOver  == false) {
            nodeA.removeFromParent()
//        }
        return true
    }
    
    // everything that should happen when the game ends
    func triggerGameOver() {
        println("Game Over")
        if (gameOver  == false) {
            gameEndScreen.visible = true
            scoreLabel.visible = false
            gameOver = true
            unschedule("addPointToScore")
            unschedule("addAsteroid")
            userInteractionEnabled = false
            ship.physicsBody.allowsRotation = false
            AudioServicesPlayAlertSound(1352)
            var explosion = CCBReader.load("Explosion")
            explosion.position = ship.position
            ship.explosion()
            addChild(explosion)
            unschedule("addStroid")
            // GamoverTimeline
            if animationManager.runningSequenceName != "Gameover Timeline" {
                animationManager.runAnimationsForSequenceNamed("Gameover Timeline")
                gameEndScreen.Score(score)
            }
            // just in case
//            var positionToMoveTo = ccp()
            
            ship.stopAllActions()
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 0)))
            let moveBack = CCActionEaseBounceOut(action: move.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
}






