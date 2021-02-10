//
//  GlobalState.swift
//  PayWays
//
//  Created by Арсений Крохалев on 09.02.2021.
//

import SwiftUI

class PayWaysStorage
{
    static var instance = PayWaysStorage()
    
    private let impl: PersistentStorage
    private init() {
        self.impl = PersistentStorage(suiteName: "payways")!
    }
    
    static var token: KeyValueContainer<JwtToken> {
        PayWaysStorage.instance.impl.makeContainer(key: "token")
    }
}
