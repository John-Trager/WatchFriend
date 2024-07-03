//
//  Recorder.swift
//  Friend Watch App
//
//  Created by John Trager on 6/29/24.
//
// Modified from https://github.com/aabagdi/MemoMan/tree/main/MemoMan

import Foundation
import AVFoundation
import SwiftData

class Recorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder!
    private var currentURL: URL?
    
    func record() throws {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        
        guard let recordingsFolder = ensureRecordingsFolderExists() else {
            throw Errors.FailedToInitSessionError
        }
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.record, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            throw Errors.FailedToInitSessionError
        }
        
        let fileName = recordingsFolder.appendingPathComponent("\(dateFormatter.string(from: date)).m4a")
        currentURL = fileName
        print("Recording will be saved to: \(fileName.path)")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: currentURL!, settings: settings)
            audioRecorder.prepareToRecord()
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            throw Errors.FailedToRecordError
        }
    }
    
    func stop(userState: UserState) -> URL? {
        audioRecorder.stop()
        saveRecording(userState: userState)
        return currentURL
    }
    
    func getAllRecordingURLs() -> [URL]? {
        guard let recordingsFolder = ensureRecordingsFolderExists() else {
            return nil
        }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: recordingsFolder, includingPropertiesForKeys: nil)
            let m4aFiles = fileURLs.filter { $0.pathExtension == "m4a" }
            return m4aFiles
        } catch {
            print("Error while fetching recording URLs: \(error)")
            return nil
        }
    }
    
    // private functions
    
    private func saveRecording(userState: UserState) {
        guard let url = currentURL else {
            print("Current audio URL is nil, cannot save to userState")
            return
        }
        userState.recordings.append(url.lastPathComponent)
    }
    
    private func ensureRecordingsFolderExists() -> URL? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let recordingsFolder = documentsDirectory.appendingPathComponent("Recordings")
            if !FileManager.default.fileExists(atPath: recordingsFolder.path) {
                do {
                    try FileManager.default.createDirectory(at: recordingsFolder, withIntermediateDirectories: true, attributes: nil)
                    print("Created Recordings folder at: \(recordingsFolder.path)")
                } catch {
                    print("Failed to create Recordings folder: \(error)")
                    return nil
                }
            }
            return recordingsFolder
        }
        return nil
    }
    
} // Class Recorder
