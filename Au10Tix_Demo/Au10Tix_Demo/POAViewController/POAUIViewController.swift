//
//  POAUIViewController.swift
//  Au10Tix_Demo
//
//  Created by Anton Sakovych on 27.11.2020.
//

import UIKit
import AVFoundation
import Au10tixCore
import Au10tixPOA

final class POAUIViewController: UIViewController {
    
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
        Au10tixCore.shared.stopSession()
    }
}

// MARK: Private Methods

private extension POAUIViewController {
    
    // Prepare SDK
    
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
    
    // MARK: - Show Updates
    
    func showDetails(_ update: ProofOfAddressSessionUpdate) {
        lblInfo.text = getUpdatesList(update)
    }
    
    // MARK: - Updates List
    
    func getUpdatesList(_ update: ProofOfAddressSessionUpdate) -> String {
        return ""
    }
    
    // MARK: - UIAlertController
    
    func showAlert(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Au10tixSessionDelegate

extension POAUIViewController: Au10tixSessionDelegate {
    
    func didGetUpdate(_ update: Au10tixSessionUpdate) {
        
        // MARK: - ProofOfAddressSessionUpdate
        
        if let proofOfAddressSessionUpdate = update as? ProofOfAddressSessionUpdate {
            showDetails(proofOfAddressSessionUpdate)
        }
    }
    
    func didGetError(_ error: Au10tixSessionError) {
        showAlert(error.localizedDescription)
    }
    
    func didGetResult(_ result: Au10tixSessionResult) {
        
        // MARK: - ProofOfAddressSessionResult
        
        if let poaResult = result as? ProofOfAddressSessionResult {
            openPOAResults(poaResult)
        }
    }
}
