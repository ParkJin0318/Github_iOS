//
//  RepoCellNode.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import AsyncDisplayKit
import ReactorKit
import RxSwift

let pressStarred = BehaviorSubject<String?>(value: nil)
let cellErrorMessage = BehaviorSubject<String?>(value: nil)

class RepoCellNode: ASCellNode, View {
    
    private enum Const {
        static let starSize: CGSize = .init(width: 20, height: 20)
        
        static let startImage: UIImage? = UIImage(systemName: "star")
        
        static let nameFont: UIFont = .boldSystemFont(ofSize: 14)
        
        static let descriptionFont: UIFont = .systemFont(ofSize: 12)
        
        static let repoInsets: UIEdgeInsets = .init(top: 10,
                                                    left: 10,
                                                    bottom: 10,
                                                    right: 10)
    }
    
    lazy var disposeBag = DisposeBag()
    
    lazy var nameNode = ASTextNode()
    
    lazy var descriptionNode = ASTextNode()
    
    lazy var starCountNode = ASTextNode()
    
    lazy var starNode = ASImageNode().then {
        $0.style.preferredSize = Const.starSize
        $0.image = Const.startImage
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .systemBackground
    }
    
    func bind(reactor: RepoCellReactor) {
        // Action
        Observable.just(.initStarred)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        starNode.rx.tap
            .map { .starredRepo }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.name }
            .map { $0.toAttributed(color: .label, font: Const.nameFont) }
            .bind(to: nameNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.description.toAttributed(color: .label, font: Const.descriptionFont) }
            .bind(to: descriptionNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state.map { "\($0.starCount)".toAttributed(color: .label, font: Const.descriptionFont) }
            .bind(to: starCountNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isStarred }
            .distinctUntilChanged()
            .map {  $0 ? UIImage(systemName: "star.fill") : UIImage(systemName: "star") }
            .bind(to: starNode.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.refreshStar }
            .distinctUntilChanged()
            .filter { $0 != nil }
            .bind(to: pressStarred)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .filter { $0 != nil }
            .bind(to: cellErrorMessage)
            .disposed(by: disposeBag)
    }
}

extension RepoCellNode {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let repoInfoLayout = self.repoInfoLayoutSpec()
        
        return ASInsetLayoutSpec(insets: Const.repoInsets,
                                 child: repoInfoLayout)
    }
    
    func repoBottomLayoutSpec() -> ASLayoutSpec {
        let children: [ASLayoutElement] = [starCountNode,
                                           starNode]
        
        return ASStackLayoutSpec(direction: .horizontal,
                                 spacing: 0,
                                 justifyContent: .spaceBetween,
                                 alignItems: .center,
                                 children: children)
    }
    
    func repoInfoLayoutSpec() -> ASLayoutSpec {
        let repoBottomLayout = self.repoBottomLayoutSpec()
        
        let children: [ASLayoutElement] = [nameNode,
                                           descriptionNode,
                                           repoBottomLayout]
        
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 5,
                                 justifyContent: .start,
                                 alignItems: .stretch,
                                 children: children)
    }
}
