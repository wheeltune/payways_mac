//
//  LoginView.swift
//  PayWays
//
//  Created by Арсений Крохалев on 08.02.2021.
//

import Alamofire
import SwiftUI

struct SignInView: View {
    @EnvironmentObject var globalState: GlobalState
    
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                FlatTextField("Username", text: $username)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                FlatTextField("Password", text: $password, type: .secure)
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                HStack {
                    Spacer()
                    Button(action: signUp) {
                        Text("SignUp")
                    }
                    Spacer()
                    Button(action: signIn) {
                        Text("SignIn")
                    }
                    Spacer()
                }
                .padding()
                Spacer()
            }
            .frame(maxWidth: 300)
            Spacer()
        }
    }
    
    func signIn() {
        PayWaysApi.signIn(username: username, password: password) { response in
            switch response {
            case .success:
                PayWaysApi.getMe() { response in
                    switch (response) {
                    case .success(let value):
                        self.globalState.account = value
                    case let .failure(error):
                        print(error)
                    }
                    
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func signUp() {
        globalState.isNewUser = true
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(GlobalState())
    }
}
