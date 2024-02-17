//
//  AudioManager.swift
//  Udacity_PitchPerfect
//
//  Created by Work on 11/02/2024.
//

import Foundation
import AVFAudio

class AudioManager: NSObject {
    
    enum VoiceKind {
        case normal
        case slow
        case fast
        case treble
    }
    
    static let shared = AudioManager()
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var recordingSession: AVAudioSession!
    
    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    
    func setupPermission() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print(error)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording()
        }
    }
    
    func finishRecording() {
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    func playAudio(voiceKind: VoiceKind) {
        let audioURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        print("--- debug --- audioURL = ", audioURL)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            switch voiceKind {
            case .slow:
                audioPlayer.enableRate = true
                audioPlayer.rate = 0.5
            case .fast:
                audioPlayer.enableRate = true
                audioPlayer.rate = 3
            case .normal:
                break
            case .treble:
                break

            }
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func connectAudioNodes(_ nodes: AVAudioNode..., audioFile: AVAudioFile, audioEngine: AVAudioEngine) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
}

extension AudioManager: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }
    }
}
