import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {

    /*
        To do:
        Remove asteroids from memory when they leave screen
        Rename "drunk"
        Rename "DIE" (also, it's just a particle system. doesn't need to have it's own .swift file)
        Separate mainScene and Gameplay scenes
        Fix creation of asteroids
            don't use a scheduler, have this be done in the update method
        Fix random deaths
            probably a physics issue
    */
    
    
    
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
    weak var drunk: CCNode!
    weak var gameEnd : CCNode!
    //Labels
    weak var scoreLabel: CCLabelTTF!
    //Buttons
    weak var restartButton: CCButton!
    //arrays of CCObjects
    var stars = [CCSprite]()
    var grounds = [CCSprite]()
    // var obstacles : [CCNode] = []
    
    //Constants & Variables
    var gameOver = false
    var scrollSpeed : CGFloat = 220
    var gameIsPlaying = true
    let firstAsteroidPosition : CGFloat = 280
    let distanceBetweenAsteroids : CGFloat = 100
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
        
    }
    
    //Functions
    func didLoadFromCCB() {
        
        gamePhysicsNode.collisionDelegate = self
        userInteractionEnabled = true
        
        grounds.append(ground1)
        grounds.append(ground2)
        
        stars.append(star1)
        stars.append(star2)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "addAsteroid", userInfo: nil, repeats: true)
        schedule("addPointToScore", interval: 1)
        schedule("addStroid", interval: 3)
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
        gamePhysicsNode.position = ccp(gamePhysicsNode.position.x - scrollSpeed * CGFloat(delta), gamePhysicsNode.position.y)
        
        // loop the ground whenever a ground image was moved entirely outside the screen
        for ground in grounds {
            let groundWorldPosition = gamePhysicsNode.convertToWorldSpace(ground.position)
            let groundScreenPosition = convertToNodeSpace(groundWorldPosition)
            if groundScreenPosition.x <= (-CGFloat(715)) {
                ground.position = ccp(ground.position.x + CGFloat(715) * 2, ground.position.y)
            }
            
        }
        
        // scroll stars
        for star in stars {
            if star.position.x <= (-CGFloat(840)) {
                //println(star.position.x)
                //println(star.contentSize.width)
                star.position = ccp(star.position.x + CGFloat(840) * 2, star.position.y)
            } else {
                if gameOver == false {
                    star.position.x = star.position.x - CGFloat(500) * CGFloat(delta)
                }
            }
        }
        
    }
    
    // Add asteroids
    func addAsteroid() {
        var asteroid = CCBReader.load("Asteroid") as! Asteroid
        var random : CGFloat = CGFloat(arc4random_uniform(UInt32(screenHeight)))
        //println(random)
        asteroid.position = CGPoint(x: ship.position.x + screenWidth + asteroid.contentSizeInPoints.width, y: CGFloat(clampf(Float(random), Float(screenHeight/5), Float(5*screenHeight/5))))
        asteroid.scale = 0.5
        if asteroid.position.y > CGFloat(500) {
            var random : CGFloat = CGFloat(arc4random_uniform(300))
            asteroid.position.y -= random
        }
        gamePhysicsNode.addChild(asteroid)
        
        
    }
    
    //addStroid (flaming ball of doom)
    func addStroid() {
        if gameIsPlaying  {
        var asteroid = CCBReader.load("Stroid") as! Stroid
        asteroid.position = CGPoint(x: ship.position.x + screenWidth + asteroid.contentSizeInPoints.width, y: ship.position.y)
        asteroid.scale = 0.5
        
        gamePhysicsNode.addChild(asteroid)
        //        asteroid.physicsBody.velocity = ccp(-200, 0)
        asteroid.physicsBody.velocity = ccp(-1000,0)
        }
            
        //println("stroid added")
        
        //        var red = CCBReader.load("Stroid") as! Stroid
        //        red.physicsBody.sensor = true
        //        var random : CGFloat = CGFloat(arc4random_uniform(UInt32(screenHeight)))
        //        println(random)
        //        red.position = CGPoint(x: ship.position.x + screenWidth + red.contentSizeInPoints.width, y: ship.position.y)
        //        red.scale = 0.5
        //        if red.position.y > CGFloat(500) {
        //            var random : CGFloat = CGFloat(arc4random_uniform(300))
        //            red.position.y -= random
        //        }
        //        gamePhysicsNode.addChild(red)
        //        if red.position.x < screenWidth {
        //            red.physicsBody.applyImpulse(ccp(-100000,0))
        //        }
    }
    
    
    func addPointToScore() {
        score++
    }
    
    // Implement restart button w/ asteroid
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, stroid nodeB: CCNode!) -> Bool {
        //restartButton.visible = true;
        triggerGameOver()
        return true
    }
    
    // Implement restart button w/ floor
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ship nodeA: CCNode!, floor nodeB: CCNode!) -> Bool {
        //restartButton.visible = true;
        triggerGameOver()
        return true
    }
    
    // restart Game
    func restart() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(scene)
        
        if animationManager.runningSequenceName != "Gameover Timeline" {
            animationManager.runAnimationsForSequenceNamed("Gameover Timeline")
        }
    }
    
    // everything that should happen when the game ends
    func triggerGameOver() {
        println("Game Over")
        if (gameOver == false) {
            gameOver = true
            unschedule("addPointToScore")
            // restartButton.visible = true
            
            scrollSpeed = 0
            ship.rotation = 90
            userInteractionEnabled = false
            ship.physicsBody.allowsRotation = false
            
            var die = CCBReader.load("DIE") as! Die
            die.position = ship.position
            ship.die()
            addChild(die)
            
            gameIsPlaying = false
        
            let defaults = NSUserDefaults.standardUserDefaults()
            var highscore = defaults.integerForKey("highscore")
            
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
    
}






