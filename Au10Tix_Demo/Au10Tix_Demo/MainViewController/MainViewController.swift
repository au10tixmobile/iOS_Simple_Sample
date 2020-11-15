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
    @IBOutlet private weak var btnSDCwithUI: UIButton!
    @IBOutlet private weak var btnPFLwithUI: UIButton!

    // MARK: - Private properties
    
    private let userSessionManager = UserSessionManager()

    private var resultImage: UIImage?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------
        holdActions()
        preparation()
    }
}

// MARK: - MainViewControllerActions

extension MainViewController {
    
    // MARK: - Actions
    
    @IBAction func btnSDCAction() {
        pushToPFLViewController()
    }
    
    @IBAction func btnPFLAction() {
        showSDCViewContrller()
    }
    
    @IBAction func btnSDCwithUIAction() {
        showSDCUIComponent()
    }
    
    @IBAction func btnPFLwithUIAction() {
        showPFLUIComponent()
    }
}


// MARK: - MainViewController

private extension MainViewController {
    
    // MARK: - SSDK Preparation
    
    func preparation() {
        
        userSessionManager.getJWTToken(token: nil, onSuccess: { tokenData in
            DispatchQueue.main.async {
                self.prepareSDCUIComponent(tokenData.accessToken)
            }
        }) { error in
            DispatchQueue.main.async {
                self.presentErrorAlertWith(message: Constants.message)
            }
        }
    }
    
    func prepareSDCUIComponent(_ token: String) {
        
        Au10tixCore.shared.prepare(with: token) { result in
            switch result {
            case .success(_):
                
                self.unholdActions()
            case .failure(_):
                self.presentErrorAlertWith(message: Constants.message)
                
            }
        }
    }
    
    // MARK: - hold / unhold Actions
    
    func holdActions() {
        btnSDC.isUserInteractionEnabled = false
        btnSDC.alpha = Constants.holdAlfa
        btnPFL.isUserInteractionEnabled = false
        btnPFL.alpha = Constants.holdAlfa
        
        btnSDCwithUI.isUserInteractionEnabled = false
        btnSDCwithUI.alpha = Constants.holdAlfa
        btnPFLwithUI.isUserInteractionEnabled = false
        btnPFLwithUI.alpha = Constants.holdAlfa
    }
    
    func unholdActions() {
        btnSDC.isUserInteractionEnabled = true
        btnSDC.alpha = Constants.one
        btnPFL.isUserInteractionEnabled = true
        btnPFL.alpha = Constants.one
        btnSDCwithUI.isUserInteractionEnabled = true
        btnSDCwithUI.alpha =  Constants.one
        btnPFLwithUI.isUserInteractionEnabled = true
        btnPFLwithUI.alpha =  Constants.one
    }
    
    // MARK: - showSDCUIComponent
    
    func showSDCUIComponent() {

        let configs = UIComponentConfigs(appLogo: UIImage(),
                                         actionButtonTint: UIColor.green,
                                         titleTextColor: UIColor.green,
                                         errorTextColor: UIColor.green,
                                         canUploadImage: true,
                                         showCloseButton: true)
        
        let viewController = SDCViewController(configs: configs, delegate: self)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - showSDCUIComponent
    
    func showPFLUIComponent() {

        let configs = UIComponentConfigs(appLogo: UIImage(),
                                         actionButtonTint: UIColor.green,
                                         titleTextColor: UIColor.green,
                                         errorTextColor: UIColor.green,
                                         canUploadImage: true,
                                         showCloseButton: true)
        
        let viewController = PFLViewController(configs: configs, delegate: self)
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - PFLViewController
    
    func pushToPFLViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "PFLUIViewController") as? PFLUIViewController else {
            return
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - SDCViewContrller
    
    func showSDCViewContrller() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "SDCUIViewController") as? SDCUIViewController else {
            return
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - SDCViewContrller
    
    func openResults() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.documentCaptureSessionResultImage = resultImage
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: Au10tixSessionDelegate

extension MainViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        
        if update.isKind(of: SmartDocumentCaptureSessionUpdate.self) {
            
            let tesst = update as! SmartDocumentCaptureSessionUpdate
            print(tesst.blurScore)
            print(tesst.blurStatus)
            print(tesst.darkStatus)
            print(tesst.idStatus)
            print(tesst.isResult)
            print(tesst.isValidDocument)
            
            print(tesst.reflectionStatus)
            print(tesst.stabilityStatus?.rawValue as Any)
        }
        
        debugPrint(" update ------------------------- \(update)")
    }
    
    func didGetError(_ error: Au10tixSessionError) {
        debugPrint(" error -------------------- \(error)")
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        if result.isKind(of: PassiveFaceLivenessSessionResult.self) {
            
            let faceLivenessSessionResult = result as! PassiveFaceLivenessSessionResult
            
            resultImage = UIImage(data: faceLivenessSessionResult.imageData)
            openResults()
        }
        
        if result.isKind(of: SmartDocumentCaptureSessionResult.self) {
            
            resultImage = result.image?.uiImage
            openResults()
        }
    }
}
