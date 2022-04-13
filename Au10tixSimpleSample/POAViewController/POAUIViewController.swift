//
// POAUIViewController.swift
// Au10tixSimpleSample
//
// Create By Au10tixon.
//

import UIKit
import Au10tixCore
import Au10tixProofOfAddressKit

final class POAUIViewController: UIViewController {
    
    private let poaSession = POASession()
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
        poaSession.stop()
    }
}

// MARK: - Private Methods

private extension POAUIViewController {
    
    /**
     Calls the start Session function of the Au10tixCore with the ProofOfAddressFeatureManager.
     */
    
    func prepare() {
        guard let token = Au10tix.shared.bearerToken else { return }
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
    }
    
    // MARK: - openPOAResults
    
    func openPOAResult(image: Au10Image) {
        
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultImage = image.uiImage
        navigationController?.pushViewController(controller, animated: true)
    }
    
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
        poaSession.captureImage()
    }
}

// MARK: - HANDLE SESSION EVENTS

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
