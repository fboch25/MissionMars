//
//  Stroid.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Stroid: CCNode {
    func updatespeed(){
        position.x += CGFloat(200)
    }
     override func update(delta: CCTime) {
        position = ccp(position.x + CGFloat(200) * CGFloat(delta), position.y)
    }
}
