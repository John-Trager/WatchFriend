//
//  FileListView.swift
//  Friend Watch App
//
//  Created by John Trager on 6/27/24.
//

import SwiftUI

struct FileListView: View {
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        List {
            ForEach(userState.recordings, id: \.self) { recording in
                Text("Result: \(recording)")
            }
            
            if userState.recordings.isEmpty {
                Text("No recording files!")
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    FileListView()
        .environmentObject(UserState.dummyUserState)
}
