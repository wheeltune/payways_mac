//
//  ContentView.swift
//  Shared
//
//  Created by Арсений Крохалев on 08.02.2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var globalState: GlobalState
    
    var body: some View {
        Group {
            if (globalState.account != nil) {
                HomeView()
            } else if (globalState.isNewUser) {
                SignUpView()
            } else {
                SignInView()
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let globalState = GlobalState()
//        globalState.isAuthorized = true
//        return ContentView()
//            .environmentObject(globalState)
//    }
//}
