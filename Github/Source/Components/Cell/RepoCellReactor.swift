//
//  RepoCellReactor.swift
//  Github-App
//
//  Created by 박진 on 2021/06/04.
//

import ReactorKit

class RepoCellReactor: Reactor {
    
    var service: RepoServiceType
    
    var initialState: State
    
    init(service: RepoServiceType, repo: Repo) {
        self.service = service
        
        self.initialState = State(name: repo.name,
                                  description: repo.description ?? "",
                                  starCount: repo.starCount,
                                  isStarred: false,
                                  refreshStar: nil,
                                  errorMessage: nil)
    }
    
    enum Action {
        case initStarred
        case starredRepo
    }
    
    enum Mutation {
        case initStarred(Bool)
        case setRefreshStar(String)
        case setError(Error)
    }
    
    struct State {
        var name: String
        var description: String
        var starCount: Double
        var isStarred: Bool
        var refreshStar: String?
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .initStarred:
            return initStarred()
            
        case .starredRepo:
            return starredRepo()
                .catch { .just(Mutation.setError($0)) }
        }
    }
    
    private func initStarred() -> Observable<Mutation> {
        return service.getRepoStarred(name: currentState.name)
            .asObservable()
            .distinctUntilChanged()
            .map { Mutation.initStarred($0) }
    }
    
    private func starredRepo() -> Observable<Mutation> {
        let name = currentState.name
        let isStarred = currentState.isStarred
        
        let service: Single<Void> = isStarred ?
            service.unstarredRepo(name: name) :
            service.starredRepo(name: name)
        
        return service.asObservable()
            .map { Mutation.setRefreshStar(name) }
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        let name = currentState.name
        
        return .merge(action, pressStarred
                        .filter { $0 != nil && $0! == name }
                        .map { _ in Action.initStarred })
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        state.refreshStar = nil
        
        switch mutation {
        case .initStarred(let isStarred):
            state.isStarred = isStarred
            
        case .setRefreshStar(let repoName):
            state.refreshStar = repoName
            
        case .setError(let error):
            state.errorMessage = error.toMessage()
        }
        
        return state
    }
}
