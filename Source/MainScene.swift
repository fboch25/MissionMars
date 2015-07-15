import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    weak var ship: Ship!
    
    //CC Objects
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
    weak var destroyNode: CCNode!
    //Labels
    weak var scoreLabel: CCLabelTTF!
    //Buttons
    weak var restartButton: CCButton!
    //arrays of CCObjects
    var stars = [CCSprite]()
    var grounds = [CCSprite]()
    //Particle System
    var explosion: CCParticleSystem!
    //Constants & Variables
    var gameOver: Bool = false
    var scrollSpeed : CGFloat = 220
    var asteroidArray: [Asteroid] = []
    var stroidArray: [Stroid] = []
    let firstAsteroidPosition: CGFloat = 280
    let distanceBetweenAsteroids : CGFloat = 300
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    weak var gameEndScreen: GameEnd!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    //Functions
    func didLoadFromCCB() {
        
        
        gamePhysicsNode.collisionDelegate = self
       // gamePhysicsNode.debugDraw = true
        userInteractionEnabled = true
        
        
        grounds.append(ground1)
        grounds.append(ground2)
        
        stars.append(star1)
        stars.append(star2)
        
        schedule("addAsteroid",  interval: 1)
        schedule("addPointToScore", interval: 1)
    }//didLoad
    
    // applies impulse to spaceship
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        ship.physicsBody.applyImpulse(ccp(0, 5000))
    }    
    // limit spaceship vertical velocity
    override func update(delta: CCTime) {
        barrier.position.x = ship.position.x
        let velocityY = clampf(Float(ship.physicsBody.velocity.y), -Float(CGFloat.max), 300)
        ship.physicsBody.velocity = ccp(0, CGFloat(velocityY))
        //ship.physicsBody.velocity = ccp(0,0)
        //ship.position = ccp(ship.position.x + scrollSpeed * CGFloat(delta), ship.position.y)
        gamePhysicsNode.position = ccp(0,0)
        
        // loop the ground
        for ground in grounds {
            if ground.position.x <= (-(ground.contentSize.width * CGFloat(ground.scaleX))) {
                ground.position = ccp(ground.position.x + (ground.contentSize.width * CGFloat(ground.scaleX)) * 2, ground.position.y)
            }
            else {
                if !gameOver {
                    ground.physicsBody.velocity.x = 200
                }
            }
            
        }
        
        // scroll stars
        for star in stars {
            if star.position.x <= (-CGFloat(840)) {
                star.position = ccp(star.position.x + CGFloat(840) * 2, star.position.y)
            }
            else {
                if gameOver == false {
                    star.position.x = star.position.x - CGFloat(500) * CGFloat(delta)
                }
            }
        }
        if gameOver == false {
            if arc4random_uniform(100) < 3 {
                addStroid()
            }
        }
//        checkForAsteroidRemoval()
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
        
        var newStroid = CCBReader.load("Stroid") as! Stroid
        //add Asteroid to Asteroid array
        stroidArray.append(newStroid)
        newStroid.position = CGPoint(x: ship.position.x + screenWidth + newStroid.contentSizeInPoints.width, y: ship.position.y)
        newStroid.scale = 0.5
        gamePhysicsNode.addChild(newStroid)
        newStroid.physicsBody.velocity = ccp(-1000,0)
    }
    
    
    
//    func checkForAsteroidRemoval() {
//        
//        
//        for stroid in stroidArray {
//            //check for objects to remove
//            //if you can remove an object, spawn a new one
//            
//            if stroid.position.x <= 0 {
//                stroid.removeFromParent()
////                stroidArray.removeAtIndex(0)
//                
//                // spawn new (flaming ball of doom)
//            }
//        }
//        
//        
//        for asteroid in asteroidArray {
//            //check for objects to remove
//            //if you can remove an object, spawn a new one
//            if asteroid.position.x <= 0 {
//                asteroid.removeFromParent()
////                asteroidArray.removeAtIndex(0)
//            }
//        }
//    }
    
    func addPointToScore() {
        score++
    }
    
    // Implement restart button w/ asteroid
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, stroid nodeB: CCNode!) -> Bool {
        triggerGameOver()
        return true
    }
    
    // Implement restart button w/ floor
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, floor nodeB: CCNode!) -> Bool {
        triggerGameOver()
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, stroid nodeA: CCNode!, destroyNode nodeB: CCNode!) -> Bool {
        return true
    }
    
    // everything that should happen when the game ends
    func triggerGameOver() {
        println("Game Over")
        if (gameOver  == false) {
            gameOver = true
            unschedule("addPointToScore")
            unschedule("addAsteroid")
            scrollSpeed = 0
            userInteractionEnabled = false
            ship.physicsBody.allowsRotation = false
            var explosion = CCBReader.load("Explosion")
            explosion.position = ship.position
            ship.explosion()
            addChild(explosion)
            
           
            
            if animationManager.runningSequenceName != "Gameover Timeline" {
                animationManager.runAnimationsForSequenceNamed("Gameover Timeline")
                
                gameEndScreen.Score(score)
            }
            
            
            // just in case
            ship.stopAllActions()
            
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 4)))
            let moveBack = CCActionEaseBounceOut(action: move.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
}






