//
//  AudioPlayer.swift
//  SmartSoundRecorder
//
//  Created by Kovalenko Sergey on 10/18/17.
//  Copyright © 2017 Sergey Kovalenko. All rights reserved.
//

import UIKit

protocol AudioPlayerDelegate {
    func recordFinished(successfully:Bool)
}

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    static let shared = AudioPlayer()
    
    var delegate:AudioPlayerDelegate?
    private var player: AVAudioPlayer?
    
    func play(phrase: Phrase) {
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        let url = phrase.filePath
        
        if url.absoluteString.isEmpty {
            return
        }
        
        try! self.player = AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.prepareToPlay()
        player?.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        delegate?.recordFinished(successfully: flag)
        self.player = nil
    }
}
