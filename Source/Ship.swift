//
//  Ship.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Ship: CCSprite {
    
    weak var ship: CCSprite!
    var invulnerable = false 
    
    func didLoadFromCCB(){
        //spriteFrame = CCSpriteFrame(imageNamed: "Ships/PinkSpaceship.png")
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
     
    }
    
    func explosion() {
        ship.visible = false
        ship.physicsBody.sensor = true
    }
    
    func jump() {
        
    }
    
}
