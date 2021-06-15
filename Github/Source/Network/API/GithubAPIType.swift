//
//  GithubAPIType.swift
//  Github-App
//
//  Created by 박진 on 2021/06/08.
//

import RxSwift

protocol GithubAPIType {
    func getToken(code: String) -> Single<String>
    
    func getUserProfile() -> Single<User>
    
    func getUserRepos(page: Int) -> Single<[Repo]>
    
    func getRepos(name: String, page: Int) -> Single<[Repo]>
    
    func getRepoStarred(name: String) -> Single<Void>
    
    func starredRepo(name: String) -> Single<Void>
    
    func unstarredRepo(name: String) -> Single<Void>
}

protocol GithubTestApiType {
    func getRepos(name: String) -> Single<[Repo]>
}
