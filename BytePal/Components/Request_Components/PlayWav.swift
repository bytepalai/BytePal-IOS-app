//
//  PlayWav.swift
//  BytePal
//
//  Created by Paul Ngouchet on 8/24/20.
// Copyright © 2020 BytePal AI, LLC. All rights reserved.
//

import AVFoundation

// Standalone Class to Play .wav files after they are received from the BytePal Server when interacting with the agent
class Sounds {
    
    static var audioPlayer:AVAudioPlayer?
    
    static func playSounds(soundfile: String) {
        
        //if let path = Bundle.main.path(forResource: soundfile, ofType: nil){
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundfile))
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
        }
        catch {
            print("Error")
        }
        
    }
   
}
