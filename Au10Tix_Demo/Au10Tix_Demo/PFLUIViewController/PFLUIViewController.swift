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

final class PFLUIViewController: UIViewController, AlertPresentable {
    
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
    
    private var passiveFaceLivenessSessionResultImage: Au10Image?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        customPreparingPassiveFaceLivenessFeatureManager()
        // -------------
       // preparePFLUIComponent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Au10tixCore.shared.stopSession()
    }
}

// MARK: Private Methods

private extension PFLUIViewController {
    
    // Prepare SDK
    
    
    // PassiveFaceLivenes
    
func customPreparingPassiveFaceLivenessFeatureManager() {
        let featureManager = Au10PassiveFaceLivenessFeatureManager()
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else { return }
            Au10tixCore.shared.delegate = self
            DispatchQueue.main.async {
                Au10tixCore.shared.startSession(with: featureManager, previewView:
                    self.view)
//                Au10tixCore.shared.takeStillImage()
//                Au10tixCore.shared.resumeCapturingState()
//                Au10tixCore.shared.validateImage(imageData) // для сохранения изображения  и повторного проверки
            }
        }
    }
    
    
    
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
        lblResult.text =  Constants.successMessage
        imResult.image = passiveFaceLivenessSessionResultImage?.uiImage
    }
}

// MARK: Au10tixSessionDelegate

extension PFLUIViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        debugPrint(" update ------------------------- \(update)")
    }
    
    func didGetError(_ error: Au10tixSessionError) {
        debugPrint(" error -------------------- \(error)")
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        if result.isKind(of: PassiveFaceLivenessSessionResult.self) {
            
            let faceLivenessSessionResult = result as! PassiveFaceLivenessSessionResult
            
            passiveFaceLivenessSessionResultImage = faceLivenessSessionResult.image
        }
    }
}

// MARK: - MainViewControllerOutput

extension PFLUIViewController {
    
 
    func pushToPFLViewController(with viewModel: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        //controller.accessToken = viewModel
        
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
