//
//  RecordView.swift
//  Friend Watch App
//
//  Created by John Trager on 6/27/24.
//

import SwiftUI

struct RecordView: View {
    @EnvironmentObject var userState: UserState
    @EnvironmentObject var recorder: Recorder
    @EnvironmentObject var servHandler: ServerHandler

    var body: some View {
        VStack {
            Text("Audio Recorder")
                .bold()
                .padding(.vertical, 20)
            Button(userState.isRecording ? "Stop" : "Start"){
                userState.isRecording = !userState.isRecording
                debugPrint(userState.isRecording)
                
                if (userState.isRecording) {
                    /// start recording
                    try? recorder.record()
                    print("recording")
                } else {
                    /// stop recording + save file + add to list
                    let url = recorder.stop(userState: userState)
                    print("stopped")
                    
                    /// get files in the folder and try to upload one of them
                    // let urls = recorder.getAllRecordingURLs()
                    
                    if (url != nil) {
                        debugPrint("upload")
                        debugPrint(url!)
                        servHandler.uploadAudioFile(url: url!)
                    }
                    
                }
            }
            .tint(userState.isRecording ? .red : .white)
        }
    }
}

#Preview {
    RecordView()
        .environmentObject(UserState())
        .environmentObject(Recorder())
        .environmentObject(ServerHandler())
}
