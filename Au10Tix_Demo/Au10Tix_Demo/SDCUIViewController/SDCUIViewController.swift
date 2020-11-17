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
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else { return }
            
            DispatchQueue.main.async {
                Au10tixCore.shared.startSession(with: au10SmartDocumentFeatureManager,
                                                previewView: self.cameraView)
            }
        }
    }
    
    // MARK: - Open ResultViewController
    
    func openResultsViewController(_ resultImage: UIImage) {
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultImage = resultImage
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: Au10tixSessionDelegate

extension SDCUIViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        
        // MARK: - SmartDocumentCaptureSessionUpdate
        
        if let documentSessionUpdate = update as? SmartDocumentCaptureSessionUpdate {
            lblInfo.text = "reflectionStatus - \(documentSessionUpdate.reflectionStatus) \n" +
                "blurScore - \(documentSessionUpdate.blurScore)  \n " +
                "reflectionScore - \(documentSessionUpdate.reflectionScore)  \n " +
                "quadrangle - \(documentSessionUpdate.quadrangle)  \n" +
                "stabilityStatus - \(documentSessionUpdate.stabilityStatus)  \n" +
                "isValidDocument - \(documentSessionUpdate.isValidDocument)  \n" +
        }
        
      //  Please show all quality faults

    }
    
    func didGetError(_ error: Au10tixSessionError) {
        debugPrint(" error -\(error)")
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        // MARK: - SmartDocumentCaptureSessionResult
        
        if let documentSessionResult = result as? SmartDocumentCaptureSessionResult {
            
            guard let resultImage = documentSessionResult.image?.uiImage else {
                return
            }
            
            openResultsViewController(resultImage)
        }
    }
}
