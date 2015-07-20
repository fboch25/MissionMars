//
//  Settings.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Settings: CCNode {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let audio = OALSimpleAudio.sharedInstance()
    
    weak var musicToggleButton: CCButton!
    weak var toggleMusicText: CCLabelTTF!
    
    func didLoadFromCCB() {
        if defaults.boolForKey("musicToggleKey") {
            musicToggleButton.selected = true
            toggleMusicText.string = "SOUND ON"
        }
    }
    
    func pop(){
        CCDirector.sharedDirector().popScene()
    }
    
    func toggleMusic() {
        
        var currentState = defaults.boolForKey("musicToggleKey")
        
        if currentState {
            defaults.setBool(false, forKey: "musicToggleKey")
            toggleMusicText.string = "SOUND OFF"
            audio.stopEverything()
        }
        else {
            defaults.setBool(true, forKey: "musicToggleKey")
            toggleMusicText.string = "SOUND ON"
        }
    }
}