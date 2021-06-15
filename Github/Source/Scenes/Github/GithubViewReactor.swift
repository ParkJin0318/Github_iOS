//
//  GithubViewReactor.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import ReactorKit

class GithubViewReactor: Reactor {
    
    var service: AuthServiceType
    
    var initialState: State
    
    init(service: AuthServiceType) {
        self.service = service
        
        self.initialState = State(isOpenLogin: false,
                                  isCurrentLogin: false,
                                  isLoading: false,
                                  errorMessage: nil)
    }
    
    enum Action {
        case openLogin
        case login(String)
        case getCurrentLogin
    }
    
    enum Mutation {
        case setOpenLogin(Bool)
        case setCurrentLogin(Bool)
        case setIsLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var isOpenLogin: Bool
        var isCurrentLogin: Bool
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .openLogin:
            return openLogin()
            
        case .login(let code):
            return Observable.concat([
                .just(Mutation.setIsLoading(true)),
                service.login(code: code)
                    .asObservable()
                    .map { Mutation.setCurrentLogin(true) },
                .just(Mutation.setIsLoading(false))
            ]).catch { .just(Mutation.setError($0)) }
            
        case .getCurrentLogin:
            return service.isLogin()
                .asObservable()
                .map { Mutation.setCurrentLogin($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
        case .setOpenLogin(let isOpenLogin):
            state.isOpenLogin = isOpenLogin
            
        case .setCurrentLogin(let isCurrentLogin):
            state.isCurrentLogin = isCurrentLogin
            state.isOpenLogin = false
            
        case .setError(let error):
            state.errorMessage = error.toMessage()
            state.isLoading = false
            
        case .setIsLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
}

extension GithubViewReactor {
    
    private func openLogin() -> Observable<Mutation> {
        if (currentState.isCurrentLogin) {
            return service.logout()
                .asObservable()
                .map { Mutation.setCurrentLogin(false) }
        }
        
        return .just(Mutation.setOpenLogin(true))
    }
}
