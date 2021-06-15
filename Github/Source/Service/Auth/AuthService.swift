//
//  AuthService.swift
//  Github-App
//
//  Created by 박진 on 2021/06/02.
//

import RxSwift

class AuthService: AuthServiceType {
    
    private let provider: GithubAPIType
    private let authController: AuthController
    
    init(provider: GithubAPIType, authController: AuthController) {
        self.provider = provider
        self.authController = authController
    }
    
    func login(code: String) -> Single<Void> {
        return provider.getToken(code: code)
            .map { self.authController.login(token: $0) }
    }
    
    func logout() -> Single<Void> {
        return .just(authController.logout())
    }
    
    func isLogin() -> Single<Bool> {
        return Single.just(authController.getToken())
            .map { !$0.isEmpty }
    }
}
