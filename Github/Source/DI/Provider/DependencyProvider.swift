//
//  DependencyProvider.swift
//  Github
//
//  Created by 박진 on 2021/06/15.
//

import Swinject

class DependencyProvider {
    
    static let shared = DependencyProvider()
    
    let container = Container()
    let assembler: Assembler
    
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
