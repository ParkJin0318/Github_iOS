//
//  AuthController.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import Foundation

class AuthController {
    
    let token_key = "token"
    
    func login(token: String) {
        UserDefaults.standard.set("Bearer \(token)", forKey: token_key)
    }
    
    func logout() {
        UserDefaults.standard.set(nil, forKey: token_key)
    }
    
    func getToken() -> String {
        let token = UserDefaults.standard.value(forKey: token_key) as? String
        return token ?? ""
    }
}
