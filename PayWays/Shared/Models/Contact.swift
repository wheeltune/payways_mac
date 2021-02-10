//
//  Contact.swift
//  PayWays
//
//  Created by Арсений Крохалев on 10.02.2021.
//

import Foundation
import SwiftyJSON

class ContactModel: Codable, Identifiable, Hashable {
    let id: UInt64
    let username: String
    let firstName: String
    let lastName: String
    
    init(jsonData: JSON) {
        self.id = jsonData["pk"].uInt64!
        self.username = jsonData["username"].string ?? ""
        self.firstName = jsonData["first_name"].string ?? ""
        self.lastName = jsonData["last_name"].string ?? ""
    }
    
    var fullName: String {
        return firstName + " " + lastName
    }
    
    var shortcut: String {
        return String(firstName.prefix(1) + lastName.prefix(1))
    }
    
    static func == (lhs: ContactModel, rhs: ContactModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
