//
//  PlayViewController.swift
//  PitchPerfect
//
//  Created by Rafi Khan on 2017/05/31.
//  Copyright © 2017 Rafi Khan. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var stopButton: UIButton!
    
    var audioURL:URL!
    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine! // Will need for special effects.
    var audioFile:AVAudioFile!     // Will need for special effects.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL)
//            try audioFile = AVAudioFile(forReading: audioURL)
//            audioEngine = AVAudioEngine()
            audioPlayer.delegate = self
            audioPlayer.numberOfLoops = 3
        } catch let error as NSError {
            print("AudioPlayer error: \(error.localizedDescription)")
        }
    }
    
    override func viewDidAppear(_ animated:Bool) {
        enableStoppedVisuals()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Stopped")
        if flag {
            enableStoppedVisuals()
        }
    }
    
    // MARK: Actions
    
    @IBAction func playFast(_ sender: UIButton) {
//        playWithSpeed(3.0)
        playAudio()
    }
    
    @IBAction func playSlow(_ sender: UIButton) {
        playWithSpeed(0.5)
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: "backToRecording", sender: sender)
    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        enableStoppedVisuals()
    }
    
    // MARK: Helpers
    func playWithSpeed(_ speed: Float) {
        audioPlayer.stop()
        audioPlayer.enableRate = true
        audioPlayer.rate = speed
        playAudio()
    }
    
    func playAudio() {
        audioPlayer.volume = 1.0
        audioPlayer.currentTime = 0.0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        print("Playing...")
        stopButton.isEnabled = true
    }
    
    func enableStoppedVisuals() {
        stopButton.isEnabled = false
    }
}
