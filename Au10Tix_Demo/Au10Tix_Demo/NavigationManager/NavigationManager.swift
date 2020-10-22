//
//  NavigationManager.swift
//  Au10Tix_Demo
//
//  Created by Anton Sakovych on 20.10.2020.
//

import Foundation

import UIKit

final class NavigationManager: NSObject {
    
    // MARK: Private properties
    
    private var controller: UIViewController?
    
    private var navController: UINavigationController?
    
    // MARK: - Public properties
    
    static var overCurrent: NavigationManager {
        let topController = UIApplication.topViewController()
        if let navigation = topController?.navigationController {
            return NavigationManager(navigation)
        } else {
            return NavigationManager(controller: topController)
        }
    }
    
    // MARK: - Initializer
    
    init(_ navigationController: UINavigationController? = nil) {
        navController = navigationController
    }
    
    private init(controller: UIViewController?) {
        self.controller = controller
    }
}

// MARK: PUSH methods
extension NavigationManager {
    
    func pushToPFLViewController(with viewModel: String) {
        guard let controller = Storyboards.Main.pFLUIViewController.controller as? PFLUIViewController else {
            return
        }
        
        controller.accessToken = viewModel
        
        navController?.pushViewController(controller, animated: true)
    }
    
    func showSDCViewContrller(with viewModel: String) {
        guard let controller = Storyboards.Main.sDCUIViewController.controller as? SDCUIViewController else {
            return
        }
        
        controller.accessToken = viewModel
        
        navController?.pushViewController(controller, animated: true)
    }
}

// MARK: - Private methods

private extension NavigationManager {
    
    func showController(_ controller: UIViewController) {
        (navController ?? self.controller)?.show(controller, sender: nil)
    }
    
    func pushController(_ controller: UIViewController) {
        navController?.pushViewController(controller, animated: true)
    }
    
    func presentController(_ controller: UIViewController, completion: (() -> Void)? = nil) {
        (navController ?? self.controller)?.present(controller, animated: true, completion: completion)
    }
}

// MARK: - UIApplication

fileprivate extension UIApplication {
    
    class func topViewController(_ base: UIViewController?
        = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = base as? UINavigationController, navigationController.viewControllers.count > 0 {
            return topViewController(navigationController.visibleViewController)
        }
        
        if let tabBarController = base as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presentedViewController = base?.presentedViewController {
            return topViewController(presentedViewController)
        }
        
        return base
    }
    
}

// MARK: - UINavigationController

fileprivate extension UINavigationController {
    
    func setupDismissButton(with image: UIImage? = nil, title: String?, action: Selector? = nil, target: Any? = nil) {
        let leftButton = UIBarButtonItem(image: image,
                                         style: .plain,
                                         target: target ?? self,
                                         action: action ?? #selector(backButtonClicked))
        leftButton.title = title
        navigationBar.topItem?.leftBarButtonItem = leftButton
    }
    
    @objc func backButtonClicked(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
