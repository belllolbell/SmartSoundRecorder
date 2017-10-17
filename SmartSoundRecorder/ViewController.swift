//
//  ViewController.swift
//  SmartSoundRecorder
//
//  Created by Kovalenko Sergey on 10/18/17.
//  Copyright © 2017 Sergey Kovalenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func recordButtonPressed(_ sender: Any) {
        
        let recordManager = RecordSoundManager.sharedManager
        recordManager.delegate = self
        recordManager.record()
    }
}

extension ViewController:RecordSoundManagerDelegate {
    
    func recordStarted(successfully: Bool) {
        
        if successfully {
            recordButton.setTitle(NSLocalizedString("Stop", comment: "Record button in recording state"), for: .normal)
        }
    }
    
    func recordFinished(successfully: Bool) {
        
        recordButton.setTitle(NSLocalizedString("Record", comment: "Record button in inactive state"), for: .normal)
    }
}

