//
//  UIView+Ex.swift
//  Github-App
//
//  Created by 박진 on 2021/06/03.
//

import AsyncDisplayKit
import RxSwift
import MBProgressHUD

extension UIView {
    
    func toNode() -> ASDisplayNode {
        return ASDisplayNode(viewBlock: { self })
    }
}

extension Reactive where Base: UIView {
    
    var loading: Binder<Bool> {
        Binder(base) { view, isLoading in
            if (isLoading) {
                let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
                progressHUD.mode = .indeterminate
                progressHUD.label.text = "로딩중"
            } else {
                MBProgressHUD.hide(for: view, animated: true)
            }
        }
    }
    
    var error: Binder<String> {
        Binder(base) { view, message in
            let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
            progressHUD.mode = .determinate
            progressHUD.label.text = message
            progressHUD.hide(animated: true, afterDelay: 1)
        }
    }
    
    var success: Binder<String> {
        Binder(base) { view, message in
            let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
            progressHUD.mode = .customView
            progressHUD.customView = UIImageView(image: UIImage(systemName: "checkmark"))
            progressHUD.label.text = message
            progressHUD.isSquare = true
            progressHUD.hide(animated: true, afterDelay: 1)
        }
    }
}
