//
// SDCUIViewController.swift
// Au10tixSimpleSample
//
// Create By Au10tixon.
//

import UIKit
import Au10tixCore
import Au10tixSmartDocumentCaptureKit

final class SDCUIViewController: UIViewController {
    
    private let sdcSession = SDCSession()
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
        sdcSession.stop()
    }
}

// MARK: - Private Methods

private extension SDCUIViewController {
    
    /**
     Calls the start Session function of the Au10tixCore with the SmartDocumentFeatureManager.
     */
    
    func prepare() {
        guard let token = Au10tix.shared.bearerToken else { return }
        sdcSession.delegate = self
        sdcSession.start(with: token, previewView: self.cameraView) { [weak self](result) in
            guard let self = self else { return }
            switch result {
            case .failure(let prepareError):
                self.showAlert("Prepare Error: \(prepareError)")
            case .success(let sessionId):
                debugPrint("start with sessionId: " + sessionId)
            }
        }
    }
    
    // MARK: - Open ResultViewController
    
    func openSDCResults(_ image: Au10Image) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultImage = image.uiImage
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Show Updates
    
    func showDetails(_ processingStatus: SDCProcessingStatus) {
        lblInfo.text = getUpdatesList(processingStatus)
    }
    
    // MARK: - Updates List
    
    func getUpdatesList(_ processingStatus: SDCProcessingStatus) -> String {
        
        var arr: [String] = []
        
        if let feedback = processingStatus.feedback {
            arr += ["feedback: \(feedback)"]
        }
        
        arr += ["isValid: \(processingStatus.isValid)"]
        
        return arr.joined(separator: "\n")
    }
    
    // MARK: - UIAlertController
    
    func showAlert(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Actions

private extension SDCUIViewController {
    
    @IBAction func takeStillImage() {
        sdcSession.captureImage()
    }
    
}

// MARK: - HANDLE SESSION EVENTS

extension SDCUIViewController: SDCSessionDelegate {
    
    /**
    Gets Called when Smart Documet session failed
     */
    func sdcSession(_ sdcSession: SDCSession, didFailWithError error: SDCSessionError) {
        showAlert("SDCError \(error)")
    }
    
    /**
    Gets Called when Smart Documet result is received and processed
     */
    func sdcSession(_ sdcSession: SDCSession, didProcess processingStatus: SDCProcessingStatus) {
        showDetails(processingStatus)
    }
    
    /**
    Gets Called when document was taken
     */
    func sdcSession(_ sdcSession: SDCSession, didCapture image: Au10Image, croppedImage: Au10Image?, with processingStatus: SDCProcessingStatus) {
        openSDCResults(croppedImage ?? image)
    }
    
    /**
    Gets Called when a barcode was detected
     */
    func sdcSession(_ sdcSession: SDCSession, didDetect machineReadableCodes: [Au10MachineReadableCode]) {
        
    }
    
    /**
    Gets Called when an image was taken
     */
    func sdcSession(_ sdcSession: SDCSession, didTake image: Au10Image) {
        
    }
}
