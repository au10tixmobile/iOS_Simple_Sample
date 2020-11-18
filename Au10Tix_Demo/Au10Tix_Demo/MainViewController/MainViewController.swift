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

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var btnSDC: UIButton!
    @IBOutlet private weak var btnPFL: UIButton!
    @IBOutlet private weak var btnSDCwithUI: UIButton!
    @IBOutlet private weak var btnPFLwithUI: UIButton!
    
    // MARK: - Private Properties
    
    private var resultIsAlreadyShown = false
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------
        prepare()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resultIsAlreadyShown = false
    }
}

// MARK: - MainViewControllerActions

private extension MainViewController {
    
    // MARK: - Actions
    
    @IBAction func btnSDCAction() {
        openSDCViewContrller()
    }
    
    @IBAction func btnPFLAction() {
        openPFLViewController()
    }
    
    @IBAction func btnSDCwithUIAction() {
        openSDCUIComponent()
    }
    
    @IBAction func btnPFLwithUIAction() {
        openPFLUIComponent()
    }
}

// MARK: Private Methods

private extension MainViewController {
    
    // MARK: - SDK Preparation
    
    func prepare() {
        
        #warning("Use the JWT retrieved from your backend. See Au10tix guide for more info")
        
        Au10tixCore.shared.prepare(with: "") { [weak self] result in
            switch result {
            case .success(let sessionID):
                debugPrint("sessionID -\(sessionID)")
            case .failure(let error):
                self?.showAlert(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Open SDCUIComponent
    
    func openSDCUIComponent() {
        
        let configs = UIComponentConfigs(appLogo: UIImage(),
                                         actionButtonTint: UIColor.green,
                                         titleTextColor: UIColor.green,
                                         errorTextColor: UIColor.green,
                                         canUploadImage: true,
                                         showCloseButton: true)
        
        let controller = SDCViewController(configs: configs, delegate: self)
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Open PFLUIComponent
    
    func openPFLUIComponent() {
        
        let configs = UIComponentConfigs(appLogo: UIImage(),
                                         actionButtonTint: UIColor.green,
                                         titleTextColor: UIColor.green,
                                         errorTextColor: UIColor.green,
                                         canUploadImage: true,
                                         showCloseButton: true)
        
        let controller = PFLViewController(configs: configs, delegate: self)
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Open PFLViewController
    
    func openPFLViewController() {
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PFLUIViewController") as? PFLUIViewController else {
            return
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Open SDCViewContrller
    
    func openSDCViewContrller() {
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SDCUIViewController") as? SDCUIViewController else {
            return
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Open ResultViewController
    
    func openResultsViewController(_ resultImage: UIImage) {
        
        guard resultIsAlreadyShown == false else {
            return
        }
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        resultIsAlreadyShown = true
        controller.resultImage = resultImage
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - UIAlertController
    
    func showAlert(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: Au10tixSessionDelegate

extension MainViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        debugPrint(" update -\(update)")
    }
    
    func didGetError(_ error: Au10tixSessionError) {
        debugPrint(" error -\(error)")
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        // MARK: - PassiveFaceLivenessSessionResult
        
        if let livenessResult = result as? PassiveFaceLivenessSessionResult {
            
            guard let resultImage = UIImage(data: livenessResult.imageData) else {
                return
            }
            
            openResultsViewController(resultImage)
        }
        
        // MARK: - SmartDocumentCaptureSessionResult
        
        if let documentSessionResult = result as? SmartDocumentCaptureSessionResult {
            
            guard let resultImage = documentSessionResult.image?.uiImage else {
                return
            }
            
            openResultsViewController(resultImage)
        }
    }
}
