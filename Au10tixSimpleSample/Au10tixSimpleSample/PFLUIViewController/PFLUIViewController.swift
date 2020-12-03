//
// PFLUIViewController.swift
// Au10tixSimpleSample
//
// Create By Au10tixon.
//

import UIKit
import Au10tixCore
import Au10PassiveFaceLiveness
import AVFoundation

final class PFLUIViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var imPreview: UIImageView!
    @IBOutlet private weak var btnAgree: UIButton!
    @IBOutlet private weak var btnStillImage: UIButton!
    @IBOutlet private weak var btnChooseAnother: UIButton!
    @IBOutlet private weak var lblInfo: UILabel!
    
    // MARK: - Private Properties
    
    private var capturedImageData: Data?
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
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

// MARK: - Private Methods

private extension PFLUIViewController {
    
    /**
     Calls the start Session function of the Au10tixCore with the Au10PassiveFaceLivenessFeatureManager.
     */
    
    func prepare() {
        Au10tixCore.shared.delegate = self
        
        let featureManager = Au10PassiveFaceLivenessFeatureManager()
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard granted else { return }
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                Au10tixCore.shared.startSession(with: featureManager,
                                                previewView: self.cameraView)
            }
        }
    }
    
    // MARK: - Show Preview Image
    
    func showPreviewImage(_ imageData: Data) {
        guard let resultImage = UIImage(data: imageData) else {
            return
        }
        
        imPreview.image = resultImage
        capturedImageData = imageData
        cameraView.isHidden = true
        imPreview.isHidden = false
        btnAgree.isHidden = false
        btnChooseAnother.isHidden = false
        btnStillImage.isHidden = true
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
    
    // Get Results Text Value
    
    func getResultText(_ result: PassiveFaceLivenessSessionResult) ->  String {
        
        return ["isAnalyzed - \(result.isAnalyzed)",
                "score - \(result.score ?? 0)",
                "quality - \(result.quality ?? 0)",
                "probability - \(result.probability ?? 0)",
                "faceError -\(getFaceErrortStringValue(result.faceError))"].joined(separator: "\n")
    }
    
    // Get FaceError String Value
    
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
    
    // MARK: - Activity Indicator Actions
    
    func showActivityIndicator() {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        activityIndicator.center = CGPoint(x: view.bounds.size.width / 2,
                                           y: view.bounds.height / 2)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    // MARK: - Show Updates
    
    func showDetails(_ update: PassiveFaceLivenessSessionUpdate) {
        
        lblInfo.text = getUpdatesList(update)
    }
    
    // Get Updates List
    
    func getUpdatesList(_ update: PassiveFaceLivenessSessionUpdate) -> String {
        
        return ["qualityFeedback - \(getQualityFaultStringValue(update.qualityFeedback?.first))",
                "passiveFaceLivenessUpdateType - \(getPassiveFaceLivenessUpdateStringValue(update.passiveFaceLivenessUpdateType))"].joined(separator: "\n")
    }
    
    // Get QualityFault String Value
    
    func getQualityFaultStringValue(_ error: QualityFault?) -> String {
        
        guard let faceError = error else {return "none"}
        
        switch faceError {
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
    
    // Get PassiveFaceLivenessUpdateType String Value
    
    func getPassiveFaceLivenessUpdateStringValue(_ passiveFaceLivenessUpdateType: PassiveFaceLivenessUpdateType) -> String {
        switch passiveFaceLivenessUpdateType {
        case .imageCaptured:
            return "imageCaptured"
        case .passedThreshold:
            return "passedThreshold"
        case .qualityFeedback:
            return "qualityFeedback"
        }
    }
    
    // MARK: - UIAlertController
    
    func showAlert(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Actions

private extension PFLUIViewController {
    
    @IBAction func agreedAction() {
        guard let imageData = capturedImageData else {
            return
        }
        
        showActivityIndicator()
        Au10tixCore.shared.validateImage(imageData)
    }
    
    @IBAction func resumeCapturing() {
        cameraView.isHidden = false
        imPreview.isHidden = true
        btnAgree.isHidden = true
        btnChooseAnother.isHidden = true
        btnStillImage.isHidden = false
        Au10tixCore.shared.resumeCapturingState()
    }
    
    @IBAction func takeStillImage() {
        Au10tixCore.shared.takeStillImage()
    }
}

// MARK: - HANDLE SESSION EVENTS

extension PFLUIViewController: Au10tixSessionDelegate {
    
    /**
     Gets called whenever the session has an update.
     */
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        
        // MARK: - PassiveFaceLivenessSessionUpdate
        
        if let livenessUpdate = update as? PassiveFaceLivenessSessionUpdate {
            
            showDetails(livenessUpdate)
            guard let imageCaptured = livenessUpdate.capturedImage else {
                return
            }
            
            showPreviewImage(imageCaptured)
        }
    }
    
    /**
     Gets called whenever the session has an error.
     */
    
    func didGetError(_ error: Au10tixSessionError) {
        showAlert(error.localizedDescription)
    }
    
    /**
     Gets called when the feature session has a conclusive result .
     */
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        // MARK: - PassiveFaceLivenessSessionResult
        
        hideActivityIndicator()
        
        if let livenessResult = result as? PassiveFaceLivenessSessionResult {
            
            openPFLResults(livenessResult)
        }
    }
}
