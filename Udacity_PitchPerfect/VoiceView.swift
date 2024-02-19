//
//  VoiceView.swift
//  Udacity_PitchPerfect
//
//  Created by Work on 15/02/2024.
//

import SwiftUI

struct VoiceView: View {
    
    let viewModel = VoiceViewModel()
    let input: VoiceViewModel.Input
    let output: VoiceViewModel.Output
    let cancelbag = CancelBag()
    
    init() {
        let input = VoiceViewModel.Input()
        output = viewModel.transform(input, cancelBag: cancelbag)
        self.input = input
    }
    
    var body: some View {
        HStack {
            VStack(spacing: 30) {
                Image("snail")
                    .onTapGesture {
                        input.snailAction.send()
                    }
                Image("squirrel")
                    .onTapGesture {
                        input.highVoiceAction.send()
                    }
                Image("echo")
                    .onTapGesture {
                        input.echoVoiceAction.send()
                    }
            }
            Spacer()
            VStack(spacing: 30) {
                Image("rabbit")
                    .onTapGesture {
                        input.rabbitAction.send()
                    }
                HStack {
                    Image("flying")
                        .onTapGesture {
                            input.lowVoiceAction.send()
                        }
                }
                HStack {
                    Image("reverb")
                        .onTapGesture {
                            input.reverbVoiceAction.send()
                        }
                }
            }
        }
        .padding()
    }
}

#Preview {
    VoiceView()
}
