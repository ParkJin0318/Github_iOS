//
//  UserService.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import RxSwift

class UserService: UserServiceType {
    
    private var provider: GithubAPIType
    
    init(provider: GithubAPIType) {
        self.provider = provider
    }

    func getUserProfile() -> Single<User> {
        return provider.getUserProfile()
    }
    
    func getUserRepos(page: Int) -> Single<[Repo]> {
        return provider.getUserRepos(page: page)
            .flatMap { repos in
                repos.isEmpty ?
                    .error(GithubError.error(message: "더 이상 값이 없습니다.")) :
                    .just(repos)
            }
    }
}
