//
//  Authentication.swift
//  Drevmass
//
//  Created by Aset Bakirov on 07.03.2024.
//

import Foundation
import KeychainSwift

final class AuthenticationService {
    
    public static let shared = AuthenticationService()
    
    private let keychain = KeychainSwift()
    private let key = "token"
    
    var token: String {
        get {
            keychain.get(key) ?? ""
        }
        set {
            keychain.set(newValue, forKey: key)
        }
    }
    
    func tokenClear() {
        keychain.clear()
    }
    
    var isAuthorized: Bool {
        !token.isEmpty
    }
    
    private init() {}
}
