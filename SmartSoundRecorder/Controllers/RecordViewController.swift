//
//  ViewController.swift
//  SmartSoundRecorder
//
//  Created by Kovalenko Sergey on 10/18/17.
//  Copyright © 2017 Sergey Kovalenko. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, AudioPlayerDelegate, AudioManagerDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var audioPlot: EZAudioPlot!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePlot()
        
        tableView.tableFooterView = UIView()
        
        AudioManager.shared.delegate = self
        AudioPlayer.shared.delegate = self
    }
    
    private func configurePlot() {
        self.audioPlot.plotType = .rolling
        self.audioPlot.gain = 10.0
        
        AudioManager.shared.chartDataCallback = { [unowned self] buffer, bufferSize in
            self.audioPlot.updateBuffer(buffer, withBufferSize: bufferSize)
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        
        if AudioManager.shared.recording {
            
            AudioManager.shared.pauseListener()
            AudioManager.shared.stopMainRecording()
            recordButton.setTitle(NSLocalizedString("Record", comment: "Record button in inactive state"), for: .normal)
            
        } else {
            
            AudioManager.shared.startListener()
            AudioManager.shared.startMainRecording()
            recordButton.setTitle(NSLocalizedString("Stop", comment: "Record button in recording state"), for: .normal)
            self.audioPlot.clear()
        }
        
        AudioManager.shared.recording = !AudioManager.shared.recording
    }
    
    //MARK: AudioRecorderDelegate
    
    func phraseRecorded() {
        let indexPath = IndexPath(row: AudioManager.shared.phrases.count - 1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    //MARK: AudioPlayerDelegate
    
    func recordFinished(successfully: Bool) {
        tableView.reloadData()
    }
}

extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AudioManager.shared.phrases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PhraseTableViewCell.reuseID, for: indexPath) as! PhraseTableViewCell
        
        let phrase = AudioManager.shared.phrases[indexPath.row]
        cell.phraseLabel.text = phrase.name
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let phrase = AudioManager.shared.phrases[indexPath.row]
        AudioPlayer.shared.play(phrase: phrase)
    }
}

