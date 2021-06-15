//
//  Token.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import Foundation

struct Token: Codable {
    let token: String
    let type: String
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case type = "token_type"
        case scope = "scope"
    }
}
