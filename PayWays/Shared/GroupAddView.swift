//
//  AddGroupView.swift
//  PayWays
//
//  Created by Арсений Крохалев on 10.02.2021.
//

import SwiftUI

struct GroupAddView: View {
    @EnvironmentObject var globalState: GlobalState

    @State private var groupName: String = ""
    @State private var contactsSelected = Set<ContactModel>()

    var body: some View {
        VStack {
            HStack {
                FlatTextField("Name", text: $groupName)
                    .frame(maxWidth: 300)
                Button(action: addGroup) {
                    Text("A")
                }
            }
            
            List(globalState.contacts, id: \.self, selection: $contactsSelected) { contact in
//                let color = contactsSelected.contains(contact) ? Color.blue : Color.black
                HStack {
                    CircleImageView(text: contact.shortcut, size: 50)
                    Text(contact.fullName)
                }
//                .background(Rectangle().fill(color))
            }
            Spacer()
        }
        .onAppear(perform: loadData)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: goBack) {
                    Label("Back", systemImage: "chevron.left")
                }
            }
        }
    }
    
    func loadData() {
        globalState.reloadContacts()
    }
    
    func goBack() {
        globalState.showAddGroup = false
    }
    
    func addGroup() {
        let members = Array(contactsSelected.map { $0.id })
        PayWaysApi.addGroup(name: groupName, memberIds: members) { _ in
            globalState.reloadGroups()
            goBack()
        }
    }
}

//struct GroupAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupAddView()
//    }
//}
