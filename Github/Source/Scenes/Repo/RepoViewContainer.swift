//
//  RepoViewContainer.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import AsyncDisplayKit

class RepoViewContainer: ASDisplayNode {
    
    private enum Const {
        static let searchBarSize: CGSize = .init(width: UIScreen.main.bounds.width, height: 40)
        
        static let searchBarPlaceholder: String = "Repository 이름을 입력해주세요."
    }
    
    lazy var searchBarNode = SearchBarNode().then {
        $0.style.preferredSize = Const.searchBarSize
        $0.searchField.placeholder = Const.searchBarPlaceholder
        $0.backgroundColor = .systemGray6
    }
    
    lazy var tableNode = ASTableNode().then {
        $0.style.flexGrow = 1
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .systemBackground
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let children: [ASLayoutElement] = [
            searchBarNode,
            tableNode
        ]
        
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 0,
                                 justifyContent: .start,
                                 alignItems: .start,
                                 children: children)
    }
}
