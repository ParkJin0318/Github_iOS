//
//  ProfileViewController.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import AsyncDisplayKit
import RxDataSources_Texture
import ReactorKit

class ProfileViewController: ASDKViewController<ProfileViewContainer> {
    
    lazy var disposeBag = DisposeBag()
    
    var profileDataSource: RxASTableSectionedAnimatedDataSource<ProfileViewSection>!
    
    private var batchContext: ASBatchContext?
    private var repoId: Double? = nil
    private var currentPage: Int = 1
    
    override init() {
        super.init(node: ProfileViewContainer())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileViewController: View {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDataSource()
        reactor = DependencyProvider().container.resolve(ProfileViewReactor.self)
    }
    
    private func setupDataSource() {
        profileDataSource = RxASTableSectionedAnimatedDataSource<ProfileViewSection>(
            configureCellBlock: { dataSource, tableNode, indexPath, sectionItem in
                switch sectionItem {
                case .profile(let user):
                    return { ProfileCellNode(user: user) }
                case .repo(let repo):
                    return {
                        let cell = RepoCellNode()
                        cell.reactor = RepoCellReactor(service: DependencyProvider().container.resolve(RepoServiceType.self)!,
                                                       repo: repo)
                        return cell
                    }
                }
            })
    }
    
    func bind(reactor: ProfileViewReactor) {
        // Action
        node.tableNode.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        node.tableNode.rx.willBeginBatchFetch
            .do(onNext: { [weak self] context in
                self?.batchContext = context
            }).map { _ in }
            .bind(onNext: moreLoadRepos)
            .disposed(by: disposeBag)
        
        // State
        reactor.state
            .map { $0.isCurrentLogin }
            .distinctUntilChanged()
            .bind(to: node.rx.isCurrentLogin)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.userProfile }
            .filter { $0 != nil }
            .map { $0! }
            .do(onNext: { [weak self] profile in
                self?.repoId = profile.1.last?.id
                self?.batchContext?.completeBatchFetching(true)
            })
            .map { user, repos -> [ProfileViewSection] in
                var sections: [ProfileViewSectionItem] = []
                        
                sections.append(ProfileViewSectionItem.profile(user))
                sections.append(contentsOf: repos.map { ProfileViewSectionItem.repo($0) })
                        
                return [ProfileViewSection.userRepo(userRepos: sections)]
            }
            .bind(to: node.tableNode.rx.items(dataSource: profileDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: view.rx.loading)
            .disposed(by: disposeBag)
                
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .filter { $0 != nil }
            .map { $0! }
            .do(onNext: { [weak self] _ in
                self?.repoId = nil
                self?.batchContext = nil
            })
            .bind(to: view.rx.error)
            .disposed(by: disposeBag)
    }
    
    private func moreLoadRepos() {
        if let reactor = self.reactor {
            currentPage += 1
            Observable.just(currentPage)
                .distinctUntilChanged()
                .map { .getUserProfile(true, $0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
}

extension ProfileViewController: ASTableDelegate {
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return self.repoId != nil
    }
}
