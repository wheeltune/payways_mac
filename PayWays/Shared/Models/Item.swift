//
//  Item.swift
//  PayWays
//
//  Created by Арсений Крохалев on 10.02.2021.
//

import Foundation

struct ItemModel: Codable, Identifiable {
    let id: UInt64
    let name: String
    let cost: Double
}
