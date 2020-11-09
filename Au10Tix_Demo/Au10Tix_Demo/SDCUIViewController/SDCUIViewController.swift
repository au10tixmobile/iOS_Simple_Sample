//
//  SDCUIViewController.swift
//  Au10Tix_Demo
//
//  Created by Anton Sakovych on 15.10.2020.
//
import UIKit
import Au10tixCore
import Au10tixCommon
import Au10SmartDocumentCaptureFeature
import PKHUD

final class SDCUIViewController: BaseViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let successMessage: String = "Success"
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var lblResult: UILabel!
    @IBOutlet weak private var imResult: UIImageView!
    
    // MARK: - Pablic properties
    
    var accessToken = ""
    
    // MARK: - Private properties
    
    private var documentCaptureSessionResultImage: Au10Image?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ------
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        prepareSDCUIComponent(accessToken)
    }
}

// MARK: Private Methods

private extension SDCUIViewController {
    
    // Prepare SDK
    
    func prepareSDCUIComponent(_ token: String) {
        
        Au10tixCore.shared.prepare(with: token) { result in
            switch result {
            case .success( _):
                Au10tixCore.shared.delegate = self
                self.showSDCUIComponent()
                PKHUD.sharedHUD.hide()
            case .failure(let error):
                PKHUD.sharedHUD.hide()
                self.presentErrorAlertWith(message: "Failed with error \(error)")
            }
        }
    }
    
    // showSDCUIComponent
    
    func showSDCUIComponent() {
        
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
    
    func showResults() {
        lblResult.isHidden = false
        imResult.isHidden = false
        lblResult.text = Constants.successMessage
        imResult.image = documentCaptureSessionResultImage?.uiImage
    }
}

// MARK: Au10tixSessionDelegate

extension SDCUIViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        print(" update ------------------------- \(update)")
    }
    
    func didGetError(_ error: Au10tixSessionError) {
        print(" error -------------------- \(error)")
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        print(" result ----------------------------- \(result)")
        
        
        if result.isKind(of: SmartDocumentCaptureSessionResult.self) {
            
            documentCaptureSessionResultImage = result.image
            showResults()
        }
    }
}
