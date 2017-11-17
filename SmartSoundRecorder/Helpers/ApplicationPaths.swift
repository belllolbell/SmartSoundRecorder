//
//  ApplicationPaths.swift
//  SmartSoundRecorder
//
//  Created by Kovalenko Sergey on 10/18/17.
//  Copyright © 2017 Sergey Kovalenko. All rights reserved.
//

import UIKit

class ApplicationPaths: NSObject {
    
    static func streamAudioPath() -> String {
        let documentsDirectory = ApplicationPaths.getDocumentsDirectory()
        return documentsDirectory + "/stream.wav"
    }
    
    static func phrasesDirectory() -> String {
        
        let directoryPath = ApplicationPaths.getDocumentsDirectory() + "/phrases/"
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: directoryPath, isDirectory: nil) {
            try! fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: false, attributes: nil)
        }
        
        return directoryPath
    }
    
    static func getDocumentsDirectory() -> String {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return documentsDirectory
    }
}
