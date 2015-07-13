//
//  GameEnd.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class GameEnd: CCNode {
    
    weak var pointsLabel : CCLabelTTF!
    weak var highPointsLabel: CCLabelTTF!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func Score(score : Int) {
        pointsLabel.string = "\(score)"
        
        var currentHighscore = defaults.integerForKey("highScore")
        
        if score > currentHighscore {
            defaults.setInteger(score, forKey: "highScore")
        }
        
        highPointsLabel.string = "\(currentHighscore)"
        
    }
    
    
    // restart Game
    func restart() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(scene)
        
    }
    

}
