//
//  RepoServiceType.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import RxSwift

protocol RepoServiceType {
    func getRepos(name: String, page: Int) -> Single<[Repo]>
    func getRepoStarred(name: String) -> Single<Bool>
    func starredRepo(name: String) -> Single<Void>
    func unstarredRepo(name: String) -> Single<Void>
}
