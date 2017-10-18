//
//  ApplicationPaths.swift
//  SmartSoundRecorder
//
//  Created by Kovalenko Sergey on 10/18/17.
//  Copyright © 2017 Sergey Kovalenko. All rights reserved.
//

import UIKit

class ApplicationPaths: NSObject {
    
    static func fullAudioPath() -> URL {
        let documentsDirectory = ApplicationPaths.getDocumentsDirectory()
        return documentsDirectory.appendingPathComponent("full_audio.wav")
    }
    
    static func trimmedAudioPath() -> URL {
        let documentsDirectory = ApplicationPaths.getDocumentsDirectory()
        return documentsDirectory.appendingPathComponent("trimmed_audio.wav")
    }
    
    static func getDocumentsDirectory() -> URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return URL.init(fileURLWithPath:documentsDirectory)
    }
}
