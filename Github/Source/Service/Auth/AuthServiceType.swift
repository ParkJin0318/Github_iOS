//
//  AuthServiceType.swift
//  Github-App
//
//  Created by 박진 on 2021/06/02.
//

import RxSwift

protocol AuthServiceType {
    func login(code: String) -> Single<Void>
    func logout() -> Single<Void>
    func isLogin() -> Single<Bool>
}
