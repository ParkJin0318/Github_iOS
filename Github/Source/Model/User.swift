//
//  User.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import Foundation

struct User: Codable {
    let id: Double
    let name: String
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "login"
        case profileImage = "avatar_url"
    }
}
