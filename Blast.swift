//
//  Blast.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Blast: CCSprite {
    
    func didLoadFromCCB() {
        physicsBody.velocity = ccp(-250,0)
        physicsBody.sensor = true
    }
    
}