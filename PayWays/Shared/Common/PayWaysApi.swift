//
//  PayWaysApi.swift
//  PayWays
//
//  Created by Арсений Крохалев on 09.02.2021.
//

import Alamofire
import Foundation
import SwiftyJSON

enum PayWaysApiError: Error {
    case badUrl
    case badRequest
    case badResponse
    case notAuthorized
}

struct PayWaysApi {
    
    static func isAuthorized() -> Bool {
        return PayWaysStorage.token.value != nil
    }
    
    static func signIn(username: String, password: String, completion: @escaping (Result<Void, PayWaysApiError>) -> Void)
    {
        let parameters: Parameters = [
            "username": username,
            "password": password,
        ]

        self.call("/v1/token/", method: .post, parameters: parameters, headers: nil) { response in
            switch response {
            case .success(let value):
                guard let accessToken = value["access"].string else {
                    completion(.failure(.badResponse))
                    return
                }
                guard let refreshToken = value["refresh"].string else {
                    completion(.failure(.badResponse))
                    return
                }
                let token = JwtToken(access: accessToken, refresh: refreshToken)
                if (token.isExpired()) {
                    completion(.failure(.badResponse))
                }

                PayWaysStorage.token.value = token
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    static func refreshToken(completion: @escaping (Result<Void, PayWaysApiError>) -> Void)
    {
        guard let token = PayWaysStorage.token.value else {
            completion(.failure(.notAuthorized))
            return
        }

        let parameters: Parameters = [
            "refresh": token.refresh,
        ]

        self.call("/v1/token/refresh/", method: .post, parameters: parameters, headers: nil) { response in
            switch response {
            case .success(let value):
                guard let accessToken = value["access"].string else {
                    completion(.failure(.badResponse))
                    return
                }
                let newToken = JwtToken(access: accessToken, refresh: token.refresh)
                if (newToken.isExpired()) {
                    completion(.failure(.badResponse))
                }

                PayWaysStorage.token.value = newToken
                completion(.success(()))
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func signUp(username: String,
                       firstName: String,
                       lastName: String,
                       password: String,
                       passwordConfirm: String,
                       completion: @escaping (Result<Void, PayWaysApiError>) -> Void) {
        let parameters: Parameters = [
            "username": username,
            "first_name": firstName,
            "last_name": lastName,
            "password": password,
            "password_confirm": passwordConfirm,
        ]
        
        self.call("/v1/account/register/", method: .post, parameters: parameters, headers: nil) { response in
            switch (response) {
            case .success(_):
                completion(.success(()))
                return
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func signOut() {
        PayWaysStorage.token.value = nil
    }
    
    static func getBalance(groupId: UInt64, completion: @escaping (Result<Double, PayWaysApiError>) -> Void) {
        
        self.apiCall("/v1/rooms/\(groupId)/balance/", method: .get, parameters: nil) { response in
            switch (response) {
            case .success(let value):
                guard let balance = value["balance"].double else {
                    completion(.failure(.badResponse))
                    return
                }
                completion(.success(balance))
                return
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func addItem(name: String, cost: Double, groupId: UInt64, buyerId: UInt64, usedIds: [UInt64], completion: @escaping (Result<Void, PayWaysApiError>) -> Void) {
        
        let parameters: Parameters = [
            "name": name,
            "cost": cost,
            "buyer": buyerId,
            "used_by": usedIds
        ]
        
        self.apiCall("/v1/rooms/\(groupId)/things/", method: .post, parameters: parameters) { response in
            switch (response) {
            case .success(_):
                completion(.success(()))
                return
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func addGroup(name: String, memberIds: [UInt64], completion: @escaping (Result<Void, PayWaysApiError>) -> Void) {
        
        let parameters: Parameters = [
            "name": name,
            "members": memberIds,
        ]
        
        self.apiCall("/v1/rooms/", method: .post, parameters: parameters) { response in
            switch (response) {
            case .success(_):
                completion(.success(()))
                return
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func findContacts(query: String, completion: @escaping (Result<[ContactModel], PayWaysApiError>) -> Void)
    {
        let parameters: Parameters = [
            "q": query,
        ]
        
        self.apiCall("/v1/users/search/", method: .get, parameters: parameters) { response in
            switch (response) {
            case .success(let value):
                var result: [ContactModel] = []
                for jsonData in value.arrayValue {
                    result.append(ContactModel(jsonData: jsonData))
                }
                completion(.success(result))
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func getMe(completion: @escaping (Result<ContactModel, PayWaysApiError>) -> Void) {
        guard let token = PayWaysStorage.token.value else {
            completion(.failure(.notAuthorized))
            return
        }
        self.getContact(contactId: token.userId, completion: completion)
    }
    
    static func getMembers(groupId: UInt64, completion: @escaping (Result<[ContactModel], PayWaysApiError>) -> Void) {
        self.apiCall("/v1/rooms/\(groupId)/members/", method: .get, parameters: nil) { response in
            switch (response) {
            case .success(let value):
                var result: [ContactModel] = []
                for jsonData in value.arrayValue {
                    result.append(ContactModel(jsonData: jsonData))
                }
                completion(.success(result))
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func getContact(contactId: UInt64, completion: @escaping (Result<ContactModel, PayWaysApiError>) -> Void) {
        self.apiCall("/v1/users/\(contactId)/", method: .get, parameters: nil) { response in
            switch (response) {
            case .success(let jsonData):
                completion(.success(ContactModel(jsonData: jsonData)))
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func getItems(groupId: UInt64, completion: @escaping (Result<[ItemModel], PayWaysApiError>) -> Void) {
        self.apiCall("/v1/rooms/\(groupId)/things/", method: .get, parameters: nil) { response in
            switch (response) {
            case .success(let value):
                var result: [ItemModel] = []
                for jsonData in value.arrayValue {
                    let item = ItemModel(id: jsonData["id"].uInt64!,
                                         name: jsonData["name"].string!,
                                         cost: jsonData["cost"].double!)
                    result.append(item)
                }
                completion(.success(result))
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func getGroups(completion: @escaping (Result<[GroupModel], PayWaysApiError>) -> Void) {
        self.apiCall("/v1/rooms/", method: .get, parameters: nil) { response in
            switch (response) {
            case .success(let value):
                var result: [GroupModel] = []
                for jsonData in value.arrayValue {
                    let group = GroupModel(id: jsonData["id"].uInt64!,
                                           name: jsonData["name"].string!)
                    result.append(group)
                }
                completion(.success(result))
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func getContacts(completion: @escaping (Result<[ContactModel], PayWaysApiError>) -> Void) {
        self.apiCall("/v1/contacts/", method: .get, parameters: nil) { response in
            switch (response) {
            case .success(let value):
                var result: [ContactModel] = []
                for jsonData in value.arrayValue {
                    result.append(ContactModel(jsonData: jsonData))
                }
                completion(.success(result))
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func addContact(_ contactId: UInt64, completion: @escaping (Result<Void, PayWaysApiError>) -> Void) {
        let parameters: Parameters = [
            "to_user": contactId,
        ]

        self.apiCall("/v1/contacts/", method: .post, parameters: parameters) { response in
            switch (response) {
            case .success(_):
                completion(.success(()))
                return
            case let .failure(error):
                completion(.failure(error))
                return
            }
        }
    }
    
    static func apiCall(_ path: String, method: HTTPMethod, parameters: Parameters?, completion: @escaping (Result<JSON, PayWaysApiError>) -> Void) {
 
        guard let token = PayWaysStorage.token.value else {
            completion(.failure(.notAuthorized))
            return
        }
        
        if (token.isExpired()) {
            self.refreshToken() { response in
                switch (response) {
                case .success():
                    self.apiCall(path, method: method, parameters: parameters, completion: completion)
                    return
                case let .failure(error):
                    completion(.failure(error))
                    return
                }
            }
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token.access)"]
        return self.call(path, method: method, parameters: parameters, headers: headers, completion: completion)
    }
        
    static func call(_ path: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, completion: @escaping (Result<JSON, PayWaysApiError>) -> Void) {
        var url = URLComponents()
        url.scheme = "http"
        url.host = "localhost"
        url.port = 8000
        url.path = path
        
        var parameters = parameters
        if (method == .get && parameters != nil) {
            var queryItems: [URLQueryItem] = []
            for parameter in parameters! {
                let value_str = parameter.value as! String
                queryItems.append(URLQueryItem(name: parameter.key, value: value_str))
            }
            url.queryItems = queryItems
            parameters = nil
        }
        
        var headers: HTTPHeaders = headers ?? HTTPHeaders()
        headers["Content-Type"] = "application/json"
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if (json["code"].exists()) {
                    completion(.failure(.badResponse))
                    return
                }
                completion(.success(json))
                return
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(.badRequest))
                return
            }
        }
    }
}
