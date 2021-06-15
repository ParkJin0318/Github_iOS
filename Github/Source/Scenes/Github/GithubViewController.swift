//
//  GithubTabBarController.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import AsyncDisplayKit
import ReactorKit
import Then
import RxCocoa

protocol GithubAuthDelegate {
    func receiveCode(code: String)
}

let isLoginVerification = BehaviorSubject<Bool>(value: false)

class GithubViewController: ASTabBarController {
    
    lazy var disposeBag = DisposeBag()
    
    private lazy var loginButton = UIButton()
    
    private lazy var repoViewController = RepoViewController().then {
        $0.tabBarItem = UITabBarItem(title: "검색",
                                     image: UIImage(systemName: "magnifyingglass"),
                                     selectedImage: UIImage(systemName: "magnifyingglass"))
    }
        
    private lazy var profileViewController = ProfileViewController().then {
        $0.tabBarItem = UITabBarItem(title: "프로필",
                                     image: UIImage(systemName: "person"),
                                     selectedImage: UIImage(systemName: "person.fill"))
    }
}

extension GithubViewController: View {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        reactor = DependencyProvider.resolve(GithubViewReactor.self)
        
        Observable.just(.getCurrentLogin)
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    func setupView() {
        tabBar.isTranslucent = false
        tabBar.tintColor = .label
        
        viewControllers = [repoViewController,
                           profileViewController]
        selectedViewController = repoViewController
    }
    
    func bind(reactor: GithubViewReactor) {
        // Action
        loginButton.rx.tap
            .map { .openLogin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.isOpenLogin }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in Void() }
            .bind(onNext: openGithubLogin)
            .disposed(by: disposeBag)
        
        let isCurrentLogin = reactor.state
            .map { $0.isCurrentLogin }
            .share()
        
        isCurrentLogin
            .map { $0 ? "로그아웃" : "로그인" }
            .map { $0.toAttributed(color: .label, font: .boldSystemFont(ofSize: 8)) }
            .bind(to: loginButton.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        isCurrentLogin
            .bind(to: isLoginVerification)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: view.rx.loading)
            .disposed(by: disposeBag)
                
        reactor.state.map { $0.errorMessage }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: view.rx.error)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    private func setNavigationBar() {
        self.navigationItem.title = "Github"
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: loginButton)
        ]
    }
    
    private func openGithubLogin() {
        let login_url = "\(auth_url)/authorize?client_id=\(client_id)&scope=\(scope)"
        
        if let url = URL(string: login_url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

extension GithubViewController: GithubAuthDelegate {
    
    func receiveCode(code: String) {
        if let reactor = self.reactor {
            Observable.just(code)
                .map { .login($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
}
