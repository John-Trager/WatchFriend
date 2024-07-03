//
//  FriendApp.swift
//  Friend Watch App
//
//  Created by John Trager on 6/26/24.
//

import SwiftUI

@main
struct Friend_Watch_AppApp: App {
    /// good info for state management
    /// https://stackoverflow.com/questions/71244103/mvvm-passing-data-from-view-to-another-views-viewmodel/71244581#71244581
    @StateObject var userState = UserState()
    @StateObject var recorder = Recorder()
    @StateObject var servHandler = ServerHandler()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(userState)
                    .environmentObject(recorder)
                    .environmentObject(servHandler)
            }
        }
    }
}
