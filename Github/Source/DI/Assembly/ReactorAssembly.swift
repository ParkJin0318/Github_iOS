//
//  ReactorAssembly.swift
//  Github-App
//
//  Created by 박진 on 2021/06/07.
//

import Foundation
import Swinject

class ReactorAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(GithubViewReactor.self) { resolver in
            GithubViewReactor(service: resolver.resolve(AuthServiceType.self)!)
        }
        
        container.register(RepoViewReactor.self) { resolver in
            RepoViewReactor(service: resolver.resolve(RepoServiceType.self)!)
        }
        
        container.register(ProfileViewReactor.self) { resolver in
            ProfileViewReactor(service: resolver.resolve(UserServiceType.self)!)
        }
    }
}
