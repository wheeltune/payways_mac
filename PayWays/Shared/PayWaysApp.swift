//
//  PayWaysApp.swift
//  Shared
//
//  Created by Арсений Крохалев on 08.02.2021.
//

import SwiftUI

@main
struct PayWaysApp: App {
    var body: some Scene {
        let globalState = GlobalState()
        PayWaysApi.getMe() { response in
            switch (response) {
            case .success(let value):
                globalState.account = value
            case .failure(_):
                break
            }
        }
            
        return WindowGroup {
                ContentView()
                    .environmentObject(globalState)
            }
            .commands {
                SidebarCommands()
            }
    }
}
