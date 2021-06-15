//
//  SceneDelegate.swift
//  Github
//
//  Created by 박진 on 2021/06/15.
//

import AsyncDisplayKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var delegate: GithubAuthDelegate?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScence = (scene as? UIWindowScene) else { return }
            
        window = UIWindow(windowScene: windowScence)
        window?.windowScene = windowScence

        let rootViewController = GithubViewController()
        self.delegate = rootViewController
        
        let navigationContoller = ASNavigationController(rootViewController: rootViewController)
        navigationContoller.navigationBar.isTranslucent = false
        
        window?.rootViewController = navigationContoller
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if let code = url.absoluteString.split(separator: "=").last.map({ String($0) }) {
                delegate?.receiveCode(code: code)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}
