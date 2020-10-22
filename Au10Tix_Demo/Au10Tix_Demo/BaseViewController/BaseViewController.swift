//
//  BaseViewController.swift
//  Au10tix
//
//  Created by Anton Sakovych on 09.06.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, AlertPresentable {
    
    var animator: UIViewPropertyAnimator!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarAppearance()
        //   setNavigationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animator?.pauseAnimation()
        animator?.stopAnimation(true)
        animator?.finishAnimation(at: .current)
    }
    
    // -------------
    func updateNavigationBarAppearance() {
        guard let navigationController = self.navigationController else {
            return
        }
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.shadowImage = UIImage()
    }
    
    func updateFrame(value: CGFloat) {
        
    }
    
    func updateAppearance(value: CGFloat) {
        
    }
}

extension BaseViewController {
    @IBAction func leftAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
