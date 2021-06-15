//
//  MessageResponse.swift
//  Github-App
//
//  Created by 박진 on 2021/06/04.
//

import Foundation

struct MessageResponse: Codable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
}
