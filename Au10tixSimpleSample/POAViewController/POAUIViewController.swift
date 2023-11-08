//
// POAUIViewController.swift
// Au10tixSimpleSample
//
// Create By Au10tixon.
//

import UIKit

#if canImport(Au10tixCore)
import Au10tixCore
#endif

#if canImport(Au10tixProofOfAddressKit)
import Au10tixProofOfAddressKit
#endif

final class POAUIViewController: UIViewController {
    
#if canImport(Au10tixProofOfAddressKit)
    private let poaSession = POASession()
#endif
    // MARK: - IBOutlets
    @IBOutlet private weak var cameraView: UIView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ------
        prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
#if canImport(Au10tixProofOfAddressKit)
        poaSession.stop()
#endif
    }
}

// MARK: - Private Methods

private extension POAUIViewController {
    
    /**
     Calls the start Session function of the Au10tixCore with the ProofOfAddressFeatureManager.
     */
    
    func prepare() {
#if canImport(Au10tixCore)
        guard let token = Au10tix.shared.bearerToken else { return }
#if canImport(Au10tixProofOfAddressKit)
        poaSession.delegate = self
        self.poaSession.start(with: token, previewView: self.cameraView) { [weak self](result) in
            guard let self = self else { return }
            switch result {
            case .failure(let prepareError):
                self.showAlert("Prepare Error: \(prepareError)")
            case .success(let sessionId):
                debugPrint("start with sessionId: " + sessionId)
            }
        }
#endif
#endif
    }
    
    // MARK: - openPOAResults
    
#if canImport(Au10tixCore)
    func openPOAResult(image: Au10Image) {
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultImage = image.uiImage
        navigationController?.pushViewController(controller, animated: true)
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

private extension POAUIViewController {
    
    @IBAction func takeStillImage() {
#if canImport(Au10tixProofOfAddressKit)
        poaSession.captureImage(.cameraCapture)
#endif
    }
}

// MARK: - HANDLE SESSION EVENTS

#if canImport(Au10tixProofOfAddressKit)
extension POAUIViewController: POASessionDelegate {
    
    /**
     Gets called whenever the session has an error.
     */
    func poaSession(_ poaSession: POASession, didFailWith error: POASessionError) {
        showAlert("POASessionError \(error)")
    }
    
    /**
     Gets called when the feature session has a conclusive result .
     */
    func poaSession(_ poaSession: POASession, didCapture image: Au10Image, with frameData: Au10Update) {
        openPOAResult(image: image)
    }
        
}
#endif
