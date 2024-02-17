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
        VStack {
            HStack {
                Image("snail")
                    .onTapGesture {
                        input.snailAction.send()
                    }
                Spacer()
                Image("rabbit")
                    .onTapGesture {
                        input.rabbitAction.send()
                    }
            }
            HStack {
                Image("squirrel")
                    .onTapGesture {
                        input.highVoiceAction.send()
                    }
                Spacer()
        
            }
        }
    }
}

#Preview {
    VoiceView()
}
