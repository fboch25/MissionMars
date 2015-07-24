//
//  GameEnd.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import GameKit
import AudioToolbox

class GameEnd: CCNode {
    
    weak var pointsLabel : CCLabelTTF!
    weak var highPointsLabel: CCLabelTTF!
    weak var homeButton : CCButton!
    weak var leaderBoardButton: CCButton!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    func saveHighScore(score : Int) {
        pointsLabel.string = "\(score)"
        if GKLocalPlayer.localPlayer().authenticated {
            var scoreReporter = GKScore(leaderboardIdentifier: "MissionMarsSinglePlayerLeaderBoard")
            scoreReporter.value = Int64(score)
            var scoreArray: [GKScore] = [scoreReporter]
            GKScore.reportScores(scoreArray,withCompletionHandler: ( {
                (error : NSError!)-> Void in
                if (error != nil) {
                    println("Error: " + error.localizedDescription);
                }
            } ) )
        }
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
    
    func home() {
        let scene = CCBReader.loadAsScene("Menu")
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    func openLeaderBoard () {
        showLeaderBoard()
    }
    
}

// MARK: Game Center Handling
extension GameEnd: GKGameCenterControllerDelegate {
    
    func showLeaderBoard() {
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    // Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


