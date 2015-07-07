import Foundation

class MainScene: CCNode {
    
    weak var ship: CCSprite!
    var scrollSpeed : CGFloat = 180
    weak var gamePhysicsNode : CCPhysicsNode!
    weak var ground1 : CCSprite!
    weak var ground2 : CCSprite!
    weak var star1 : CCSprite!
    weak var star2 : CCSprite!
    var stars = [CCSprite]()
    var grounds = [CCSprite]()  // initializes an empty array
    var obstacles : [CCNode] = []
    let firstObstaclePosition : CGFloat = 280
    let distanceBetweenObstacles : CGFloat = 160
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    // makes spaceship go up
    func didLoadFromCCB() {
        
        userInteractionEnabled = true
        grounds.append(ground1)
        grounds.append(ground2)
        stars.append(star1)
        stars.append(star2)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "addAsteroid", userInfo: nil, repeats: true)
            }
    
    // applies impulse to spaceship
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if ship.position.y < boundingBox().height - CGFloat(28){
        ship.physicsBody.applyImpulse(ccp(0, 4000))
        }
    }
    
    // limit spaceship vertical velocity
    override func update(delta: CCTime) {
        let velocityY = clampf(Float(ship.physicsBody.velocity.y), -Float(CGFloat.max), 200)
        ship.physicsBody.velocity = ccp(0, CGFloat(velocityY))
        ship.position = ccp(ship.position.x + scrollSpeed * CGFloat(delta), ship.position.y)
        gamePhysicsNode.position = ccp(gamePhysicsNode.position.x - scrollSpeed * CGFloat(delta),
        gamePhysicsNode.position.y)
       
    // loop the ground whenever a ground image was moved entirely outside the screen
    for ground in grounds {
        let groundWorldPosition = gamePhysicsNode.convertToWorldSpace(ground.position)
        let groundScreenPosition = convertToNodeSpace(groundWorldPosition)
        if groundScreenPosition.x <= (-CGFloat(715)) {
            println(groundScreenPosition)
            println(ground.contentSize.width)
            ground.position = ccp(ground.position.x + CGFloat(715) * 2, ground.position.y)
            }
        
        }
        // scroll stars
        for star in stars {
            if star.position.x <= (-CGFloat(840)) {
                println(star.position.x)
                println(star.contentSize.width)
                star.position = ccp(star.position.x + CGFloat(840) * 2, star.position.y)

        
            }else {
                star.position.x = star.position.x - CGFloat(500) * CGFloat(delta)
            }
            
        }
        
    }
    // Add asteroids
    func addAsteroid() {
        var asteroid = CCBReader.load("Asteroid") as! Asteroid
        var random : CGFloat = CGFloat(arc4random_uniform(700))
        asteroid.position = CGPoint(x: self.contentSize.width + CGFloat(300) + ship.position.x + random, y: random)
        asteroid.scale = 0.5
        gamePhysicsNode.addChild(asteroid)
        
        
    }

}
    

    

