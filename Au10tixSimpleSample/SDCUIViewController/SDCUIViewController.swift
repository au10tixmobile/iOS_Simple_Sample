//
// SDCUIViewController.swift
// Au10tixSimpleSample
//
// Create By Au10tixon.
//

import UIKit

#if canImport(Au10tixCore)
import Au10tixCore
#endif

#if canImport(Au10tixSmartDocumentCaptureKit)
import Au10tixSmartDocumentCaptureKit
#endif

final class SDCUIViewController: UIViewController {
    
#if canImport(Au10tixSmartDocumentCaptureKit)
    private let sdcSession = SDCSession()
#endif
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
#if canImport(Au10tixSmartDocumentCaptureKit)
        sdcSession.stop()
#endif
    }
}

// MARK: - Private Methods

private extension SDCUIViewController {
    
    /**
     Calls the start Session function of the Au10tixCore with the SmartDocumentFeatureManager.
     */
    
    func prepare() {
#if canImport(Au10tixCore)
        guard Au10tix.shared.workflowWrapper?.accessToken?.jwt != nil else { return }
#if canImport(Au10tixSmartDocumentCaptureKit)
        sdcSession.delegate = self

        /**
         Sets a custom Rect of Interest. [0.0, 0.0, 1.0, 1.0] means a whole image, [0.0, 0.5, 1.0, 1.0] means a bottom half.
         */

        try? sdcSession.setRectOfInterest(startX: 0.0, endX: 1.0, startY: 0.0, endY: 1.0)
        
        sdcSession.start(previewView: self.cameraView) { [weak self](result) in
            guard let self = self else { return }
            switch result {
            case .failure(let prepareError):
                self.showAlert("Prepare Error: \(prepareError)")
            case .success(let succeeded):
                debugPrint("Did start succeeded: \(succeeded)")
            }
        }
#endif
#endif
    }
    
    // MARK: - Open ResultViewController
    
#if canImport(Au10tixCore)
    func openSDCResults(_ image: Au10Image) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultImage = image.uiImage
        navigationController?.pushViewController(controller, animated: true)
    }
#endif
    
    // MARK: - Show Updates
    
#if canImport(Au10tixSmartDocumentCaptureKit)
    func showDetails(_ processingStatus: SDCProcessingStatus) {
        lblInfo.text = getUpdatesList(processingStatus)
    }
#endif
    
    // MARK: - Updates List
    
#if canImport(Au10tixSmartDocumentCaptureKit)
    func getUpdatesList(_ processingStatus: SDCProcessingStatus) -> String {
        
        var arr: [String] = []
        
        if let feedback = processingStatus.sdcFeedback {
            arr += ["feedback: \(feedback)"]
        }
        
        arr += ["isValid: \(processingStatus.isValid)"]
        
        return arr.joined(separator: "\n")
    }
#endif
    
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
#if canImport(Au10tixSmartDocumentCaptureKit)
        sdcSession.captureImage(.cameraCapture)
#endif
    }
    
}

// MARK: - HANDLE SESSION EVENTS

#if canImport(Au10tixSmartDocumentCaptureKit)
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
#endif
