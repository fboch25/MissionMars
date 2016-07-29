//
//  Ship.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Ship: CCSprite {
    
    var invulnerable = false
    
    
    func didLoadFromCCB(){
        spriteFrame = CCSpriteFrame(imageNamed: "Ships/AlienSpaceship.png")
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
     
    }
    
    func explosion() {
        visible = false
        physicsBody.sensor = true
    }
    
    func jump() {
        
    }
    
}
