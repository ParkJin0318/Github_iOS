//
//  UserServiceType.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import RxSwift

protocol UserServiceType {
    func getUserProfile() -> Single<User>
    func getUserRepos(page: Int) -> Single<[Repo]>
}
