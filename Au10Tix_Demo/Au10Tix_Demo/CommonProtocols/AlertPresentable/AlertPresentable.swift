//
//  AlertPresentable.swift
//  Au10Tix_Demo
//
//  Created by Anton Sakovych on 22.10.2020.
//

import UIKit

// MARK: - Alert

protocol AlertPresentable { }

extension AlertPresentable {// where Self: UIViewController {
    
    func presentErrorAlertWith(message: String? = nil) {
        presentErrorAlertWith(message: message, actions: [.okAction()])
    }
    
    func presentErrorAlertWith(message: String? = nil, actions: [UIAlertAction]) {
        presentAlertWith(title: "Error", message: message, actions: actions) // CommonKeys.error.key
    }
    
    func presentAlertWith(title: String? = nil,
                          message: String? = nil,
                          okAction: ((UIAlertAction) -> Void)? = nil,
                          cancelAction: ((UIAlertAction) -> Void)? = nil) {
        presentAlertWith(title: title, message: message, actions: [.okAction(okAction), .cancelAction(cancelAction)])
    }
    
    func presentAlertWith(title: String? = nil,
                          message: String? = nil,
                          actions: [UIAlertAction],
                          withDismissTap: Bool = true) {
        let alert = createAlert(with: title,
                                message: message,
                                preferredStyle: .alert,
                                actions: actions)
        (self as? UIViewController)?.present(alert, animated: true) {
            if withDismissTap {
                alert.addTapForDismiss()
            }
        }
    }
}

// MARK: - Alert private methods

private extension AlertPresentable {
    
    func createAlert(with title: String?,
                     message: String?,
                     preferredStyle: UIAlertController.Style,
                     actions: [UIAlertAction]) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { controller.addAction($0) }
        return controller
    }
    
}

extension UIAlertAction {
    
    static func okAction(_ action: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: "Ok", style: .default, handler: action) // "CommonKeys.ok.key"
    }
    
    static func cancelAction(_ action: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: action) // CommonKeys.cancel.key
    }
}


extension UIAlertController {
    
    override func addTapForDismiss() {
        let tapGest = UITapGestureRecognizer(target: self,
                                             action: #selector(dismissAnimated))
        view.superview?.subviews.first?.addGestureRecognizer(tapGest)
    }
    
}

extension UIViewController {
    
    @objc func addTapForDismiss() {
        let tapGest = UITapGestureRecognizer(target: self,
                                             action: #selector(dismissAnimated))
        view.addGestureRecognizer(tapGest)
    }
    
    @objc func dismissAnimated() {
        dismiss(animated: true, completion: nil)
    }
}
