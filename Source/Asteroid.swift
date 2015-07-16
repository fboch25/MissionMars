//
//  Asteroid.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Asteroid: CCSprite {
   
    func didLoadFromCCB(){
        self.physicsBody.collisionGroup = "Asteroid"
        physicsBody.velocity = ccp(-500,0)
    }
    
}
