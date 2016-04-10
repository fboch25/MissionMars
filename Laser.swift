//
//  Laser.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 8/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Laser : CCSprite {
    
    func didLoadFromCCB () {
        
    }
    override func update (delta: CCTime) {
        
        if self.position.x > CCDirector.sharedDirector().viewSize().width {
            self.removeFromParent()
        }
        
    }
}