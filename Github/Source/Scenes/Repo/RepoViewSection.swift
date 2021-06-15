//
//  ProfileViewSection.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import RxDataSources_Texture

enum RepoViewSection {
    case repo(repos: [RepoViewSectionItem])
}

extension RepoViewSection: AnimatableSectionModelType {
    
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .repo:
            return "repo"
        }
    }
    
    var items: [RepoViewSectionItem] {
        switch self {
        case .repo(let repos):
            return repos
        }
    }
    
    init(original: RepoViewSection, items: [RepoViewSectionItem]) {
        switch original {
        case .repo:
            self = .repo(repos: items)
        }
    }
}

enum RepoViewSectionItem {
    case repo(Repo)
}

extension RepoViewSectionItem: IdentifiableType {
    typealias Identity = Double
    
    var identity: Double {
        switch self {
        case .repo(let repo):
            return repo.id
        }
    }
}

extension RepoViewSectionItem: Equatable {
    
    static func == (lhs: RepoViewSectionItem, rhs: RepoViewSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
