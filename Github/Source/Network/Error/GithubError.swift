//
//  GithubError.swift
//  Github-App
//
//  Created by 박진 on 2021/06/02.
//

import Foundation

enum GithubError: Error {
    case error(message: String)
}

extension Error {
    func toMessage() -> String {
        if let error = self as? GithubError,
            case let .error(message) = error {
                return message
        } else {
            return "알 수 없는 오류"
        }
    }
}
