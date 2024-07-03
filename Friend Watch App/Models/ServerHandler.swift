//
//  ServerHandler.swift
//  Friend Watch App
//
//  Created by John Trager on 6/30/24.
//

import Foundation
import Alamofire // HTTP request stuff

class ServerHandler: ObservableObject {
    
    init() {
        authSession()// IDK how this works
    }
    
    
    // Upload the audio file to the server
    func uploadAudioFile(url: URL) {
        /// TODO: make this more permanent
        let uploadURL = "http://127.0.0.1:5000/upload"
        
        /*
        AF.upload(url, to: uploadURL).responseDecodable(of: [String: String].self) { response in
            debugPrint(response)
        }*/
        
        AF.upload(multipartFormData: { multipartFormData in multipartFormData.append(url, withName: "file")
        }, to: uploadURL).responseDecodable(of: [String: String].self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                print("Upload success: \(value)")
            case .failure(let error):
                print("Upload failed: \(error)")
            }
        }
    }
    
    // Send a GET request to the server to receive the summary text
    // about the audio file transcript
    func getSummary() {
        
    }
    
    // Private functions
    
    // authenticate with the server
    private func authSession() {
        
    }
}
