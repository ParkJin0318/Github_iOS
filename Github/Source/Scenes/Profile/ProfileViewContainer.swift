//
//  ProfileViewContainer.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import AsyncDisplayKit
import RxSwift

class ProfileViewContainer: ASDisplayNode {
    
    private enum Const {
        static let indicationText: String = "로그인이 필요합니다."
        
        static let indicationFont: UIFont = .boldSystemFont(ofSize: 16)
        
        static let tableInsets: UIEdgeInsets = .zero
        
        static let indicationInsets: UIEdgeInsets = .init(top: .infinity,
                                                          left: .infinity,
                                                          bottom: .infinity,
                                                          right: .infinity)
    }
    
    var isCurrentLogin: Bool = false
    
    lazy var indicationNode = ASTextNode().then {
        $0.attributedText = Const.indicationText.toAttributed(color: .label, font: Const.indicationFont)
    }
    
    lazy var tableNode = ASTableNode()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .systemBackground
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let child: ASLayoutElement = isCurrentLogin ? tableNode : indicationNode
        let insets: UIEdgeInsets = isCurrentLogin ? Const.tableInsets : Const.indicationInsets
        
        return ASInsetLayoutSpec(insets: insets, child: child)
    }
}

extension Reactive where Base: ProfileViewContainer {
    
    var isCurrentLogin: Binder<Bool> {
        Binder(base) { base, isLogin in
            base.isCurrentLogin = isLogin
            base.setNeedsLayout()
        }
    }
}
