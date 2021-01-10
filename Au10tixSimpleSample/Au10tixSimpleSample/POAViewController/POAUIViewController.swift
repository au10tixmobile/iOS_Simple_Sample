//
// POAUIViewController.swift
// Au10tixSimpleSample
//
// Create By Au10tixon.
//

import UIKit
import AVFoundation
import Au10tixCore
import Au10tixProofOfAddressKit

final class POAUIViewController: UIViewController {
    
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
        Au10tixCore.shared.stopSession()
    }
}

// MARK: - Private Methods

private extension POAUIViewController {
    
    /**
     Calls the start Session function of the Au10tixCore with the ProofOfAddressFeatureManager.
     */
    
    func prepare() {
        Au10tixCore.shared.delegate = self
        let proofOfAddressFeatureManager = ProofOfAddressFeatureManager()
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard granted else { return }
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                Au10tixCore.shared.startSession(with: proofOfAddressFeatureManager,
                                                previewView: self.cameraView)
            }
        }
    }
    
    // MARK: - openPOAResults
    
    func openPOAResults(_ result: ProofOfAddressSessionResult) {
        
        guard let resultImage = result.image?.uiImage else {
            return
        }
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultImage = resultImage
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
        Au10tixCore.shared.takeStillImage()
    }
}

// MARK: - HANDLE SESSION EVENTS

extension POAUIViewController: Au10tixSessionDelegate {
    
    /**
     Gets called whenever the session has an update.
     */
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        
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
        
        // MARK: - ProofOfAddressSessionResult
        
        if let poaResult = result as? ProofOfAddressSessionResult {
            openPOAResults(poaResult)
        }
    }
}
