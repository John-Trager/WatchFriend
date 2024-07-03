//
//  Utils.swift
//  Friend Watch App
//
//  Created by John Trager on 6/26/24.
//

import Foundation

struct ListItem: Identifiable, Hashable {
    
    let id = UUID()
    var desciption: String
    init(_ desciption: String){
        self.desciption = desciption
    }
}

class ItemListModel: NSObject, ObservableObject {
    @Published var items = [ListItem]()
}
