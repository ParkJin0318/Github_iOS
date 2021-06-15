//
//  GithubAPI.swift
//  Github-App
//
//  Created by 박진 on 2021/06/02.
//

import Moya

enum GithubAPI {
    case getToken(code: String)
    case getUserProfile
    case getUserRepos(page: Int)
    case getRepos(name: String, page: Int)
    case getRepoStarred(name: String)
    case starredRepo(name: String)
    case unstarredRepo(name: String)
}

extension GithubAPI: TargetType {
    
    var baseURL: URL {
        switch self {
            case .getToken:
                return URL(string: auth_url)!
            default:
                return URL(string: base_url)!
        }
    }
    
    var path: String {
        switch self {
            case .getToken:
                return "/access_token"
            case .getUserProfile:
                return "/user"
            case .getUserRepos:
                return "/user/repos"
            case .getRepos:
                return "/search/repositories"
            case .getRepoStarred(let name):
                return "user/starred/\(name)"
            case .starredRepo(let name):
                return "user/starred/\(name)"
            case .unstarredRepo(let name):
                return "user/starred/\(name)"
        }
    }
    
    var method: Method {
        switch self {
            case .getToken:
                return .post
            case .getUserProfile:
                return .get
            case .getUserRepos:
                return .get
            case .getRepos:
                return .get
            case .getRepoStarred:
                return .get
            case .starredRepo:
                return .put
            case .unstarredRepo:
                return .delete
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getRepos(let name, _):
            return Data(
                """
                {
                    "total_count": 1,
                    "incomplete_results": false,
                    "items": [
                        {
                            "id": 81514066,
                            "full_name": "TextureGroup/\(name)",
                            "description": "Smooth asynchronous user interfaces for iOS apps.",
                            "stargazers_count": 7126,
                        },
                    ]
                }
                """.utf8
            )
            
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
            case .getToken(let code):
                let params: [String: Any] = [
                    "client_id": client_id,
                    "client_secret": client_secret,
                    "code": code
                ]
                
                return .requestParameters(parameters: params,
                                          encoding: URLEncoding.queryString)
                
            case .getUserProfile:
                return .requestPlain
                    
            case .getUserRepos(let page):
                let params: [String: Any] = [
                    "page": page
                ]
                
                return .requestParameters(parameters: params,
                                          encoding: URLEncoding.queryString)
                
            case .getRepos(let name, let page):
                let params: [String: Any] = [
                    "q": name,
                    "page": page
                ]
                
                return .requestParameters(parameters: params,
                                          encoding: URLEncoding.queryString)
                
            case .getRepoStarred:
                return .requestPlain
                
            case .starredRepo:
                return .requestPlain
                
            case .unstarredRepo:
                return .requestPlain
        }
    }
    
    var validationType: Moya.ValidationType {
        return .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        var headers = ["Accept": "application/vnd.github.v3+json"]
        headers["Authorization"] = DependencyProvider.resolve(AuthController.self).getToken()
        return headers
    }
}
