//
//  DependencyProvider.swift
//  Github
//
//  Created by 박진 on 2021/06/15.
//

import Swinject

class DependencyProvider {
    
    private let container: Container = Container()
    private let assembler: Assembler
    
    init() {
        Container.loggingFunction = nil
        
        assembler = Assembler(
            [
                ApiAssembly(),
                ServiceAssembly(),
                ReactorAssembly()
            ],
            container: container
        )
    }
}

extension DependencyProvider {
    
    private static let shared = DependencyProvider()
    
    static func resolve<T>(_ type: T.Type) -> T {
        return DependencyProvider.shared.container.synchronize().resolve(T.self)!
    }
}
