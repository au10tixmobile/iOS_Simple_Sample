//
// MainViewController.swift
// Au10tixSimpleSample
//
// Create By Au10tixon.
//

import UIKit
import Au10tixCore
import Au10tixUIComponentBase
import Au10tixUIComponentPFL
import Au10tixUIComponentSDC
import Au10PassiveFaceLiveness
import Au10SmartDocumentCaptureFeature
import Au10tixUIComponentPOA
import Au10tixPOA

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var btnSDC: UIButton!
    @IBOutlet private weak var btnPFL: UIButton!
    @IBOutlet private weak var btnPOA: UIButton!
    @IBOutlet private weak var btnSDCwithUI: UIButton!
    @IBOutlet private weak var btnPFLwithUI: UIButton!
    @IBOutlet private weak var btnPOAwithUI: UIButton!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------
        
        uiPreparation()
        prepare()
        addObserver()
    }
}

// MARK: - Private Methods

private extension MainViewController {
    
    // MARK: - SDK Preparation
    /**
     Use this method to prepare Au10tix SDK.
     - warning: Use the JWT retrieved from your backend. See Au10tix guide for more info.
     */
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
    
    // MARK: - Open SMART DOCUMENT CAPTURING UI component
    /**
     Use this method to initialize the SMART DOCUMENT CAPTURING UI component.
     */
    
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
    
    // MARK: - Open PASSIVE FACE LIVENESS UI component.
    /**
     Use this method to initialize the PASSIVE FACE LIVENESS UI component.
     */
    
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
    
    // MARK: - Open PROOF OF ADDRESS UI component.
    /**
     Use this method to initialize the PROOF OF ADDRESS UI component.
     */
    
    func openPOAUIComponent() {
        
        let configs = UIComponentConfigs(appLogo: UIImage(),
                                         actionButtonTint: UIColor.green,
                                         titleTextColor: UIColor.green,
                                         errorTextColor: UIColor.green,
                                         canUploadImage: true,
                                         showCloseButton: true)
        let controller = POAViewController(configs: configs, delegate: self)
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
    
    // MARK: - Open POAUIViewController
    
    func openPOAViewContrller() {
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "POAUIViewController") as? POAUIViewController else {
            return
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Open ResultViewController
    
    func openPFLResults(_ result: PassiveFaceLivenessSessionResult) {
        
        guard let resultImage = UIImage(data: result.imageData),
              result.isAnalyzed,
              result.faceError == nil else {
            return
        }
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultString = getResultText(result)
        controller.resultImage = resultImage
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - openSDCResults
    
    func openSDCResults(_ result: SmartDocumentCaptureSessionResult) {
        
        guard let resultImage = result.image?.uiImage else {
            return
        }
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultImage = resultImage
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - openPOAResults
    
    func openPOAResults(_ result: ProofOfAddressSessionResult) {
        
        guard let resultImage = result.image?.uiImage else {
            return
        }
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultImage = resultImage
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - UIAlertController
    
    func showAlert(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func getResultText(_ result: PassiveFaceLivenessSessionResult) -> String {
        
        return ["isAnalyzed - \(result.isAnalyzed)",
                "score - \(result.score ?? 0)",
                "quality - \(result.quality ?? 0)",
                "probability - \(result.probability ?? 0)",
                "faceError -\(getFaceErrortStringValue(result.faceError))"].joined(separator: "\n")
    }
    
    func getFaceErrortStringValue(_ error: FaceError?) -> String {
        
        guard let faceError = error else {return "none"}
        
        switch faceError {
        case .faceAngleTooLarge:
            return "faceAngleTooLarge"
        case .faceCropped:
            return "faceCropped"
        case .faceNotFound:
            return "faceNotFound"
        case .faceTooClose:
            return "faceTooClose"
        case .faceTooCloseToBorder:
            return "faceTooCloseToBorder"
        case .faceTooSmall:
            return "faceTooSmall"
        case .internalError:
            return "internalError"
        case .tooManyFaces:
            return "tooManyFaces"
        }
    }
    
    // MARK: - Buttons Preparation
    
    func uiPreparation() {
        btnSDC.titleLabel?.lineBreakMode = .byWordWrapping
        btnSDC.titleLabel?.textAlignment = .center
        btnPFL.titleLabel?.lineBreakMode = .byWordWrapping
        btnPFL.titleLabel?.textAlignment = .center
        btnPOA.titleLabel?.lineBreakMode = .byWordWrapping
        btnPOA.titleLabel?.textAlignment = .center
        btnSDCwithUI.titleLabel?.lineBreakMode = .byWordWrapping
        btnSDCwithUI.titleLabel?.textAlignment = .center
        btnPFLwithUI.titleLabel?.lineBreakMode = .byWordWrapping
        btnPFLwithUI.titleLabel?.textAlignment = .center
        btnPOAwithUI.titleLabel?.lineBreakMode = .byWordWrapping
        btnPOAwithUI.titleLabel?.textAlignment = .center
    }
    
    // MARK: - Observer
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleExpirationNotification(_:)),
                                               name: .au10tixCoreTokenExpiration, object: nil)
    }
    
    @objc func handleExpirationNotification(_ sender: Notification) {
        let alert = UIAlertController(title: "Error", message: "Session Is Expired", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if var topController = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
            if let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Actions

private extension MainViewController {
    
    @IBAction func btnSDCAction() {
        openSDCViewContrller()
    }
    
    @IBAction func btnPFLAction() {
        openPFLViewController()
    }
    
    @IBAction func btnPOAAction() {
        openPOAViewContrller()
    }
    
    @IBAction func btnSDCwithUIAction() {
        openSDCUIComponent()
    }
    
    @IBAction func btnPFLwithUIAction() {
        openPFLUIComponent()
    }
    
    @IBAction func btnPOAwithUIAction() {
        openPOAUIComponent()
    }
}

// MARK: - HANDLE SESSION EVENTS

extension MainViewController: Au10tixSessionDelegate {
    
    /**
     Gets called whenever the session has an update. 
     */
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        debugPrint(" update -\(update)")
    }
    
    /**
     Gets called whenever the session has an error.
     */
    
    func didGetError(_ error: Au10tixSessionError) {
        debugPrint(" error -\(error)")
    }
    
    /**
     Gets called when the feature session has a conclusive result .
     */
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        // MARK: - PassiveFaceLivenessSessionResult
        
        if let livenessResult = result as? PassiveFaceLivenessSessionResult {
            openPFLResults(livenessResult)
        }
        
        // MARK: - SmartDocumentCaptureSessionResult
        
        if let documentSessionResult = result as? SmartDocumentCaptureSessionResult {
            openSDCResults(documentSessionResult)
        }
        
        // MARK: - ProofOfAddressSessionResult
        
        if let poaResult = result as? ProofOfAddressSessionResult {
            openPOAResults(poaResult)
        }
    }
}
