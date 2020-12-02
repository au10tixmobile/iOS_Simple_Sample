//
// SDCUIViewController.swift
// Au10tixSimpleSample
//
// Create By Au10tixon.
//
import UIKit
import Au10tixCore
import Au10SmartDocumentCaptureFeature
import AVFoundation

final class SDCUIViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var lblInfo: UILabel!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ------
        prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Au10tixCore.shared.stopSession()
    }
}

// MARK: Private Methods

private extension SDCUIViewController {
    
    // Prepare SDK
    
    func prepare() {
        Au10tixCore.shared.delegate = self
        
        let au10SmartDocumentFeatureManager = SmartDocumentFeatureManager(isSmart: true)
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard granted else { return }
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                Au10tixCore.shared.startSession(with: au10SmartDocumentFeatureManager,
                                                previewView: self.cameraView)
            }
        }
    }
    
    // MARK: - Open ResultViewController
    
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
    
    // MARK: - Show Updates
    
    func showDetails(_ update: SmartDocumentCaptureSessionUpdate) {
        lblInfo.text = getUpdatesList(update)
    }
    
    // MARK: - Updates List
    
    func getUpdatesList(_ update: SmartDocumentCaptureSessionUpdate) -> String {
        
        return ["blurScore \(update.blurScore)",
                "reflectionScore \(update.reflectionScore)",
                "idStatus \(update.idStatus)",
                "blurStatus \(update.blurStatus)",
                "reflectionStatus \(update.reflectionStatus)",
                "darkStatus \(update.darkStatus)",
                "StabilityStatus \(getStringValue(update.stabilityStatus))"].joined(separator: "\n")
    }
    
    // Get StabilityStatus String Value
    
    func getStringValue(_ error: SmartDocumentCaptureSessionUpdate.StabilityStatus?) -> String {
        
        guard let stabilityStatus = error else {return "none"}
        
        switch stabilityStatus {
        case .stable:
            return "stable"
        case .notStable:
            return "notStable"
        }
    }
    
    // MARK: - UIAlertController
    
    func showAlert(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Actions

private extension SDCUIViewController {
    
    @IBAction func takeStillImage() {
        Au10tixCore.shared.takeStillImage()
    }
}

// MARK: Au10tixSessionDelegate

extension SDCUIViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        
        // MARK: - SmartDocumentCaptureSessionUpdate
        
        if let documentSessionUpdate = update as? SmartDocumentCaptureSessionUpdate {
            showDetails(documentSessionUpdate)
        }
    }
    
    func didGetError(_ error: Au10tixSessionError) {
        showAlert(error.localizedDescription)
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        // MARK: - SmartDocumentCaptureSessionResult
        
        if let documentSessionResult = result as? SmartDocumentCaptureSessionResult {
            openSDCResults(documentSessionResult)
        }
    }
}
