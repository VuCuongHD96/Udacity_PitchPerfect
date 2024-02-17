//
//  VoiceViewModel.swift
//  Udacity_PitchPerfect
//
//  Created by Work on 15/02/2024.
//

import Combine

struct VoiceViewModel {
    
    let audioManager = AudioManager.shared
    
    struct Input {
        let snailAction = PassthroughSubject<Void, Never>()
        let rabbitAction = PassthroughSubject<Void, Never>()
        let lowVoiceAction = PassthroughSubject<Void, Never>()
        let highVoiceAction = PassthroughSubject<Void, Never>()
    }
    
    class Output: ObservableObject {
    }
}

extension VoiceViewModel {
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        
        input.snailAction
            .sink { _ in
                audioManager.playAudio(voiceKind: .slow)
            }
            .store(in: cancelBag)
        
        input.rabbitAction
            .sink { _ in
                audioManager.playAudio(voiceKind: .fast)
            }
            .store(in: cancelBag)
        
        input.highVoiceAction
            .sink { _ in
                audioManager.playAudio(voiceKind: .treble)
            }
            .store(in: cancelBag)
        
        return output
    }
}
