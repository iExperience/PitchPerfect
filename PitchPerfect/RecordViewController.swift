//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Rafi Khan on 2017/05/31.
//  Copyright © 2017 Rafi Khan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordingSession:AVAudioSession!
    var recorder:AVAudioRecorder!
    var audioURL:URL!
    
    // MARK: Delegate methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            
            // Get audio permission and handle error cases.
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Initialized!")
                    } else {
                        // Would send alert to user here.
                        print("Couldn't get recording permissions")
                    }
                }
            }
        } catch {
            // Would also send alert to user here.
            print("Error in creating AudioSession")
        }
    }
    
    override func viewDidAppear(_ animated:Bool) {
        enableVisuals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    Could use delegate here, but decided not to.
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
//                                         successfully flag: Bool) {
//        if (flag) {
//            print("Audio saved")
//            performSegue(withIdentifier: "audioSaved", sender: stopButton)
//        } else {
//            print("Error in recording audio")
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "audioSaved" {
            let playVC:PlayViewController = segue.destination as! PlayViewController
            playVC.audioURL = audioURL // Pass audio file to new view.
        }
    }

    // MARK: Actions
    
    @IBAction func recordAudio(_ sender: UIButton) {
        disableVisuals()
        audioURL = getDocumentsDirectory().appendingPathComponent("recording.wav")

        do {
            recorder = try AVAudioRecorder(url: audioURL, settings: [:])
            recorder.delegate = self
            recorder.prepareToRecord()
            recorder.record()
            print("Recording")
        } catch {
            print("Error recording")
        }
    }
    
    @IBAction func saveAudio(_ sender: UIButton) {
        enableVisuals()
        recorder.stop()
        performSegue(withIdentifier: "audioSaved", sender: sender)
    }
    
    @IBAction func unwindToRecordVC(segue:UIStoryboardSegue) { }
    
    // MARK: Helpers
    
    func disableVisuals() {
        recordButton.isEnabled = false
        recordButton.alpha = 0.5
        stopButton.isEnabled = true
        stopButton.alpha = 1.0
    }
    
    func enableVisuals() {
        recordButton.isEnabled = true
        recordButton.alpha = 1.0
        stopButton.isEnabled = false
        stopButton.alpha = 0.5
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

