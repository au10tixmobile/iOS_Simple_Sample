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


final class PFLUIViewController: UIViewController, AlertPresentable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var lblInfo: UILabel!
    
    // MARK: - Private properties
    
    private var passiveFaceLivenessSessionResultImage: UIImage?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ---------
        
        showPassiveFaceLiveness()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
  
}

// MARK: Private Methods

private extension PFLUIViewController {
    
    // Prepare SDK
    
    func showPassiveFaceLiveness() {
        let featureManager = Au10PassiveFaceLivenessFeatureManager()
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else { return }
            
            DispatchQueue.main.async {
                Au10tixCore.shared.delegate = self
                Au10tixCore.shared.startSession(with: featureManager, previewView:
                                                    self.cameraView)
                
            }
        }
    }
    
    func getStringValue (passiveFaceLivenessUpdateType: PassiveFaceLivenessUpdateType) -> String {
        switch passiveFaceLivenessUpdateType {
        case .imageCaptured:
            return "imageCaptured"
        case .qualityFeedback:
            return "qualityFeedback"
        case .passedThreshold:
            return "passedThreshold"
        }
    }
    func getStringValue (qualityFault: QualityFault) -> String {
        
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
}





// MARK: Au10tixSessionDelegate

extension PFLUIViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        
        if update.isKind(of: PassiveFaceLivenessSessionUpdate.self) {
            
            let sessionUpdate = update as! PassiveFaceLivenessSessionUpdate
            if let item = sessionUpdate.qualityFeedback?.first {
                lblInfo.text = "qualityFeedback - \(getStringValue(qualityFault: item))"
            } else {
            
                lblInfo.text = "PassiveFaceLivenessUpdateType - \(getStringValue(passiveFaceLivenessUpdateType: sessionUpdate.passiveFaceLivenessUpdateType))"
                
                passiveFaceLivenessSessionResultImage = UIImage(data: sessionUpdate.capturedImage!)
                
                toResults()
            }
        }
    }
    
    
    
    func didGetError(_ error: Au10tixSessionError) {
        debugPrint(" error -------------------- \(error)")
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        if result.isKind(of: PassiveFaceLivenessSessionResult.self) {
            
            let faceLivenessSessionResult = result as! PassiveFaceLivenessSessionResult
            
            passiveFaceLivenessSessionResultImage = faceLivenessSessionResult.image?.uiImage
        }
    }
}

// MARK: - MainViewControllerOutput

extension PFLUIViewController {
    
    
    func toResults() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let controller = storyBoard.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        Au10tixCore.shared.stopSession()
        cameraView.removeFromSuperview()
        lblInfo.text = ""
        controller.documentCaptureSessionResultImage = passiveFaceLivenessSessionResultImage
        navigationController?.pushViewController(controller, animated: true)
    }
}
