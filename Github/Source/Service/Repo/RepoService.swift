//
//  RepoService.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import RxSwift

class RepoService: RepoServiceType {
    
    private var provider: GithubAPIType
    
    init(provider: GithubAPIType) {
        self.provider = provider
    }
    
    func getRepos(name: String, page: Int) -> Single<[Repo]> {
        return provider.getRepos(name: name, page: page)
            .flatMap { repos in
                repos.isEmpty ?
                    .error(GithubError.error(message: "더 이상 값이 없습니다.")) :
                    .just(repos)
            }
    }
    
    func getRepoStarred(name: String) -> Single<Bool> {
        return provider.getRepoStarred(name: name)
            .flatMap { _ in  .just(true) }
            .catch { _ in .just(false) }
    }
    
    func starredRepo(name: String) -> Single<Void> {
        return provider.starredRepo(name: name)
    }
    
    func unstarredRepo(name: String) -> Single<Void> {
        return provider.unstarredRepo(name: name)
    }
}
