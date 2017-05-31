//
//  PlayViewController.swift
//  PitchPerfect
//
//  Created by Rafi Khan on 2017/05/31.
//  Copyright © 2017 Rafi Khan. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController {
    
    @IBOutlet weak var stopButton: UIButton!
    
    var audioURL:URL!
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine! // Will need for special effects.
    var audioFile:AVAudioFile!     // Will need for special effects.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(audioURL)
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL)
//            try audioFile = AVAudioFile(forReading: audioURL)
//            audioEngine = AVAudioEngine()
        } catch let error as NSError {
            print("AudioPlayer error: \(error.localizedDescription)")
        }
    }
    
    override func viewDidAppear(_ animated:Bool) {
        stopAudio()
    }
    
    // MARK: Actions
    
    @IBAction func playFast(_ sender: UIButton) {
        playWithSpeed(3.0)
    }
    
    @IBAction func playSlow(_ sender: UIButton) {
        playWithSpeed(0.5)
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: "backToRecording", sender: sender)
    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
        stopAudio()
    }
    
    // MARK: Helpers
    func playWithSpeed(_ speed: Float) {
        stopAudio()
        audioPlayer.enableRate = true
        audioPlayer.rate = speed
        playAudio()
    }
    
    func playAudio() {
        audioPlayer.currentTime = 0.0
        stopButton.isEnabled = true
        audioPlayer.play()
    }
    
    func stopAudio() {
        stopButton.isEnabled = false
        print(audioPlayer)
        audioPlayer.stop()
    }
}
