//
//  ViewController.swift
//  SmartSoundRecorder
//
//  Created by Kovalenko Sergey on 10/18/17.
//  Copyright © 2017 Sergey Kovalenko. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    let recordManager = RecordSoundManager.sharedManager
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: Screen Actions
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        
        recordManager.delegate = self
        recordManager.record()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        PlaySoundManager.sharedManager.playTrimmedAudio()
    }
}

extension RecordViewController:RecordSoundManagerDelegate {
    
    func recordStarted(successfully: Bool) {
        
        if successfully {
            recordButton.setTitle(NSLocalizedString("Stop", comment: "Record button in recording state"), for: .normal)
        }
    }
    
    func recordFinished(successfully: Bool) {
        
        recordButton.setTitle(NSLocalizedString("Record", comment: "Record button in inactive state"), for: .normal)
    }
}

