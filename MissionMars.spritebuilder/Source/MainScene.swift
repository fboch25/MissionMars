import Foundation

class MainScene: CCNode {
    weak var ship: CCSprite!
    var scrollSpeed : CGFloat = 160
    weak var gamePhysicsNode : CCPhysicsNode!
    weak var ground1 : CCSprite!
    weak var ground2 : CCSprite!
    var grounds = [CCSprite]()  // initializes an empty array
    var obstacles : [CCNode] = []
    let firstObstaclePosition : CGFloat = 280
    let distanceBetweenObstacles : CGFloat = 160
    
    // makes spaceship go up
    func didLoadFromCCB() {
        
        userInteractionEnabled = true
        grounds.append(ground1)
        grounds.append(ground2)
            }
    
    // applies impulse to spaceship
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        ship.physicsBody.applyImpulse(ccp(0, 4000))
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
        if groundScreenPosition.x <= (-ground.contentSize.width) {
            ground.position = ccp(ground.position.x + ground.contentSize.width * 1, ground.position.y)
            }
        
        }
        
    }
}
    

    

