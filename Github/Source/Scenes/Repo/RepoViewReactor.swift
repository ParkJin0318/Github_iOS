//
//  RepoViewReactor.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import ReactorKit

class RepoViewReactor: Reactor {
    
    var service: RepoServiceType
    
    var initialState: State
    
    init(service: RepoServiceType) {
        self.service = service
        
        self.initialState = State(
            repoName: "",
            repos: [],
            isLoading: false,
            errorMessage: nil
        )
    }
    
    enum Action {
        case repoName(String)
        case getRepos(Int = 1)
    }
    
    enum Mutation {
        case setRepoName(String)
        case setRepos([Repo])
        
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var repoName: String
        var repos: [Repo]
        
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .repoName(let name):
            return .just(Mutation.setRepoName(name))
            
        case .getRepos(let page):
            return Observable.concat([
                .just(Mutation.setLoading(true)),
                getRepos(page),
                .just(Mutation.setLoading(false))
            ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return .merge(mutation, cellErrorMessage
                        .filter { $0 != nil }
                        .map { GithubError.error(message: $0!) }
                        .map { Mutation.setError($0) })
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
        case .setRepoName(let name):
            state.repoName = name
            
        case .setRepos(let repos):
            state.repos = repos
            
        case .setLoading(let isLoading):
            state.isLoading = isLoading
            
        case .setError(let error):
            state.errorMessage = error.toMessage()
            state.isLoading = false
        }
        return state
    }
}

extension RepoViewReactor {
    
    private func getRepos(_ page: Int) -> Observable<Mutation> {
        let repoName: String = currentState.repoName
        
        guard !repoName.isEmpty else { return .empty() }
        
        return page == 1 ? initRepos(repoName) : moreRepos(repoName, page: page)
    }
    
    private func initRepos(_ name: String) -> Observable<Mutation> {
        return service.getRepos(name: name, page: 1)
            .asObservable()
            .map { Mutation.setRepos($0) }
    }
    
    private func moreRepos(_ name: String, page: Int) -> Observable<Mutation> {
        let oldRepos: [Repo] = currentState.repos
        
        return service.getRepos(name: name, page: page)
            .map { $0.filter { !oldRepos.contains($0) } }
            .map { repos in
                var newRepos: [Repo] = oldRepos
                newRepos.append(contentsOf: repos)
                return newRepos
            }
            .asObservable()
            .map { Mutation.setRepos($0) }
    }
}
