//
//  ProviderType.swift
//  Github-App
//
//  Created by 박진 on 2021/06/08.
//

import Moya
import Alamofire
import RxSwift

public protocol ProviderType: AnyObject {
    associatedtype T: TargetType
    
    var provider: MoyaProvider<T> { get set }
    init(isStub: Bool, sampleStatusCode: Int)
}

public extension ProviderType {
    
    static func consProvider(_ isStub: Bool = false,
                             _ sampleStatusCode: Int = 200) -> MoyaProvider<T> {
        
        if isStub == false {
            return MoyaProvider<T>(
                endpointClosure: { (target: T) -> Endpoint in
                    MoyaProvider<T>.defaultEndpointMapping(for: target).adding(newHTTPHeaderFields: target.headers!)
                }
            )
        } else {
            let endpointClosure = { (target: T) -> Endpoint in
                let sampleResponseClosure: () -> EndpointSampleResponse = {
                    EndpointSampleResponse.networkResponse(sampleStatusCode, target.sampleData)
                }
                
                return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: sampleResponseClosure,
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)
            }
            
            return MoyaProvider<T>(endpointClosure: endpointClosure,
                                   stubClosure: MoyaProvider.immediatelyStub(_:))
        }
    }
}
