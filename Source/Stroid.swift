//
//  Stroid.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Stroid: CCSprite{

    func didLoadFromCCB() {
        self.physicsBody.collisionGroup = "Asteroid"
        physicsBody.velocity = ccp(-100,0)

    }
    
    func updatespeed(){
        position.x += CGFloat(200)
    }
    
     override func update(delta: CCTime) {
        position = ccp(position.x + CGFloat(200) * CGFloat(delta), position.y)
    }
}
