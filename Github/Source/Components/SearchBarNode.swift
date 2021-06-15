//
//  SearchBarNode.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import AsyncDisplayKit

class SearchBarNode: ASDisplayNode {
    
    private enum Const {
        static let sendImage = UIImage(systemName: "arrow.forward.circle.fill")
        
        static let sendSize: CGSize = .init(width: 20, height: 20)
        
        static let searchBarInsets: UIEdgeInsets = .init(top: 0,
                                                         left: 10,
                                                         bottom: 0,
                                                         right: 10)
    }
    
    lazy var searchField = UITextField()
    
    lazy var sendNode = ASImageNode().then {
        $0.image = Const.sendImage
        $0.style.preferredSize = Const.sendSize
    }
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let searchBarLayout = self.searchBarLayoutSpec()
        
        return ASInsetLayoutSpec(insets: Const.searchBarInsets,
                                 child: searchBarLayout)
    }
    
    func searchBarLayoutSpec() -> ASLayoutSpec {
        let searchNode = searchField.toNode().then {
            $0.style.flexGrow = 1
        }
        
        let children: [ASLayoutElement] = [searchNode,
                                           sendNode]
        
        return ASStackLayoutSpec(direction: .horizontal,
                                 spacing: 0,
                                 justifyContent: .spaceBetween,
                                 alignItems: .center,
                                 children: children)
    }
}
