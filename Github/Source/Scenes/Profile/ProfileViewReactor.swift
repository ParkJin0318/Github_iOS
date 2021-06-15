//
//  ProfileViewReactor.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import ReactorKit

class ProfileViewReactor: Reactor {
    
    var service: UserServiceType
    
    var initialState: State
    
    init(service: UserServiceType) {
        self.service = service
        
        self.initialState = State(userProfile: nil,
                                  isCurrentLogin: false,
                                  isLoading: false,
                                  errorMessage: nil)
    }
    
    enum Action {
        case getUserProfile(Bool, Int = 1)
    }
    
    enum Mutation {
        case setUserProfile(User, [Repo])
        case setIsCurrentLogin(Bool)
        
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var userProfile: (User, [Repo])?
        var isCurrentLogin: Bool
        
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getUserProfile(let isCurrentLogin, let page):
            return Observable.concat([
                .just(Mutation.setLoading(true)),
                getUserProfile(isCurrentLogin, page),
                .just(Mutation.setLoading(false))
            ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return .merge(action, isLoginVerification.map { .getUserProfile($0) })
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
        case .setUserProfile(let user, let repos):
            state.userProfile = (user, repos)
            
        case .setIsCurrentLogin(let isCurrentLogin):
            state.isCurrentLogin = isCurrentLogin
            
        case .setLoading(let isLoading):
            state.isLoading = isLoading
            
        case .setError(let error):
            state.errorMessage = error.toMessage()
            state.isLoading = false
        }
        return state
    }
}

extension ProfileViewReactor {
    
    private func getUserProfile(_ isCurrentLogin: Bool, _ page: Int) -> Observable<Mutation> {
        guard isCurrentLogin else {
            return .just(Mutation.setIsCurrentLogin(false))
        }
        
        return page == 1 ? initUserProfile() : moreUserProfile(page: page)
    }
    
    private func initUserProfile() -> Observable<Mutation> {
        return Observable.concat([
            .just(Mutation.setIsCurrentLogin(true)),
            Single.zip(
                service.getUserProfile(),
                service.getUserRepos(page: 1)
            ).asObservable()
            .map { Mutation.setUserProfile($0, $1) }
        ])
    }
    
    private func moreUserProfile(page: Int) -> Observable<Mutation> {
        guard let userProfile = currentState.userProfile?.0,
              let oldRepos = currentState.userProfile?.1 else { return .empty() }
       
        return service.getUserRepos(page: page)
            .map { $0.filter { !oldRepos.contains($0) } }
            .map { repos in
                var newRepos: [Repo] = oldRepos
                newRepos.append(contentsOf: repos)
                return newRepos
            }
            .asObservable()
            .map { Mutation.setUserProfile(userProfile, $0) }
    }
}
