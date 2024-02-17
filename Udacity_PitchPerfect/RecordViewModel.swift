//
//  RecordViewModel.swift
//  Udacity_PitchPerfect
//
//  Created by Work on 10/02/2024.
//

import Combine

class RecordViewModel {
    
    let audioManager = AudioManager.shared
    
    struct Input {
        let loadTrigger = PassthroughSubject<Void, Never>()
        let recordAction = PassthroughSubject<Void, Never>()
        let stopAction = PassthroughSubject<Void, Never>()
        let playAction = PassthroughSubject<Void, Never>()
    }
    
    class Output: ObservableObject {
        @Published var isRecording = false
    }
}

extension RecordViewModel {
    
    func transform(input: Input, cancelBag: CancelBag) -> Output {
        
        let output = Output()
        
        input.loadTrigger
            .sink { _ in
                self.audioManager.setupPermission()
            }
            .store(in: cancelBag)
        
        input.recordAction
            .sink { _ in
                self.audioManager.startRecording()
            }
            .store(in: cancelBag)
        
        input.recordAction
            .map {
                return true
            }
            .assign(to: \.isRecording, on: output)
            .store(in: cancelBag)
        
        Publishers.Merge(input.stopAction, input.playAction)
            .sink { _ in
                self.audioManager.finishRecording()
            }
            .store(in: cancelBag)
        
        input.stopAction
            .map {
                return false
            }
            .assign(to: \.isRecording, on: output)
            .store(in: cancelBag)

        input.playAction
            .sink { _ in
                self.audioManager.playAudio(voiceKind: .normal)
            }
            .store(in: cancelBag)
        
        input.playAction
            .map {
                return false
            }
            .assign(to: \.isRecording, on: output)
            .store(in: cancelBag)
        
        return output
    }
}
