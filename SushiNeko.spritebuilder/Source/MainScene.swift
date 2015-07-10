import Foundation

enum Side {
    
    case Left, Right, None
}

enum Gamestate {
    case Title, Ready, Playing, Gameover
}

class MainScene: CCNode {
    
    weak var piecesNode: CCNode!
    var pieces: [Piece] = []
    weak var character: Character!
    var pieceLastSide: Side = .Left
    var pieceIndex: Int = 0
    var gameState: Gamestate = .Title
    weak var restartButton: CCButton?
    weak var lifeBar: CCSprite!
    weak var scoreLabel: CCLabelTTF!
    weak var tapButtons: CCNode!
    var addPiecesPosition: CGPoint?

    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    
    override func onEnter() {
        super.onEnter()
        addPiecesPosition = piecesNode.positionInPoints
    }
    var timeLeft: Float = 5 {
        didSet {
            timeLeft = max(min(timeLeft, 10), 0)
            lifeBar.scaleX = timeLeft / Float(10)
        }
    }

    func addHitPiece(obstacleSide: Side) {
        var flyingPiece = CCBReader.load("Piece") as! Piece
        flyingPiece.position = addPiecesPosition!
        
        var animationName = character.side == .Left ? "FromLeft" : "FromRight"
        flyingPiece.animationManager.runAnimationsForSequenceNamed(animationName)
        flyingPiece.side = obstacleSide
        
        self.addChild(flyingPiece)
    }
   func didLoadFromCCB() {
    
    for i in 0..<10 {
        var piece = CCBReader.load("Piece") as! Piece
        
        var yPos = piece.contentSizeInPoints.height * CGFloat(i)
        piece.position = CGPoint(x: 0, y: yPos)
        piecesNode.addChild(piece)
        pieces.append(piece)
    }
    userInteractionEnabled = true

    
    }
    func ready() {
        gameState = .Ready
        
        self.animationManager.runAnimationsForSequenceNamed("Ready")
        
        tapButtons.cascadeOpacityEnabled = true
        tapButtons.opacity = 0.0
        tapButtons.runAction(CCActionFadeIn(duration: 0.2))
    }
    
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var xTouch = touch.locationInWorld().x
        var screenHalf = self.contentSizeInPoints.width / 2

        if xTouch < screenHalf {
            character.left()
        } else if xTouch > screenHalf{
            character.right()
        }
        if gameState == .Gameover || gameState == .Title { return }
        if gameState == .Ready { start() }
        println(screenHalf)
        println(xTouch)
        if gameState == .Gameover || gameState == .Title { return }
        if gameState == .Ready { start() }
        character.tap()
        stepTower(timeLeft = timeLeft + 0.25)
        if gameState == .Gameover || gameState == .Title { return }
        if gameState == .Ready { start() }
        
        
        score++
    }
    
    
    func start() {
        gameState = .Playing
        
        tapButtons.runAction(CCActionFadeOut(duration: 0.2))
    }
    
    
    override func update(delta: CCTime) {
        if gameState != .Playing { return }
        timeLeft -= Float(delta)
        if timeLeft == 0 {
            triggerGameOver()
        }
    }
    
    func restart() {
        
        var mainScene = CCBReader.load("MainScene") as! MainScene
        mainScene.ready()
        
        var scene = CCScene()
        scene.addChild(mainScene)
        
        var transition = CCTransition(fadeWithDuration: 0.3)
        
        CCDirector.sharedDirector().presentScene(scene, withTransition: transition)
    }
    
    func stepTower() {
        
        var piece = pieces[pieceIndex]
        addHitPiece(piece.side)
        var yDiff = piece.contentSize.height * 10
        piece.position = ccpAdd(piece.position, CGPoint(x: 0, y: yDiff))
        
        piece.zOrder = piece.zOrder + 1
        
        pieceLastSide = piece.setObstacle(pieceLastSide)
        
        piecesNode.position = ccpSub(piecesNode.position,
            CGPoint(x: 0, y: piece.contentSize.height))
        
        pieceIndex = (pieceIndex + 1) % 10
    }
    
    func isGameOver() -> Bool {
        var newPiece = pieces[pieceIndex]
        
        if newPiece.side == character.side { triggerGameOver() }
        
        return gameState == .Gameover
    }
    
    func triggerGameOver() {
        gameState = .Gameover
        restartButton!.visible = true
    }
    

}





