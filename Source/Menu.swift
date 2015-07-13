//
//  Menu.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Menu: CCScene {

    var scrollSpeed : CGFloat = 180
    weak var gamePhysicsNode : CCPhysicsNode!
    weak var ground1 : CCSprite!
    weak var ground2 : CCSprite!
    weak var comet : CCSprite!
    weak var flame: CCParticleSystem!
    weak var star1 : CCSprite!
    weak var star2 : CCSprite!
    weak var gamePhysicNode: CCPhysicsNode!
    var stars = [CCSprite]()
    var grounds = [CCSprite]()  // initializes an empty array
    
    func didLoadFromCCB() {
        gamePhysicsNode.debugDraw = true
        userInteractionEnabled = true
        stars.append(star1)
        stars.append(star2)
        moveComet()
        
    }
    override func update(delta: CCTime) {
        if comet.position.x > gamePhysicsNode.contentSizeInPoints.width {
            comet.position.x = 0
            moveComet()
        }
    }
    // scroll stars

    func play(){
        CCDirector.sharedDirector().replaceScene(CCBReader.loadAsScene("MainScene"))
        
    }
    
    func moveComet() {
        comet.physicsBody.velocity = (ccp(-1000,90))
        
        
    }
    
}

