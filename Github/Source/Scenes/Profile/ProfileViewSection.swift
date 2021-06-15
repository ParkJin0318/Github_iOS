//
//  ProfileViewSection.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import RxDataSources_Texture

enum ProfileViewSection {
    case userRepo(userRepos: [ProfileViewSectionItem])
}

extension ProfileViewSection: AnimatableSectionModelType {
    
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .userRepo:
            return "userRepo"
        }
    }
    
    var items: [ProfileViewSectionItem] {
        switch self {
        case .userRepo(let userRepos):
            return userRepos
        }
    }
    
    init(original: ProfileViewSection, items: [ProfileViewSectionItem]) {
        switch original {
        case .userRepo:
            self = .userRepo(userRepos: items)
        }
    }
}

enum ProfileViewSectionItem {
    case profile(User)
    case repo(Repo)
}

extension ProfileViewSectionItem: IdentifiableType {
    typealias Identity = Double
    
    var identity: Double {
        switch self {
        case .profile(let profile):
            return profile.id
            
        case .repo(let repo):
            return repo.id
        }
    }
}

extension ProfileViewSectionItem: Equatable {
    
    static func == (lhs: ProfileViewSectionItem, rhs: ProfileViewSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
