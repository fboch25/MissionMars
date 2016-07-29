import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
   
    weak var scoreLabel: CCLabelTTF!
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
        
    }
    weak var ship: Ship!
    var scrollSpeed : CGFloat = 220
    weak var gamePhysicsNode : CCPhysicsNode!
    weak var ground1 : CCSprite!
    weak var ground2 : CCSprite!
    weak var star1 : CCSprite!
    weak var star2 : CCSprite!
    var stars = [CCSprite]()
    var grounds = [CCSprite]()  // initializes an empty array
    // var obstacles : [CCNode] = []
    let firstAsteroidPosition : CGFloat = 280
    let distanceBetweenAsteroids : CGFloat = 100
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    weak var restartButton: CCButton!
    weak var drunk: CCNode!
    var gameOver = false
    
    // makes spaceship go up
    func didLoadFromCCB() {
        
        gamePhysicsNode.collisionDelegate = self
        userInteractionEnabled = true
        grounds.append(ground1)
        grounds.append(ground2)
        stars.append(star1)
        stars.append(star2)
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "addAsteroid", userInfo: nil, repeats: true)
        schedule("addPointToScore", interval: 1)
        

    }
    
    // Implement restart button w/ asteroid
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, stroid nodeB: CCNode!) -> Bool {
        restartButton.visible = true;
        triggerGameOver()
        return true
    }
    // Implement restart button w/ floor
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, floor nodeB: CCNode!) -> Bool {
        restartButton.visible = true;
        triggerGameOver()
        return true
    }
    // restart Game
    func restart() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    func triggerGameOver() {
        if (gameOver == false) {
            gameOver = true
            unschedule("addPointToScore")
            restartButton.visible = true
            scrollSpeed = 0
            ship.rotation = 90
            userInteractionEnabled = false
            ship.physicsBody.allowsRotation = false
            let die = CCBReader.load("DIE") as! Die
            die.position = ship.position
            ship.die()
            addChild(die)
            let defaults = NSUserDefaults.standardUserDefaults()
            let highscore = defaults.integerForKey("highscore")
            if score > highscore {
                defaults.setInteger(score, forKey: "highscore")
            }
            // just in case
            ship.stopAllActions()
            
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 4)))
            let moveBack = CCActionEaseBounceOut(action: move.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
    
    // applies impulse to spaceship
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
            ship.physicsBody.applyImpulse(ccp(0, 5000))

    }
    
    // limit spaceship vertical velocity
    override func update(delta: CCTime) {
        
        drunk.position.x = ship.position.x
        
        let velocityY = clampf(Float(ship.physicsBody.velocity.y), -Float(CGFloat.max), 300)
        ship.physicsBody.velocity = ccp(0, CGFloat(velocityY))
        ship.position = ccp(ship.position.x + scrollSpeed * CGFloat(delta), ship.position.y)
        gamePhysicsNode.position = ccp(gamePhysicsNode.position.x - scrollSpeed * CGFloat(delta),
            gamePhysicsNode.position.y)
        
        // loop the ground whenever a ground image was moved entirely outside the screen
        for ground in grounds {
            let groundWorldPosition = gamePhysicsNode.convertToWorldSpace(ground.position)
            let groundScreenPosition = convertToNodeSpace(groundWorldPosition)
            if groundScreenPosition.x <= (-CGFloat(715)) {
                print(groundScreenPosition)
                print(ground.contentSize.width)
                ground.position = ccp(ground.position.x + CGFloat(715) * 2, ground.position.y)
                
            }
            
        }
        // scroll stars
        for star in stars {
            if star.position.x <= (-CGFloat(840)) {
                print(star.position.x)
                print(star.contentSize.width)
                star.position = ccp(star.position.x + CGFloat(840) * 2, star.position.y)
                
                
            }else {
                if gameOver == false {
                    star.position.x = star.position.x - CGFloat(500) * CGFloat(delta)
                }
            }
            
        }
        
    }
    // Add asteroids
    func addAsteroid() {
        let asteroid = CCBReader.load("Asteroid") as! Asteroid
        let random : CGFloat = CGFloat(arc4random_uniform(UInt32(screenHeight)))
        print(random)
        asteroid.position = CGPoint(x: ship.position.x + screenWidth + asteroid.contentSizeInPoints.width, y: CGFloat(clampf(Float(random), Float(screenHeight/5), Float(5*screenHeight/5))))
        asteroid.scale = 0.5
        if asteroid.position.y > CGFloat(500) {
            let random : CGFloat = CGFloat(arc4random_uniform(300))
            asteroid.position.y -= random
        }
        gamePhysicsNode.addChild(asteroid)
        
        
    }
    
    func addPointToScore() {
        score++
    }
    
}




