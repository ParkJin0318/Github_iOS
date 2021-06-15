//
//  Networking+Ex.swift
//  Github-App
//
//  Created by 박진 on 2021/06/02.
//

import RxSwift
import Alamofire
import Moya

extension MoyaProvider: ReactiveCompatible {}

public extension Reactive where Base: MoyaProviderType {
    
    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Moya.Response> {
        return Single.create { [weak base] single in
                
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                    case let .success(response):
                        single(.success(response))
                                    
                    case let .failure(error):
                        var errorMessage: String = "네트워크 오류"
                                                    
                        if let response = error.response {
                            let response = try? JSONDecoder().decode(MessageResponse.self, from: response.data)
                                                    
                            if let message = response?.message {
                                errorMessage = message
                            }
                        }
                        single(.failure(GithubError.error(message: errorMessage)))
                    }
                }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }.timeout(RxTimeInterval.seconds(5), scheduler: MainScheduler.asyncInstance)
        .catch {
            if let error = $0 as? RxError,
                case .timeout = error {
                    return .error(GithubError.error(message: "요청시간 만료"))
                }
                return .error($0)
            }
        }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
    
    func map<D: Decodable>(_ type: D.Type) -> Single<D> {
        return flatMap { .just(try $0.map(type, atKeyPath: nil, using: JSONDecoder(), failsOnEmptyData: true)) }
    }
}
