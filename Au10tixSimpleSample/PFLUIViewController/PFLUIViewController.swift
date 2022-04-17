//
// PFLUIViewController.swift
// Au10tixSimpleSample
//
// Create By Au10tixon.
//

import UIKit
import Au10tixCore
import Au10tixPassiveFaceLivenessKit

final class PFLUIViewController: UIViewController {
    
    private let pflSession = PFLSession()
    private var pflResultString: String?
    // MARK: - IBOutlets
    
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var imPreview: UIImageView!
    @IBOutlet private weak var btnAgree: UIButton!
    @IBOutlet private weak var btnStillImage: UIButton!
    @IBOutlet private weak var btnChooseAnother: UIButton!
    @IBOutlet private weak var lblInfo: UILabel!
    
    // MARK: - Private Properties
    
    private var capturedImageData: Data?
    private var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ---------
        prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pflSession.stop()
    }
}

// MARK: - Private Methods

private extension PFLUIViewController {
    
    /**
     Calls the start Session function of the Au10tixCore with the Au10PassiveFaceLivenessFeatureManager.
     */
    
    func prepare() {
        guard let token = Au10tix.shared.bearerToken else { return }
        pflSession.delegate = self
        pflSession.start(with: token, previewView: self.cameraView) { [weak self](result) in
            guard let self = self else { return }
            switch result {
            case .failure(let prepareError):
                self.showAlert("Prepare Error: \(prepareError)")
            case .success(let sessionId):
                debugPrint("start with sessionId: " + sessionId)
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
    
    func openPFLResult(_ image: UIImage, resultString: String) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultString = resultString
        controller.resultImage = image
        navigationController?.pushViewController(controller, animated: true)
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
   
    // Get QualityFault String Value
    
    private func getQualityFaultStringValue(_ fault: QualityFault?) -> String {
        
        guard let fault = fault else {return "none"}
        
        switch fault {
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
        case .moveUp:
            return "move up"
        case .moveDown:
            return "move down"
        case .moveLeft:
            return "move left"
        case .moveRight:
            return "move right"
        @unknown default:
            return ""
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
        pflSession.validateImage(imageData)
    }
    
    @IBAction func resumeCapturing() {
        cameraView.isHidden = false
        imPreview.isHidden = true
        btnAgree.isHidden = true
        btnChooseAnother.isHidden = true
        btnStillImage.isHidden = false
        pflSession.recapture()
    }
    
    @IBAction func takeStillImage() {
        pflSession.captureImage()
    }
}

// MARK: - HANDLE SESSION EVENTS

extension PFLUIViewController: PFLSessionDelegate {
    
    /**
    Gets Called upon image sample is captured
     */
    func pflSession(_ pflSession: PFLSession, didCapture image: Data, qualityFeedback: QualityFaultOptions, faceBoundingBox: CGRect?) {
        showPreviewImage(image)
    }
    
    /**
    Gets Called for quality feedbcak while capturing session is running
     */
    func pflSession(_ pflSession: PFLSession, didRecieve qualityFeedback: QualityFaultOptions) {
        lblInfo.text = getQualityFaultStringValue(qualityFeedback.first)
    }
    
    private func getFaceErrortStringValue(_ error: FaceError?) -> String {
        
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
        case .faceIsOccluded:
            return "faceIsOccluded"
        case .failedToReadImage:
            return "failedToReadImage"
        case .failedToWriteImage:
            return "failedToWriteImage"
        case .failedToReadModel:
            return "failedToReadModel"
        case .failedToAllocate:
            return "failedToAllocate"
        case .invalidConfig:
            return "invalidConfig"
        case .noSuchObject:
            return "noSuchObject"
        case .failedToPreprocessImageWhilePredict:
            return "failedToPreprocessImageWhilePredict"
        case .failedToPreprocessImageWhileDetect:
            return "failedToPreprocessImageWhileDetect"
        case .failedToPredictLandmarks:
            return "failedToPredictLandmarks"
        case .invalidFuseMode:
            return "invalidFuseMode"
        case .nullPtr:
            return "nullPtr"
        case .licenseError:
            return "licenseError"
        case .invalidMeta:
            return "invalidMeta"
        @unknown default:
            return ""
        }
    }
    
    private func getPflResultText(_ result: PFLResponse) -> String {
        
        return ["score - \(result.score ?? 0)",
                "quality - \(result.quality ?? 0)",
                "probability - \(result.probability ?? 0)",
                "faceError -\(getFaceErrortStringValue(result.error_code?.toFaceError))"].joined(separator: "\n")
    }
    
    /**
    Gets Called when on PFL liveness check result
     */
    func pflSession(_ pflSession: PFLSession, didConcludeWith result: PFLResponse, for image: Data) {
        self.pflResultString = getPflResultText(result)
    }
    
    /**
    Gets Called when PFL validation started
     */
    func pflSession(_ pflSession: PFLSession, didStartValidating image: Data) {
        
    }

    
    /**
    Gets Called when PFL passed liveness probabillity
     */
    func pflSession(_ pflSession: PFLSession, didPassProbabilityThresholdFor image: Data) {
        lblInfo.text = "Passed ProbabilityThreshold"
        guard let uiImage = UIImage(data: image) else { return }
        self.openPFLResult(uiImage, resultString: self.pflResultString ?? "")
    }
    
    /**
    Gets Called when PFL failed
     */
    func pflSession(_ pflSession: PFLSession, didFailWith error: PFLSessionError) {
        showAlert("PFLError \(error)")
    }
    
}
