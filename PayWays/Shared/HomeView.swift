//
//  HomeView.swift
//  PayWays
//
//  Created by Арсений Крохалев on 08.02.2021.
//

import SwiftUI

enum NavigationBarState {
    case contacts
    case rooms
    case account
}

struct HomeView: View {
    @EnvironmentObject var globalState: GlobalState

    @State private var navigationBarState = NavigationBarState.rooms
    @State private var isSearching = false

    @State private var searchText: String = ""
    @State private var searchResults: [ContactModel] = []
    @State private var showAddGroup: Bool = true
    
    var body: some View {
        NavigationView {
            VStack {
                if navigationBarState != .account {
                    HStack {
                        TextField("Search", text: $searchText) { isEditing in
                            self.isSearching = isEditing || !searchText.isEmpty
                        }
                        .padding(.leading, 8)

                        Button(action: searchContacts) {
                            Text("S")
                        }

                        NavigationLink(destination: GroupAddView(), isActive: $globalState.showAddGroup) {
                            Text("A")
                        }
                        .padding(.trailing, 8)
                    }
                    .frame(height: 50)
                }

                switch (navigationBarState) {
                case .contacts:
                    ZStack {
                        List(globalState.contacts) { contact in
                            NavigationLink(destination: Text(contact.fullName)) {
                                HStack {
                                    CircleImageView(text: contact.shortcut, size: 50)
                                    Text(contact.fullName)
                                }
                            }
                        }
                        if (isSearching) {
                            List(searchResults) { contact in
                                HStack {
                                    CircleImageView(text: contact.shortcut, size: 50)
                                    Text(contact.fullName)
                                    Button(action: {
                                        addContact(contact)
                                    }) {
                                        Text("A")
                                    }
                                }
                            }
                            .background(Rectangle().fill(Color.black))
                        }
                    }
                case .rooms:
                    List(globalState.groups) { group in
                        NavigationLink(destination: ProductAddView(group: group)) {
                            HStack {
                                CircleImageView(text: group.shortcut, size: 50)
                                Text(group.name)
                            }
                        }
                    }
                case .account:
                    Button(action: signOut) {
                        Text("SignOut")
                    }
                    Spacer()
                }

                Divider()

                HStack() {
                    Spacer()
                    Button(action: {
                        navigationBarState = .contacts
                    }) {
                        Image("ContactIcon")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()

                    Spacer()
                    Spacer()
                    Button(action: {
                        navigationBarState = .rooms
                    }) {
                        Image("RoomIcon")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()

                    Spacer()
                    Spacer()
                    Button(action: {
                        navigationBarState = .account
                    }) {
                        Image("ProfileIcon")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    Spacer()
                }
                .frame(height: 50.0)
            }
        }
        .toolbar(content: {

        })
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        globalState.reloadContacts()
        globalState.reloadGroups()
    }
    
    func createGroup() {
        
    }
    
    func searchContacts() {
        PayWaysApi.findContacts(query: searchText) { response in
            switch (response) {
            case .success(let value):
                self.searchResults = value
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
        
    func addContact(_ contact: ContactModel) {
        PayWaysApi.addContact(contact.id) { _ in
            self.loadData()
        }
    }
    
    func signOut() {
        PayWaysApi.signOut()
        globalState.clear()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
