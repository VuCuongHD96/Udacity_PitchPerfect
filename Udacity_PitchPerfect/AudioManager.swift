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
        case alien
    }
    
    static let shared = AudioManager()
    var audioRecorder: AVAudioRecorder!
    var audioEngine: AVAudioEngine!
    var audioFile = AVAudioFile()
    
    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    
    func setupAudio() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        do {
            audioFile = try AVAudioFile(forReading: audioFilename)
        } catch {
            print("--- debug --- audioFile --- error = ", error)
        }
    }
    
    func setupPermission() {
        let recordingSession = AVAudioSession.sharedInstance()
        
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
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine = AVAudioEngine()
        _ = audioEngine.mainMixerNode
        audioEngine.attach(audioPlayerNode)
        
        let changeRatePitchNode = AVAudioUnitTimePitch()
        audioEngine.attach(changeRatePitchNode)
        connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil)
        
        switch voiceKind {
        case .slow:
            changeRatePitchNode.rate = 0.5
        case .fast:
            changeRatePitchNode.rate = 2
        case .treble:
            changeRatePitchNode.pitch = 2000
        case .alien:
            changeRatePitchNode.pitch = -1000
        default:
            break
        }
        
        do {
            try audioEngine.start()
            audioPlayerNode.play()
        } catch {
            print(error)
        }
    }
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
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
