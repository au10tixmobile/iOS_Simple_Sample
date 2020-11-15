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
import AVFoundation


final class SDCUIViewController:  UIViewController, AlertPresentable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var lblInfo: UILabel!
    
    // MARK: - Private properties
    
    private var documentCaptureSessionResultImage: Au10Image?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ------
        customSmartDocumentFeatureManager()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Au10tixCore.shared.stopSession()
    }
}

// MARK: Private Methods

private extension SDCUIViewController {
    
    // Prepare SDK

    func customSmartDocumentFeatureManager() {
        
        let au10SmartDocumentFeatureManager = SmartDocumentFeatureManager()
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else { return }
            Au10tixCore.shared.delegate = self
            DispatchQueue.main.async {
                Au10tixCore.shared.startSession(with: au10SmartDocumentFeatureManager, previewView:
                                                    self.cameraView)
            }
        }
    }
}

// MARK: Au10tixSessionDelegate

extension SDCUIViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        debugPrint(" update ------------------------- \(update)")
        
        
    }
    
    func didGetError(_ error: Au10tixSessionError) {
        debugPrint(" error -------------------- \(error)")
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        debugPrint(" result ----------------------------- \(result)")
        
        
        if result.isKind(of: SmartDocumentCaptureSessionResult.self) {
            
            documentCaptureSessionResultImage = result.image
            showResults()
        }
    }
}

extension SDCUIViewController {
    
    func showResults() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.imResult.image = documentCaptureSessionResultImage?.uiImage
        navigationController?.pushViewController(controller, animated: true)
    }
}
