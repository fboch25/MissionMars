//
//  Settings.swift
//  MissionMars
//
//  Created by Frank Joseph Boccia on 7/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
var VIBRATION: Bool!
import Foundation

class Settings: CCNode {
    // audio
    let defaults = NSUserDefaults.standardUserDefaults()
    let audio = OALSimpleAudio.sharedInstance()
    // variables
    weak var vibrationToggleButton: CCButton!
    weak var toggleVibrationText: CCLabelTTF!
    weak var musicToggleButton: CCButton!
    weak var toggleMusicText: CCLabelTTF!
    weak var soundEffectsToggleButton: CCButton!
    weak var toggleSoundEffectsText: CCLabelTTF!
    
    // loads setting screen
    func pop(){
        CCDirector.sharedDirector().popScene()
    }
    
    
    func didLoadFromCCB() {
//        VIBRATION = true
        
        //Music Load
        if defaults.boolForKey("musicIsSelected") {
            musicToggleButton.selected = true
            toggleMusicText.string = "MUSIC: ON"
            audio.bgMuted = false
        } else {
            musicToggleButton.selected = false
            toggleMusicText.string = "MUSIC: OFF"
            audio.bgMuted = true
        }
        
        //Sound Load
        if defaults.boolForKey("soundIsSelected") {
            soundEffectsToggleButton.selected = true
            toggleSoundEffectsText.string = "EFFECTS: ON"
            audio.effectsMuted = true
            
        } else {
            soundEffectsToggleButton.selected = false
            toggleSoundEffectsText.string = "EFFECTS: OFF"
            audio.effectsMuted = false
        }
        
        //Vibration Load
        if defaults.boolForKey("vibrationIsSelected") {
            vibrationToggleButton.selected = true
            toggleVibrationText.string = "VIBRATION: ON"
            VIBRATION = true
        } else {
            vibrationToggleButton.selected = false
            toggleVibrationText.string = "VIBRATION: OFF"
            VIBRATION = false
        }
        
        
    }
    // SoundFunctions
    func toggleMusic() {
        
        var currentState = !defaults.boolForKey("musicIsSelected")
        
        if currentState {
            defaults.setBool(true, forKey: "musicIsSelected")
            musicToggleButton.selected = true
            toggleMusicText.string = "MUSIC: OFF"
            audio.bgMuted = true
        } else {
        
            defaults.setBool(false, forKey: "musicIsSelected")
            musicToggleButton.selected = false
            toggleMusicText.string = "MUSIC: ON"
            audio.bgMuted = false
        }
    }
    
    func toggleVibration() {
        
        var vibration = !defaults.boolForKey("vibrationIsSelected")
        
        if vibration {
            defaults.setBool(true, forKey: "vibrationIsSelected")
            vibrationToggleButton.selected = true
            toggleVibrationText.string = "VIBRATION: ON"
            VIBRATION = true
        } else {
            
            defaults.setBool(false, forKey: "vibrationIsSelected")
            vibrationToggleButton.selected = false
            toggleVibrationText.string = "VIBRATION: OFF"
            VIBRATION = false
        }
        
    }
    
    func toggleSoundEffects() {
        
        var soundEffect = !defaults.boolForKey("soundIsSelected")
        
        if soundEffect {
            defaults.setBool(true, forKey: "soundIsSelected")
            soundEffectsToggleButton.selected = true
            toggleSoundEffectsText.string = "EFFECTS: ON"
            audio.effectsMuted = true
            
        } else {
            defaults.setBool(false, forKey: "soundIsSelected")
            soundEffectsToggleButton.selected = false
            toggleSoundEffectsText.string = "EFFECTS: OFF"
            audio.effectsMuted = false
        }
    }
}
