//
//  UserState.swift
//  Friend Watch App
//
//  Created by John Trager on 6/26/24.
//

import Foundation

class UserState: ObservableObject {
    @Published var isRecording = false
    @Published var recordings = [String]()
    
    init() {
        loadRecordings()
    }
    
    private func loadRecordings() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let recordingsFolder = documentsDirectory.appendingPathComponent("Recordings")
        
        // Ensure the recordings folder exists
        if !FileManager.default.fileExists(atPath: recordingsFolder.path) {
            return
        }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: recordingsFolder, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            let audioFiles = files.filter { $0.pathExtension == "m4a" }
            recordings = audioFiles.map { $0.lastPathComponent }
        } catch {
            print("Failed to list recordings: \(error)")
        }
    }
}

extension UserState {
    
    /// Can make dummy things here
    static var dummyUserState: UserState {
        let model = UserState()
        model.recordings.append("file1")
        model.recordings.append("file2")
        model.recordings.append("file3")
        return model
    }
}
