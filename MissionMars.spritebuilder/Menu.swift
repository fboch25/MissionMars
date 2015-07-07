//
//  Menu.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Menu: CCNode {

    var scrollSpeed : CGFloat = 180
    weak var gamePhysicsNode : CCPhysicsNode!
    weak var ground1 : CCSprite!
    weak var ground2 : CCSprite!
    weak var star1 : CCSprite!
    weak var star2 : CCSprite!
    var stars = [CCSprite]()
    var grounds = [CCSprite]()  // initializes an empty array
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        stars.append(star1)
        stars.append(star2)

    }
        // scroll stars
        override func update(delta: CCTime) {
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

}

