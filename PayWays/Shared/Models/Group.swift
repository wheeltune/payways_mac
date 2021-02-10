//
//  Group.swift
//  PayWays
//
//  Created by Арсений Крохалев on 10.02.2021.
//

import Foundation

struct GroupModel: Codable, Identifiable {
    let id: UInt64
    let name: String
    
    var shortcut: String {
        return String(name.prefix(1))
    }
}
