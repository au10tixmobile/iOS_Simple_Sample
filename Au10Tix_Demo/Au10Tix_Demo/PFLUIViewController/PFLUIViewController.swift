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
    @IBOutlet private weak var imPreview: UIImageView!
    @IBOutlet private weak var btnAgree: UIButton!
    @IBOutlet private weak var btnChooseAnother: UIButton!
    
    // MARK: - Private Properties
    
    private var capturedImageData: Data?
    private var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
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
    }
    
    // MARK: - Open ResultViewController
    
    func openResultsViewController(_ result: PassiveFaceLivenessSessionResult) {
        
        guard let resultImage = UIImage(data: result.imageData) else {
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
    
    func getResultText(_ result: PassiveFaceLivenessSessionResult) -> String {
        
        var resultString = "isAnalyzed - \(result.isAnalyzed)\n"
        
        if let score = result.score {
            resultString += "score - \(score)\n"
        }
        
        if let quality = result.quality {
            resultString += "quality - \(quality)\n"
        }
        
        if let probability = result.probability {
            resultString += "probability - \(probability)\n"
        }
        
        if let faceError = result.faceError {
            resultString += "faceError -\(faceError)\n"
        }
        return resultString
    }
    
    // MARK: - Activity Indicator Actions
    
    func showActivityIndicator() {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2,
                                           y: self.view.bounds.height / 2)
        view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}

// MARK: Actions

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
        Au10tixCore.shared.resumeCapturingState()
    }
}

// MARK: Au10tixSessionDelegate

extension PFLUIViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        
        // MARK: - PassiveFaceLivenessSessionUpdate
        
        if let livenessUpdate = update as? PassiveFaceLivenessSessionUpdate {
            guard let imageCaptured = livenessUpdate.capturedImage else {
                return
            }
            
            showPreviewImage(imageCaptured)
        }
    }
    
    func didGetError(_ error: Au10tixSessionError) {
        debugPrint(" error -\(error)")
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        // MARK: - PassiveFaceLivenessSessionResult
        
        hideActivityIndicator()
        
        if let livenessResult = result as? PassiveFaceLivenessSessionResult {
            
            openResultsViewController(livenessResult)
        }
    }
}
