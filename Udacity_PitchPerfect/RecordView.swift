//
//  RecordView.swift
//  Udacity_PitchPerfect
//
//  Created by Work on 10/02/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecordView: View {
    
    let viewModel = RecordViewModel()
    var input: RecordViewModel.Input
    @ObservedObject var output: RecordViewModel.Output
    let cancelBag = CancelBag()
    
    init() {
        let input = RecordViewModel.Input()
        output = viewModel.transform(input: input, cancelBag: cancelBag)
        self.input = input
    }
    
    var body: some View {
        VStack(spacing: 50) {
            Image("voice")
                .resizable()
                .frame(width: 100, height: 100)
                .onTapGesture {
                    input.recordAction.send()
                }
            HStack {
                Text(output.isRecording ? "Say something" : "Tap to record")
                    .font(.title)
                if output.isRecording {
                    AnimatedImage(name: "recording.gif")
                        .frame(width: 50, height: 50)
                }
            }
            HStack(spacing: 50) {
                Image("stop")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .onTapGesture {
                        input.stopAction.send()
                    }
                NavigationLink {
                    VoiceView()
                } label: {
                    Image("play")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                
            }
        }
        .onAppear {
            input.loadTrigger.send()
        }
    }
}

#Preview {
    RecordView()
}
