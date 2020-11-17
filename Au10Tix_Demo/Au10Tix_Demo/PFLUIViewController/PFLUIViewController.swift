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

final class PFLUIViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var lblInfo: UILabel!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ---------
        prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Au10tixCore.shared.stopSession()
    }
}

// MARK: Private Methods

private extension PFLUIViewController {
    
    // Prepare SDK
    
    func prepare() {
        Au10tixCore.shared.delegate = self
        
        let featureManager = Au10PassiveFaceLivenessFeatureManager()
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else { return }
       
            DispatchQueue.main.async {
                Au10tixCore.shared.startSession(with: featureManager,
                                                previewView: self.cameraView)
            }
        }
    }
    
    // Get QualityFault String Value
    
    func getStringValue(_ qualityFault: QualityFault) -> String {
        
        switch qualityFault {
        case .unstable:
            return "unstable"
        case .deviceNotVerticle:
            return "deviceNotVerticle"
        case .faceNotDetectedInImage:
            return "faceNotDetectedInImage"
        case .tooManyFaces:
            return "tooManyFaces"
        case .faceTooFarFromCamera:
            return "faceTooFarFromCamera"
        case .faceTooCloseToCamera:
            return "faceTooCloseToCamera"
        case .faceNotFacingDirectlyAtCamera:
            return "faceNotFacingDirectlyAtCamera"
        case .holdSteady:
            return "holdSteady"
        case .noFault:
            return "noFault"
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

extension PFLUIViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        
        // MARK: - PassiveFaceLivenessSessionUpdate
        
        if let livenessUpdate = update as? PassiveFaceLivenessSessionUpdate {
            
            guard let qualityFeedback = livenessUpdate.qualityFeedback?.first else {
                return
            }
            
            guard let imageCaptured = livenessUpdate.capturedImage else {
                return
            }
            
          //  Provide a button for the user to approve the image and start liveness check
          //  Provide a button for the user to resume capturing
            
            
         //   When liveness check is in taking place , use UIActivityIndicator view to indicate the liveness check is in progress
          //  When done, navigate to result screen with the image and the liveness check result.
     
            lblInfo.text = "qualityFeedback - \(getStringValue(qualityFeedback))"
        }
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
    }
}
