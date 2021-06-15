//
//  ServiceAssembly.swift
//  Github-App
//
//  Created by 박진 on 2021/06/07.
//

import Foundation
import Swinject
import Moya

class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(AuthServiceType.self) { resolver in
            AuthService(provider: resolver.resolve(GithubAPIType.self)!,
                        authController: resolver.resolve(AuthController.self)!)
        }.inObjectScope(.container)
        
        container.register(UserServiceType.self) { resolver in
            UserService(provider: resolver.resolve(GithubAPIType.self)!)
        }.inObjectScope(.container)
        
        container.register(RepoServiceType.self) { resolver in
            RepoService(provider: resolver.resolve(GithubAPIType.self)!)
        }.inObjectScope(.container)
        
        container.register(AuthController.self) { _ in
            AuthController()
        }.inObjectScope(.container)
    }
}
