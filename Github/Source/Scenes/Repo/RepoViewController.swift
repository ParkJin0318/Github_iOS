//
//  RepoViewController.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import AsyncDisplayKit
import RxDataSources_Texture
import RxTexture2
import RxCocoa
import ReactorKit
import Then

class RepoViewController: ASDKViewController<RepoViewContainer> {
    
    lazy var disposeBag = DisposeBag()
    
    var repoDataSource: RxASTableSectionedAnimatedDataSource<RepoViewSection>!
    
    private var batchContext: ASBatchContext?
    private var repoId: Double? = nil
    private var currentPage: Int = 1
    
    override init() {
        super.init(node: RepoViewContainer())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var service: RepoService!
}

extension RepoViewController: View {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDataSource()
        reactor = DependencyProvider.resolve(RepoViewReactor.self)
    }
    
    private func setupDataSource() {
        repoDataSource = RxASTableSectionedAnimatedDataSource<RepoViewSection>(
            configureCellBlock: { dataSource, tableNode, indexPath, sectionItem in
                switch sectionItem {
                case .repo(let repo):
                    return {
                        let cell = RepoCellNode()
                        cell.reactor = RepoCellReactor(service: DependencyProvider.resolve(RepoServiceType.self),
                                                       repo: repo)
                        return cell
                    }
                }
            })
    }
    
    func bind(reactor: RepoViewReactor) {
        // Action
        node.tableNode.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        node.searchBarNode.searchField.rx.text.orEmpty
            .map { .repoName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.searchBarNode.sendNode.rx.tap
            .map { .getRepos() }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.tableNode.rx.willBeginBatchFetch
            .do(onNext: { [weak self] context in
                self?.batchContext = context
            }).map { _ in }
            .bind(onNext: moreLoadRepos)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.repoName }
            .map { $0.isEmpty }
            .bind(to: node.searchBarNode.sendNode.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.repos }
            .distinctUntilChanged()
            .do(onNext: { [weak self] repos in
                self?.repoId = repos.last?.id
                self?.batchContext?.completeBatchFetching(true)
            })
            .map { $0.map { RepoViewSectionItem.repo($0) } }
            .map { [RepoViewSection.repo(repos: $0)] }
            .bind(to: node.tableNode.rx.items(dataSource: repoDataSource))
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
                .map { .getRepos($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
}

extension RepoViewController: ASTableDelegate {
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return self.repoId != nil
    }
}
