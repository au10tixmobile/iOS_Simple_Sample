//
//  PFLUIViewController.swift
//  Au10Tix_Demo
//
//  Created by Anton Sakovych on 15.10.2020.
//

import UIKit
import Au10tixCore
import Au10tixCommon
import Au10PassiveFaceLiveness
import AVFoundation
import PKHUD

final class PFLUIViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak private var lblResult: UILabel!
    @IBOutlet weak private var imResult: UIImageView!
    
    // MARK: - Pablic properties
    
    var accessToken = ""
    
    // MARK: - Private properties
    
    private var passiveFaceLivenessSessionResultImage: Au10Image?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -------------
        preparePFLUIComponent()
    }
}

// MARK: Private Methods

private extension PFLUIViewController {
    
    // Prepare SDK
    
    func preparePFLUIComponent() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        Au10tixCore.shared.prepare(with: accessToken) { result in
            switch result {
            case .success( _):
                Au10tixCore.shared.delegate = self
                self.showPFLUIComponent()
                PKHUD.sharedHUD.hide()
            case .failure(let error):
                PKHUD.sharedHUD.hide()
                self.presentErrorAlertWith(message: "Failed with error \(error)")
            }
        }
    }
    
    // showSDCUIComponent
    
    func showPFLUIComponent() {
        
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
    
    func showResults() {
        lblResult.isHidden = false
        imResult.isHidden = false
        lblResult.text = "Success"
        imResult.image = passiveFaceLivenessSessionResultImage?.uiImage
    }
}

// MARK: Au10tixSessionDelegate

extension PFLUIViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        print(" update ------------------------- \(update)")
    }
    
    func didGetError(_ error: Au10tixSessionError) {
        print(" error -------------------- \(error)")
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        if result.isKind(of: PassiveFaceLivenessSessionResult.self) {
            
            let faceLivenessSessionResult = result as! PassiveFaceLivenessSessionResult
            
            passiveFaceLivenessSessionResultImage = faceLivenessSessionResult.image
        }
    }
}
