//
//  ProfileCellNode.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import AsyncDisplayKit
import RxSwift

class ProfileCellNode: ASCellNode {
    
    private enum Const {
        static let imageSize: CGSize = .init(width: 50, height: 50)
        
        static let nameFont: UIFont = .boldSystemFont(ofSize: 16)
        
        static let profileInsets: UIEdgeInsets = .init(top: 10,
                                                       left: 20,
                                                       bottom: 10,
                                                       right: 20)
    }
    
    lazy var imageNode = ASNetworkImageNode().then {
        $0.style.preferredSize = Const.imageSize
        $0.cornerRadius = Const.imageSize.height / 2
    }
    
    lazy var nameNode = ASTextNode()
    
    init(user: User) {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .systemBackground
        
        self.nameNode.attributedText = user.name.toAttributed(color: .label,
                                                              font: Const.nameFont)
        
        self.imageNode.url = URL(string: user.profileImage)
    }
}

extension ProfileCellNode {
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let profileLayout = self.profileLayoutSpec()
        
        return ASInsetLayoutSpec(insets: Const.profileInsets,
                                 child: profileLayout)
    }
    
    func profileLayoutSpec() -> ASLayoutSpec {
        let children: [ASLayoutElement] = [imageNode,
                                           nameNode]
        
        return ASStackLayoutSpec(direction: .horizontal,
                                 spacing: 20,
                                 justifyContent: .start,
                                 alignItems: .center,
                                 children: children)
    }
}
