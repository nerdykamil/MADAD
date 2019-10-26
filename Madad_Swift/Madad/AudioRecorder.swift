//
//  AudioRecorder.swift
//  LookOut
//
//  Created by Hagar Hussein on 10/25/19.
//  Copyright © 2019 Qatar. All rights reserved.
//

import Foundation
import UIKit

import AVFoundation


class AudioRecorder: NSObject {
    
    
    
    var recordingSession: AVAudioSession?
    
    var audioRecorder: AVAudioRecorder!
    var meterTimer: Timer?
    var recorderApc0: Float = 0
    var recorderPeak0: Float = 0
    var player: AVAudioPlayer?
    var savedFileURL: URL?
    
    
    
    func setup() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
            recordingSession?.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Mic Authorised")
                        
                    } else {
                        print("Mic not Authorised")
                    }
                }}
        } catch {
            print("Failed to set Category", error.localizedDescription)
        }
    }
    ///////// record wav file
    func record(fileName: String) -> Bool {
        setup()
        
        let recordingName = (fileName).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
       
        let filePath = getUserPath().appendingPathComponent(recordingName)
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            
            
            try session.setCategory(AVAudioSession.Category.playAndRecord, options:AVAudioSession.CategoryOptions.defaultToSpeaker)

            try audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            savedFileURL = filePath
            

            
            print("Recording")
            return true
        } catch {
            print("Error Handling", error.localizedDescription)
            return false
        }
    }
    
    func getUserPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    
    
    func finishRecording() -> String {
        audioRecorder?.stop()
        self.meterTimer?.invalidate()
        var fileURL: String?
        if let url: URL = audioRecorder?.url {
            fileURL = String(describing: url)
        }
        return fileURL ?? ""
    }
    
    
    
    func getRecorder() -> AVAudioRecorder {
        return audioRecorder
    }
    
    
}


extension AudioRecorder: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        print("AudioManager Finish Recording")
        
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Encoding Error", error?.localizedDescription)
    }
    
}


