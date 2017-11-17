//
//  RecordSoundManager.swift
//  SmartSoundRecorder
//
//  Created by Kovalenko Sergey on 10/18/17.
//  Copyright © 2017 Sergey Kovalenko. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecorder: NSObject {
    
    let name: String
    let fileURL: URL
    
    private var audioRecorder: AVAudioRecorder?
    
    required init(name:String, fileURL:URL) {
        self.fileURL = fileURL
        self.name = name
    }
    
    func record() {
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        let audioSettings = [
            AVFormatIDKey:kAudioFormatLinearPCM,
            AVSampleRateKey:16000,
            AVNumberOfChannelsKey:1,
            ]
        
        if audioRecorder == nil {
            do {
                audioRecorder = try AVAudioRecorder(url: fileURL, settings: audioSettings)
                audioRecorder!.isMeteringEnabled = true
                audioRecorder!.prepareToRecord()
                audioRecorder!.record()
              
                NotificationCenter.default.addObserver(self, selector: #selector(self.onAudioSessionInterruption(notification:)),name: .AVAudioSessionInterruption, object: nil)
            } catch {
            }
        } else {
            audioRecorder!.stop()
            audioRecorder = nil
            
            NotificationCenter.default.removeObserver(self, name: .AVAudioSessionInterruption, object: nil)
        }
    }
    
    func stop() {
        audioRecorder?.stop()
        
        NotificationCenter.default.removeObserver(self, name: .AVAudioSessionInterruption, object: nil)
    }
    
    @objc private func onAudioSessionInterruption(notification: Notification) {
        
        let interruptionType = notification.userInfo![AVAudioSessionInterruptionTypeKey]! as! NSNumber
        if interruptionType.intValue == 1 {
            self.audioRecorder?.pause()
        } else {
            self.audioRecorder?.record()
        }
    }
}
