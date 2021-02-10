//
//  FlatTextField.swift
//  PayWays
//
//  Created by Арсений Крохалев on 10.02.2021.
//

import Foundation
import SwiftUI

enum FlatTextFieldType {
    case normal
    case secure
}

struct FlatTextField: View {
    let display_text: String
    let content_text: Binding<String>
    let field_type: FlatTextFieldType
    
    init(_ display_text: String, text content_text: Binding<String>, type: FlatTextFieldType = .normal) {
        self.display_text = display_text
        self.content_text = content_text
        self.field_type = type
    }
    
    var body: some View {
        switch (field_type) {
        case .normal:
            TextField(display_text, text: content_text)
                .textFieldStyle(PlainTextFieldStyle())
                .background(RoundedRectangle(cornerRadius: 4).fill(Color("AccentColor")))
                .foregroundColor(Color.white)
                
        case .secure:
            SecureField(display_text, text: content_text)
                .textFieldStyle(PlainTextFieldStyle())
                .background(RoundedRectangle(cornerRadius: 4).fill(Color("AccentColor")))
                .foregroundColor(Color.white)
        }
    }
}

//struct FlatTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        var content: String = ""
//        FlatTextField("Text...", text: content)
//    }
//}
