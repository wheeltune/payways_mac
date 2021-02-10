//
//  SignUpView.swift
//  PayWays
//
//  Created by Арсений Крохалев on 10.02.2021.
//

import Alamofire
import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var globalState: GlobalState
    
    @State private var username: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                FlatTextField("Username", text: $username)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                FlatTextField("First name", text: $firstName)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                FlatTextField("Last name", text: $lastName)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                FlatTextField("Password", text: $password, type: .secure)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                FlatTextField("Confirm password", text: $passwordConfirm, type: .secure)
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                HStack {
                    Spacer()
                    Button(action: signUp) {
                        Text("SignUp")
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
    
    func signUp() {
        PayWaysApi.signUp(username: username, firstName: firstName, lastName: lastName, password: password, passwordConfirm: passwordConfirm) { _ in
            globalState.isNewUser = false
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(GlobalState())
    }
}

