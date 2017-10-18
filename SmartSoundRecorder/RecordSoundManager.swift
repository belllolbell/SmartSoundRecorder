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
    
    private var audioRecorder: AVAudioRecorder?
    private var trimmedAudioRecorder: AVAudioRecorder?
    private var recordingSession = AVAudioSession.sharedInstance()
    private var fullAudioFilePath:URL!
    private var audioFilePath:URL!
    private var levelTimer = Timer()
    private var audioSettings:[String : Any]!
    
    override init() {
        super.init()
        
        //where we will save files
        let documentsDirectory = ApplicationPaths.getDocumentsDirectory()
        fullAudioFilePath = documentsDirectory.appendingPathComponent("full_audio.wav")
        audioFilePath = documentsDirectory.appendingPathComponent("trimmed_audio.wav")
        
        audioSettings = [
            AVFormatIDKey:Int(kAudioFormatLinearPCM),
            AVSampleRateKey:44100.0,
            AVNumberOfChannelsKey:1,
            AVLinearPCMBitDepthKey:8,
            AVLinearPCMIsFloatKey:false,
            AVLinearPCMIsBigEndianKey:false,
            AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue
        ]
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryRecord)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print ("allowed")
                    } else {
                        print ("failed to record")
                    }
                }
            }
        } catch {
            print ("failed to record catch")
        }
    }
    
    func record() {
        
        if audioRecorder == nil {
            do {
                audioRecorder = try AVAudioRecorder(url: fullAudioFilePath, settings: audioSettings)
                audioRecorder!.isMeteringEnabled = true
                audioRecorder!.delegate = self
                audioRecorder!.updateMeters()
                audioRecorder!.prepareToRecord()
                audioRecorder!.record()
              
                trimmedAudioRecorder = try AVAudioRecorder(url: audioFilePath, settings: audioSettings)
                trimmedAudioRecorder!.prepareToRecord()
                
                self.levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
                
                delegate?.recordStarted(successfully: true)
            } catch {
                delegate?.recordStarted(successfully: false)
            }
        } else {
            audioRecorder!.stop()
            audioRecorder = nil
        }
    }
    
    //This selector/function is called every time our timer (levelTime) fires
    @objc private func levelTimerCallback() {
        //we have to update meters before we can get the metering values
        if let recorder = audioRecorder {
            recorder.updateMeters()
            
            if recorder.averagePower(forChannel: 0) > -27 {
                print(recorder.averagePower(forChannel: 0))
                trimmedAudioRecorder!.record()
            } else {
                trimmedAudioRecorder!.pause()
            }
            
            print(recorder.averagePower(forChannel: 0))
        }
    }
}

extension RecordSoundManager:AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        delegate?.recordFinished(successfully: flag)
    }
}
