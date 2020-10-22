//
//  ViewController.swift
//  Au10Tix_Demo
//
//  Created by Anton Sakovych on 14.10.2020.
//

import UIKit
import Au10tixCore
import PKHUD

final class MainViewController: BaseViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let holdAlfa: CGFloat = 0.3
        static let one: CGFloat = 1.0
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var btnSDC: BaseButton!
    @IBOutlet private weak var btnPFL: BaseButton!
    
    // MARK: - Private properties
    
    private let userSessionManager = UserSessionManager()
    private var tokenJWT = ""
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------
        
        bind()
        holdActions()
        autorisation()
    }
}

// MARK: - MainViewController

private extension MainViewController {
    
    // MARK: - Bind
    
    func bind() {
        btnSDC.bind { _ in
            self.btnSDCAction()
        }
        btnPFL.bind { _ in
            self.btnPFLAction()
        }
    }
    
    // MARK: - Autorisation
    
    func autorisation() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        userSessionManager.getJWTToken(jwtToken: "", onSuccess: { tokenData in
            
            self.tokenJWT = tokenData.accessToken
            
            DispatchQueue.main.async {
                self.unholdActions()
                PKHUD.sharedHUD.hide()
            }
            
        }) { error in
            
            DispatchQueue.main.async {
                PKHUD.sharedHUD.hide()
                self.presentErrorAlertWith(message:"The data couldn’t be read")
            }
        }
    }
    
    func holdActions() {
        btnSDC.isUserInteractionEnabled = false
        btnSDC.alpha = Constants.holdAlfa
        btnPFL.isUserInteractionEnabled = false
        btnPFL.alpha = Constants.holdAlfa
    }
    
    func unholdActions() {
        btnSDC.isUserInteractionEnabled = true
        btnSDC.alpha = Constants.one
        btnPFL.isUserInteractionEnabled = true
        btnPFL.alpha = Constants.one
    }
    
    // MARK: - Actions
    
    func btnSDCAction() {
        showSDCViewContrller(with: tokenJWT)
    }
    
    func btnPFLAction() {
        showPFLViewContrller(with: tokenJWT)
    }
}

// MARK: - MainViewControllerOutput

extension MainViewController  {
    
    func showPFLViewContrller(with tokenJWT: String) {
        NavigationManager(navigationController).pushToPFLViewController(with: tokenJWT)
    }
    
    func showSDCViewContrller(with tokenJWT: String) {
        NavigationManager(navigationController).showSDCViewContrller(with: tokenJWT)
    }
}
