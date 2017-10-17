//
//  RecordSoundManager.swift
//  SmartSoundRecorder
//
//  Created by Kovalenko Sergey on 10/18/17.
//  Copyright © 2017 Sergey Kovalenko. All rights reserved.
//

import UIKit
import AVFoundation

protocol RecordSoundManagerDelegate {
    func recordStarted(successfully:Bool)
    func recordFinished(successfully:Bool)
}

class RecordSoundManager: NSObject {
    
    static let sharedManager = RecordSoundManager()
    
    var delegate:RecordSoundManagerDelegate?
    
    private var audioRecorder: AVAudioRecorder!
    private var recordingSession = AVAudioSession.sharedInstance()
    private var audioFilePath:URL!
    private var audioSettings:[String : Any]!
    
    override init() {
        super.init()
        
        let documentsDirectory = ApplicationPaths.getDocumentsDirectory()
        audioFilePath = documentsDirectory.appendingPathComponent("recording.m4a")
        
        audioSettings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    func record() {
        
        if audioRecorder.isRecording {
            do {
                audioRecorder = try AVAudioRecorder(url: audioFilePath, settings: audioSettings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                delegate?.recordStarted(successfully: true)
            } catch {
                delegate?.recordStarted(successfully: false)
            }
        } else {
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
}

extension RecordSoundManager:AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        delegate?.recordFinished(successfully: flag)
    }
}
