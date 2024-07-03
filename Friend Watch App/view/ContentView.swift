//
//  ContentView.swift
//  Friend Watch App
//
//  Created by John Trager on 6/26/24.
//
import SwiftUI
import WatchKit
import AVFoundation
                        
struct ContentView: View {
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        TabView {
            NavigationStack {
                RecordView()
                    .navigationTitle("")
            }
            NavigationStack {
                FileListView()
                    .navigationTitle("Files")
            }
            NavigationStack {
                Text("By John Trager")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserState.dummyUserState)
        .environmentObject(Recorder())
        .environmentObject(ServerHandler())
}
