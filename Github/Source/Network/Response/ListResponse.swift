//
//  ListResponse.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import Foundation

struct ListResponse<T: Codable>: Codable {
    let totalCount: Int
    let items: [T]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items = "items"
    }
}
