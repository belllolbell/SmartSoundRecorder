//
//  AudioManager.swift
//  SmartSoundRecorder
//
//  Created by Kovalenko Sergey on 11/16/17.
//  Copyright © 2017 Sergey Kovalenko. All rights reserved.
//

import UIKit

struct Phrase {
    let name: String
    let filePath: URL
}

protocol AudioManagerDelegate {
    func phraseRecorded()
}

class AudioManager: NSObject, EZMicrophoneDelegate {
    
    static let shared = AudioManager()
    
    var delegate:AudioManagerDelegate?
    var recording = false
    var chartDataCallback: ((UnsafeMutablePointer<Float>?, UInt32) -> ())!
    var phrases: [Phrase] = []
 
    private var missedThreshold = 0
    
    private let recognitionStartThreshold: Float = 3
    private let recognitionContinueThreshold: Float = 2
    private let allowedInterval = 20
    private let phrasesDirectory = ApplicationPaths.phrasesDirectory()
    
    private lazy var microphone = EZMicrophone(delegate: self, startsImmediately: false)!
    private var phraseRecording: AudioRecorder!
    private var mainRecording: AudioRecorder!
    
    func startListener() {
        microphone.startFetchingAudio()
    }
    
    func pauseListener() {
        microphone.stopFetchingAudio()
    }
    
    func startMainRecording() {
        let url = URL(fileURLWithPath: ApplicationPaths.streamAudioPath())
        
        mainRecording = AudioRecorder(name: "Main", fileURL: url)
        mainRecording.record()
    }
    
    func stopMainRecording() {
        mainRecording.stop()
    }
    
    func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
        var averageValue: Float = 0.0
        var count = 0
        
        for subArray in UnsafeBufferPointer(start: buffer, count: Int(numberOfChannels)) {
            
            chartDataCallback(subArray, bufferSize)
            for v in UnsafeBufferPointer(start: subArray, count: Int(bufferSize)) {
                
                averageValue += v
                count += 1
            }
        }
        
        if !recording {
           return
        }
        
        if abs(averageValue) >= recognitionStartThreshold && phraseRecording == nil {
            
            let phraseNumber = phrases.count + 1
            let name = "Phrase #\(phraseNumber)"
            let path = phrasesDirectory + "phrase_\(phraseNumber).wav"
            let url = URL(fileURLWithPath: path)
            
            phraseRecording = AudioRecorder(name: name, fileURL: url)
            phraseRecording.record()
            
            missedThreshold = 0
        } else if abs(averageValue) < recognitionContinueThreshold && phraseRecording != nil {
            
            missedThreshold += 1
            if missedThreshold >= allowedInterval {
                
                let phrase = Phrase(name: phraseRecording.name, filePath: phraseRecording.fileURL)
                phrases.append(phrase)
                
                phraseRecording.stop()
                phraseRecording = nil
                
                DispatchQueue.main.async {
                    self.delegate?.phraseRecorded()
                }
            }
        } else if abs(averageValue) >= recognitionContinueThreshold && phraseRecording != nil {
            missedThreshold = 0
        }
    }
}
