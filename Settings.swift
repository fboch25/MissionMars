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
    weak var vibrationToggleButton: CCButton!
    weak var toggleVibrationText: CCLabelTTF!
    weak var musicToggleButton: CCButton!
    weak var toggleMusicText: CCLabelTTF!
    weak var soundEffectsToggleButton: CCButton!
    weak var toggleSoundEffectsText: CCLabelTTF!
    
    func didLoadFromCCB() {
        if defaults.boolForKey("musicToggleKey") {
            musicToggleButton.selected = false
            toggleMusicText.string = "SOUND ON"
        }
        vibrationToggleButton.selected = false
        toggleVibrationText.string = "VIBRATION ON"
        
        soundEffectsToggleButton.selected = false
        toggleSoundEffectsText.string = "EFFECTS ON"
    }
    
    func pop(){
        CCDirector.sharedDirector().popScene()
    }
    
    func toggleMusic() {
        
        var currentState = defaults.boolForKey("musicToggleKey")
        
        if currentState {
            defaults.setBool(false, forKey: "musicToggleKey")
            musicToggleButton.selected = false
            toggleMusicText.string = "MUSIC OFF"
            audio.stopEverything()
        }
        else {
            defaults.setBool(true, forKey: "musicToggleKey")
            toggleMusicText.string = "MUSIC ON"
        }
    }
    
    func toggleVibration() {
        
        if vibrationToggleButton.selected == true {
            toggleVibrationText.string = "VIBRATION ON"
            vibrationToggleButton.selected = false
        }
        else if vibrationToggleButton.selected == false {
            toggleVibrationText.string = "VIBRATION OFF"
            vibrationToggleButton.selected = true
        }

    }
    
    func toggleSoundEffects() {
        if soundEffectsToggleButton.selected == true {
            toggleSoundEffectsText.string = "EFFECTS ON"
            soundEffectsToggleButton.selected = false
        }
        else if soundEffectsToggleButton.selected == false {
            toggleSoundEffectsText.string = "EFFECTS OFF"
            soundEffectsToggleButton.selected = true
        }
    }
}
