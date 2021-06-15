//
//  Repo.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import Foundation

struct Repo: Codable {
    let id: Double
    let name: String
    let description: String?
    let starCount: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "full_name"
        case description = "description"
        case starCount = "stargazers_count"
    }
}

extension Repo: Equatable {
    
    static func == (lhs: Repo, rhs: Repo) -> Bool {
        return lhs.id == rhs.id
    }
}
