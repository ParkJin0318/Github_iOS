//
//  GithubApiSpec.swift
//  GithubTests
//
//  Created by 박진 on 2021/06/15.
//

import XCTest
import RxSwift
import Quick
import Nimble

@testable import Github

class GithubApiSpec: QuickSpec {
    
    override func spec() {
        var disposeBag: DisposeBag!
        var testApiType: GithubTestApiType!
        var testRepos: [Repo] = []
        
        describe("github search repositoy api test") {
            beforeEach {
                disposeBag = DisposeBag()
                
                testApiType = DependencyProvider.resolve(GithubTestApiType.self)
                
                testRepos = [
                    Repo(id: 81514066.0,
                         name: "TextureGroup/Texture",
                         description: "Smooth asynchronous user interfaces for iOS apps.",
                         starCount: 7126.0)
                ]
            }
            
            it("return entires equal testRepos") {
                var repos: [Repo] = []
                
                testApiType.getRepos(name: "Texture")
                    .subscribe(onSuccess: {
                        repos = $0
                    }).disposed(by: disposeBag)
                
                expect(repos).toEventually(equal(testRepos), timeout: .seconds(5))
            }
        }
    }
}
