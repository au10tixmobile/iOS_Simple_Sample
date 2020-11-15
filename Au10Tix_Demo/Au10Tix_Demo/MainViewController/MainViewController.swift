//
//  ViewController.swift
//  Au10Tix_Demo
//
//  Created by Anton Sakovych on 14.10.2020.
//

import UIKit
import Au10tixCore
import Au10tixCommon
import Au10PassiveFaceLiveness
import Au10SmartDocumentCaptureFeature
import AVFoundation
import PKHUD


final class MainViewController: UIViewController, AlertPresentable {
    
    // MARK: - Constants
    
    private struct Constants {
        static let holdAlfa: CGFloat = 0.3
        static let one: CGFloat = 1.0
        static let message: String = "The data couldn’t be read"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var btnSDC: UIButton!
    @IBOutlet private weak var btnPFL: UIButton!
    
    // MARK: - Private properties
    
    private let userSessionManager = UserSessionManager()
    private var tokenJWT = ""
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------
        
        // bind()
        holdActions()
        preparation()
    }
    
    // showSDCUIComponent
    
    @IBAction func showPFLUIComponent() {
        
        let configs = UIComponentConfigs(appLogo: UIImage(), // add logo
                                         actionButtonTint: UIColor.red,// add Tint:
                                         titleTextColor: UIColor.blue,// add title:
                                         errorTextColor: UIColor.green,// add error:
                                         canUploadImage: true,
                                         showCloseButton: true)
        
        let viewController = PFLViewController(configs: configs, delegate: self)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    // showSDCUIComponent
    
    @IBAction func showSDCUIComponent() {
        
        let configs = UIComponentConfigs(appLogo: UIImage(),
                                         actionButtonTint: UIColor.red,
                                         titleTextColor: UIColor.blue,
                                         errorTextColor: UIColor.green,
                                         canUploadImage: true,
                                         showCloseButton: true)
        
        let viewController = SDCViewController(configs: configs, delegate: self)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}

// MARK: - MainViewController

private extension MainViewController {
    
    
    
    
    // MARK: - Autorisation
    
    func preparation() {
        
        
        
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        userSessionManager.getJWTToken(token: nil, onSuccess: { tokenData in
            
            self.tokenJWT = tokenData.accessToken
            
            self.prepareSDCUIComponent(tokenData.accessToken)
            
            DispatchQueue.main.async {
                self.unholdActions()
                PKHUD.sharedHUD.hide()
            }
            
        }) { error in
            
            DispatchQueue.main.async {
                PKHUD.sharedHUD.hide()
                self.presentErrorAlertWith(message: Constants.message)
            }
        }
    }
    
    
    
    
    
    // Prepare SDK
    
    func prepareSDCUIComponent(_ token: String) {
        
        Au10tixCore.shared.prepare(with: token) { result in
            switch result {
            case .success( let sesssionId):
                
                PKHUD.sharedHUD.hide()
            case .failure(let error):
                PKHUD.sharedHUD.hide()
            }
        }
    }
    
    
    
    
    
    
    // MARK: - hold / unhold Actions
    
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
    
    @IBAction func btnSDCAction() {
        pushToPFLViewController(with: tokenJWT)
    }
    
    @IBAction func btnPFLAction() {
        showSDCViewContrller(with: tokenJWT)
    }
}

// MARK: - MainViewControllerOutput

extension MainViewController {
    
    
    func pushToPFLViewController(with viewModel: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "PFLUIViewController") as? PFLUIViewController else {
            return
        }
        
        //controller.accessToken = viewModel
        
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showSDCViewContrller(with viewModel: String) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "SDCUIViewController") as? SDCUIViewController else {
            return
        }
    
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: Au10tixSessionDelegate

extension MainViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        debugPrint(" update ------------------------- \(update)")
    }
    
    func didGetError(_ error: Au10tixSessionError) {
        debugPrint(" error -------------------- \(error)")
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        debugPrint(" result ----------------------------- \(result)")
        
        
        if result.isKind(of: SmartDocumentCaptureSessionResult.self) {
            
            //            documentCaptureSessionResultImage = result.image
            //            showResults()
        }
    }
}
