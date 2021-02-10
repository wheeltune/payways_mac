//
//  JwtToken.swift
//  PayWays
//
//  Created by Арсений Крохалев on 10.02.2021.
//

import Foundation
import SwiftyJSON

struct JwtToken: Codable {
    let access: String
    let refresh: String
    
    var payload: JSON {
        var payload64 = self.access.components(separatedBy: ".")[1]
        let length = payload64.lengthOfBytes(using: String.Encoding.utf8)
        let requiredLength = 4 * Int(ceil(Double(length) / 4.0))
        let paddingLength = requiredLength - length

        if paddingLength > 0 {
            let padding = "".padding(toLength: paddingLength, withPad: "=", startingAt: 0)
            payload64 = payload64 + padding
        }

        let payloadData = Data(base64Encoded: payload64,
                               options: .ignoreUnknownCharacters)!
        return JSON(parseJSON: String(data: payloadData, encoding: .utf8)!)
    }
    
    var expirationDate: Date {
        let expiration = TimeInterval(self.payload["exp"].uInt64!)
        return Date(timeIntervalSince1970: expiration)
    }
    
    var userId: UInt64 {
        return self.payload["user_id"].uInt64!
    }
    
    func isExpired() -> Bool {
        return expirationDate <= Date()
    }
}
