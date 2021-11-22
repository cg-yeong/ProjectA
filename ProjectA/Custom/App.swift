//
//  App.swift
//  ProjectA
//
//  Created by inforex on 2021/07/27.
//

import UIKit

class App {
    class func visibleViewController(base: UIViewController? = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return visibleViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return visibleViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return visibleViewController(base: presented)
        }
        return base
    }
}
