//
//  GlobalState.swift
//  PayWays
//
//  Created by Арсений Крохалев on 09.02.2021.
//

import SwiftUI

class GlobalState: ObservableObject
{
    @Published var isNewUser: Bool = false
    @Published var account: ContactModel? = nil

    @Published var showAddGroup: Bool = false
    
    @Published var contacts: [ContactModel] = []
    @Published var groups: [GroupModel] = []
    
    func clear() {
        account = nil
        contacts = []
        groups = []
        showAddGroup = false
        isNewUser = false
    }
    
    func reloadContacts() {
        PayWaysApi.getContacts() { response in
            switch (response) {
            case .success(let contacts):
                self.contacts = contacts
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func reloadGroups() {
        PayWaysApi.getGroups() { response in
            switch (response) {
            case .success(let groups):
                self.groups = groups
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
