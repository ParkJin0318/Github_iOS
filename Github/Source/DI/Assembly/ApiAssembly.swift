//
//  ApiAssembly.swift
//  Github-App
//
//  Created by 박진 on 2021/06/08.
//

import Foundation
import Swinject
import Moya

class ApiAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(GithubAPIType.self) { _ in
            GithubAPIProvider()
        }.inObjectScope(.container)
        
        container.register(GithubTestApiType.self) { _ in
            GithubAPIProvider(isStub: true)
        }.inObjectScope(.container)
    }
}
