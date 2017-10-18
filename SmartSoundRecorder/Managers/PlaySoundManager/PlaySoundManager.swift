//
//  PlaySoundManager.swift
//  SmartSoundRecorder
//
//  Created by Kovalenko Sergey on 10/18/17.
//  Copyright © 2017 Sergey Kovalenko. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundManager: NSObject {

    static let sharedManager = PlaySoundManager()
    
    private var soundPlayer: AVAudioPlayer!
    
    func playTrimmedAudio() {
        
        let url = ApplicationPaths.trimmedAudioPath()
        
        if url.absoluteString.isEmpty {
            return
        }
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)

        soundPlayer = try! AVAudioPlayer(contentsOf: url)
        soundPlayer.prepareToPlay()
        soundPlayer.play()
    }
}
