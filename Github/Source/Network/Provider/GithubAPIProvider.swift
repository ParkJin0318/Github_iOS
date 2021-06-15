//
//  GithubAPIProvider.swift
//  Github-App
//
//  Created by 박진 on 2021/06/08.
//

import Moya
import RxSwift

class GithubAPIProvider: ProviderType {
    
    typealias T = GithubAPI
    var provider: MoyaProvider<GithubAPI>
    
    required init(isStub: Bool = false, sampleStatusCode: Int = 200) {
        provider = Self.consProvider(isStub, sampleStatusCode)
    }
    
    private func request<D: Decodable>(type: D.Type, target: T) -> Single<D> {
        return provider.rx.request(target)
            .map(type)
    }
    
    private func request(target: T) -> Single<Void> {
        return provider.rx.request(target)
            .map { _ in Void() }
    }
}

extension GithubAPIProvider: GithubAPIType {
    
    func getToken(code: String) -> Single<String> {
        return request(type: Token.self, target: .getToken(code: code))
            .map { $0.token }
    }
    
    func getUserProfile() -> Single<User> {
        return request(type: User.self, target: .getUserProfile)
    }
    
    func getUserRepos(page: Int) -> Single<[Repo]> {
        return request(type: [Repo].self, target: .getUserRepos(page: page))
    }
    
    func getRepos(name: String, page: Int) -> Single<[Repo]> {
        return request(type: ListResponse<Repo>.self, target: .getRepos(name: name, page: page))
            .map { $0.items }
    }
    
    func getRepoStarred(name: String) -> Single<Void> {
        return request(target: .getRepoStarred(name: name))
    }
    
    func starredRepo(name: String) -> Single<Void> {
        return request(target: .starredRepo(name: name))
    }
    
    func unstarredRepo(name: String) -> Single<Void> {
        return request(target: .unstarredRepo(name: name))
    }
}

extension GithubAPIProvider: GithubTestApiType {
    
    func getRepos(name: String) -> Single<[Repo]> {
        return request(type: ListResponse<Repo>.self, target: .getRepos(name: name, page: 1))
            .map { $0.items }
    }
}
