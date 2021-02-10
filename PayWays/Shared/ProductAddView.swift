//
//  ProductAddView.swift
//  PayWays
//
//  Created by Арсений Крохалев on 08.02.2021.
//

import SwiftUI

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}

struct ProductAddView: View {
    @EnvironmentObject var globalState: GlobalState
    @State private var itemName: String = ""
    @State private var itemCost: String = ""
    
    @State private var balance: Double = 0.0
    @State private var items: [ItemModel] = []
    @State private var memberIds: [UInt64] = []

    let group: GroupModel
    
    var body: some View {
        VStack {
            List(items) { item in
                NavigationLink(destination: Text(item.name)) {
                    HStack {
                        Text(item.name)
                        Text(String(item.cost))
                    }
                }
            }
            Spacer()
            HStack {
                Spacer(minLength: 8)
                FlatTextField("Name", text: $itemName)
                Spacer(minLength: 8)
                FlatTextField("Cost", text: $itemCost)
                Spacer(minLength: 8)
                Button(action: addItem) {
                    Text("A")
                }
                Spacer(minLength: 8)
            }
            .frame(height: 50.0)
        }
        .toolbar(content: {
            ToolbarItem(placement: .status) {
                Text(String(balance))
            }
        })
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        PayWaysApi.getItems(groupId: group.id) { response in
            switch (response) {
            case .success(let value):
                self.items = value
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        
        PayWaysApi.getMembers(groupId: group.id) { response in
            switch (response) {
            case .success(let value):
                self.memberIds = value.map { $0.id }
            case let .failure(error):
                print(error.localizedDescription)
            }
            
        }
        
        PayWaysApi.getBalance(groupId: group.id) { response in
            switch (response) {
            case .success(let value):
                self.balance = value
            case let .failure(error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    func addItem() {
        PayWaysApi.addItem(name: itemName,
                           cost: Double(itemCost)!,
                           groupId: group.id,
                           buyerId: globalState.account!.id,
                           usedIds: memberIds) { _ in
            loadData()
        }
        itemName = ""
        itemCost = ""
    }
}

//struct ProductAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductAddView(name: "LOL")
//    }
//}
