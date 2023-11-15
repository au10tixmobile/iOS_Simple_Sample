//
// MainViewController.swift
// Au10tixSimpleSample
//
// Create By Au10tixon.
//

import UIKit
import AVFoundation

#if canImport(Au10tixCore)
import Au10tixCore
#endif

#if canImport(Au10tixBaseUI)
import Au10tixBaseUI
#endif

#if canImport(Au10tixProofOfAddressKit)
import Au10tixProofOfAddressKit
#endif

#if canImport(Au10tixSmartDocumentCaptureKit)
import Au10tixSmartDocumentCaptureKit
#endif

#if canImport(Au10tixPassiveFaceLivenessKit)
import Au10tixPassiveFaceLivenessKit
#endif

#if canImport(Au10tixProofOfAddressUI)
import Au10tixProofOfAddressUI
#endif

#if canImport(Au10tixSmartDocumentCaptureUI)
import Au10tixSmartDocumentCaptureUI
#endif

#if canImport(Au10tixPassiveFaceLivenessUI)
import Au10tixPassiveFaceLivenessUI
#endif

#if canImport(Au10tixBEKit)
import Au10tixBEKit
#endif

#if canImport(Au10tixLivenessKit)
import Au10tixLivenessKit
#endif

#if canImport(Au10tixLivenessUI)
import Au10tixLivenessUI
#endif

#if canImport(Au10tixNFCPassportUI)
import Au10tixNFCPassportUI
#endif

#if canImport(Au10tixNFCPassportKit)
import Au10tixNFCPassportKit
#endif

#if canImport(Au10tixVoiceConsentUI)
import Au10tixVoiceConsentUI
#endif

#if canImport(Au10tixLocalDataInferenceKit)
import Au10tixLocalDataInferenceKit
#endif

final class MainViewController: UIViewController {
    
    private var pflResultString: String?
    private var localClassification: Bool = false
    
    // MARK: - IBOutlets
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------
        
        uiPreparation()
        requestVideoPermission()
        addObserver()
    }
    
    private func present(controller: UIViewController) {
        getTopMostViewController()?.present(controller, animated: true, completion: nil)
    }
    
    private func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.windows.first?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    private func presentLocalSDCModulesUpdatingLoader() -> UIAlertController {
        let loader = loaderAlert("Updating modules...")
        present(controller: loader)
        return loader
    }
    
    private func loaderAlert(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        return alert
    }
    
}

// MARK: - Private Methods

private extension MainViewController {
    
    private func requestVideoPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.prepare()
        case .denied, .restricted:
            self.showAlert("Video Permission was not granted", isError: true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] _ in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.requestVideoPermission()
                }
            }
        @unknown default:
            fatalError()
        }
    }
    // MARK: - SDK Preparation
    /**
     Use this method to prepare Au10tix SDK.
     - warning: Use the JWT retrieved from your backend. See Au10tix guide for more info.
     */
    func prepare() {
        
        #warning("Use the JWT retrieved from your backend. See Au10tix guide for more info")
        let jwtToken = ""
        
#if canImport(Au10tixCore)
        Au10tix.shared.prepare(with: jwtToken) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let sessionID):
                debugPrint("sessionID -\(sessionID)")
            case .failure(let error):
                self.showAlert(error.localizedDescription, isError: true)
            }
        }
#endif
    }
    
    // MARK: - Open SMART DOCUMENT CAPTURING UI component
    /**
     Use this method to initialize the SMART DOCUMENT CAPTURING UI component.
     */
    
    func openSDCUIComponent() {
#if canImport(Au10tixBaseUI)
        let configs = UIComponentConfigs()
#if canImport(Au10tixSmartDocumentCaptureUI)
        let controller = SDCViewController(configs: configs, navigationDelegate: self)
        controller.sdcDelegate = self
        controller.localClassification = localClassification
        updateModulesIfAvailable { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                guard let self = self else { return }
                self.present(controller: controller)
            }
        }
#endif
#endif
    }
    
    // MARK: - Open PASSIVE FACE LIVENESS UI component.
    /**
     Use this method to initialize the PASSIVE FACE LIVENESS UI component.
     */
    
    func openPFLUIComponent() {
#if canImport(Au10tixBaseUI)
        let configs = UIComponentConfigs()
#if canImport(Au10tixPassiveFaceLivenessUI)
        let controller = PFLViewController(configs: configs, navigationDelegate: self)
        controller.pflDelegate = self
        self.present(controller: controller)
#endif
#endif
    }
    
    // MARK: - Open LIVENESS UI component.
    /**
     Use this method to initialize the LIVENESS UI component.
     */
    
    func openLivenessUIComponent() {
#if canImport(Au10tixBaseUI)
        let configs = UIComponentConfigs()
#if canImport(Au10tixLivenessUI)
        let livenessVC = LivenessViewController(configs: configs, navigationDelegate: self)
        livenessVC.livenessSessionDelegate = self
        self.present(controller: livenessVC)
#endif
#endif
    }
    
    // MARK: - Open PROOF OF ADDRESS UI component.
    /**
     Use this method to initialize the PROOF OF ADDRESS UI component.
     */
    
    func openPOAUIComponent() {
#if canImport(Au10tixBaseUI)
        let configs = UIComponentConfigs()
#if canImport(Au10tixProofOfAddressUI)
        let controller = POAViewController(configs: configs, navigationDelegate: self)
        controller.poaDelegate = self
        self.present(controller: controller)
#endif
#endif
    }

    // MARK: - Open NFC UI component.
    /**
     Use this method to initialize the NFC UI component.
     */
    
    func openNFCUIComponent() {
#if canImport(Au10tixBaseUI)
        let configs = UIComponentConfigs()
#if canImport(Au10tixSmartDocumentCaptureUI)
        _ = SDCViewController()
#endif
#if canImport(Au10tixNFCPassportUI)
        let controller = NFCViewController(configs: configs, navigationDelegate: self)
        controller.nfcDelegate = self
        controller.modalPresentationStyle = .fullScreen
        self.present(controller: controller)
#endif
#endif
    }

    
    // MARK: - Open Voice Consent UI component.
    /**
     Use this method to initialize the VC UI component.
     */
    
    func openVCUIComponent() {
#if canImport(Au10tixBaseUI)
        let configs = UIComponentConfigs()
#if canImport(Au10tixVoiceConsentUI)
        let controller = VCViewController(configs: configs, navigationDelegate: self)
        controller.vcDelegate = self
        self.present(controller: controller)
#endif
#endif
    }

    // MARK: - Open PFLViewController
    
    func openPFLViewController() {
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PFLUIViewController") as? PFLUIViewController else {
            return
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Open SDCViewContrller
    
    func openSDCViewContrller() {
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SDCUIViewController") as? SDCUIViewController else {
            return
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Open POAUIViewController
    
    func openPOAViewContrller() {
        
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "POAUIViewController") as? POAUIViewController else {
            return
        }
        
        navigationController?.pushViewController(controller, animated: true)
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
    
    // MARK: - openSDCResults
    
#if canImport(Au10tixCore)
    func openSDCResult(_ image: Au10Image) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultImage = image.uiImage
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - openPOAResults
    
    func openPOAResult(_ image: Au10Image) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        controller.resultImage = image.uiImage
        navigationController?.pushViewController(controller, animated: true)
    }
#endif
    
    // MARK: - UIAlertController
    
    func showAlert(_ text: String, isError: Bool) {
        let alert = UIAlertController(title: isError ? "Error ☹️" : "Success 😀", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(controller: alert)
    }
    
    // MARK: - Buttons Preparation
    
    func uiPreparation() {
        stackView.arrangedSubviews
            .compactMap{ $0 as? UIButton }
            .compactMap{ $0.titleLabel}
            .forEach {
                $0.lineBreakMode = .byWordWrapping
                $0.textAlignment = .center
            }
    }
    
    // MARK: - Observer
    
    func addObserver() {
#if canImport(Au10tixCore)
        NotificationCenter.default.addObserver(self, selector: #selector(handleExpirationNotification(_:)),
                                               name: .au10tixCoreTokenExpiration, object: nil)
#endif
    }
    
    @objc func handleExpirationNotification(_ sender: Notification) {
        let alert = UIAlertController(title: "Error", message: "Session Is Expired", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(controller: alert)
    }
    
    private func updateModulesIfAvailable(_ completion: @escaping () -> ()) {
        if localClassification {
#if canImport(Au10tixLocalDataInferenceKit)
            let loader = presentLocalSDCModulesUpdatingLoader()
            Au10tixLocalDataInferenceManager.updateModules { result in
                print("Au10tixLocalDataInferenceKit updateModules result:\(result)")
                DispatchQueue.main.async {
                    loader.dismiss(animated: false) { completion() }
                }
            }
#else
            completion()
#endif
        } else {
            completion()
        }
    }
    
}

// MARK: - Actions

private extension MainViewController {
    
    @IBAction func btnSDCAction() {
        openSDCViewContrller()
    }
    
    @IBAction func btnPFLAction() {
        openPFLViewController()
    }
    
    @IBAction func btnPOAAction() {
        openPOAViewContrller()
    }
    
    @IBAction func btnSDCwithUIAction() {
        openSDCUIComponent()
    }
    
    @IBAction func btnPFLwithUIAction() {
        openPFLUIComponent()
    }
    
    @IBAction func btnPOAwithUIAction() {
        openPOAUIComponent()
    }
    
    @IBAction func btnLivenessWithUIAction() {
        openLivenessUIComponent()
    }

    @IBAction func btnNFCWithUIAction() {
        openNFCUIComponent()
    }

    @IBAction func btnVCWithUIAction() {
        openVCUIComponent()
    }
    
    @IBAction func classificationSourceSegmentedChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            localClassification = false
        } else {
            localClassification = true
        }
    }

    @IBAction func sendIdvRequest(sender: UIButton) {
        let originalTitle = sender.title(for: .normal)
        sender.setTitle("Sending...", for: .normal)
#if canImport(Au10tixBEKit)
        Au10tixBackendKit.shared.sendIDVerificationFlow { [weak self, weak sender] result in
            guard let self = self, let sender = sender else { return }
            sender.setTitle(originalTitle, for: .normal)
            switch result {
            case .success(let requestId):
                self.showAlert("✅ RequestId: " + requestId, isError: false)
            case .failure(let error):
                self.showAlert("❌ \(error)", isError: true)
            }
        }
#endif
    }
    
    @IBAction func sendPoaRequest(sender: UIButton) {
        let alert = UIAlertController(title: "Proof Of Address Validation", message: "Fill details for comparison", preferredStyle: .alert)
        alert.addTextField {
            $0.placeholder = "First Name"
            $0.textContentType = .givenName
        }
        
        alert.addTextField {
            $0.placeholder = "Last Name"
            $0.textContentType = .familyName
        }
        
        alert.addTextField {
            $0.placeholder = "Address"
            $0.textContentType = .fullStreetAddress
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "🚀 Send", style: .default, handler: { [weak self, weak sender](_) in
            guard let self = self, let sender = sender else { return }
            guard let firstName = alert.textFields?[0].text,
                  let lastName = alert.textFields?[1].text,
                  let address = alert.textFields?[2].text else { return }
            
            let originalTitle = sender.title(for: .normal)
            sender.setTitle("Sending...", for: .normal)
            
#if canImport(Au10tixBEKit)
            Au10tixBackendKit.shared.sendProofOfAddress(firstName: firstName, lastName: lastName, address: address) { [weak self, weak sender](result) in
                guard let self = self, let sender = sender else { return }
                sender.setTitle(originalTitle, for: .normal)
                switch result {
                case .success(let requestId):
                    self.showAlert("✅ RequestId: " + requestId, isError: false)
                case .failure(let error):
                    self.showAlert("❌ \(error)", isError: true)
                }
            }
#endif
        }))
        
        self.present(controller: alert)
    }
}

//MARK: - POASessionDelegate

#if canImport(Au10tixProofOfAddressKit)
extension MainViewController: POASessionDelegate {
    
    /**
    Gets Called when Proof Of Address session failed
     */
    func poaSession(_ poaSession: POASession, didFailWith error: POASessionError) {
        
    }
    
    /**
    Gets Called when Proof Of Address image was taken
     */
    func poaSession(_ poaSession: POASession, didCapture image: Au10Image, with frameData: Au10Update) {
        openPOAResult(image)
    }
    
}
#endif

//MARK: - SDCSessionDelegate

#if canImport(Au10tixSmartDocumentCaptureKit)
extension MainViewController: SDCSessionDelegate {
    
    /**
    Gets Called when Smart Documet session failed
     */
    func sdcSession(_ sdcSession: SDCSession, didFailWithError error: SDCSessionError) {
        
    }
    
    /**
    Gets Called when Smart Documet result is received and processed
     */
    func sdcSession(_ sdcSession: SDCSession, didProcess processingStatus: SDCProcessingStatus) {
        
    }
    
    /**
    Gets Called when document was taken
     */
    func sdcSession(_ sdcSession: SDCSession, didCapture image: Au10Image, croppedImage: Au10Image?, with processingStatus: SDCProcessingStatus) {
        openSDCResult(croppedImage ?? image)
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

//MARK: - PFLSessionDelegate

#if canImport(Au10tixPassiveFaceLivenessKit)
extension MainViewController: PFLSessionDelegate {
        
    /**
    Gets Called upon image sample is captured
     */
    func pflSession(_ pflSession: PFLSession, didCapture image: Data, qualityFeedback: QualityFaultOptions, faceBoundingBox: CGRect?) {
        
    }

    /**
    Gets Called for quality feedbcak while capturing session is running
     */
    func pflSession(_ pflSession: PFLSession, didRecieve qualityFeedback: QualityFaultOptions) {
        
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
        guard let uiImage = UIImage(data: image) else { return }
        self.openPFLResult(uiImage, resultString: self.pflResultString ?? "")
    }
    
    /**
    Gets Called when PFL failed
     */
    func pflSession(_ pflSession: PFLSession, didFailWith error: PFLSessionError) {
        
    }
    
    /**
    Gets Called when Helmet detection result delivered
     */
    func pflSession(_ pflSession: PFLSession, didCapture image: Data, qualityFeedback: QualityFaultOptions, faceBoundingBox: CGRect?, isHelmet: Bool, asHat: Double, asHelmet: Double, asNone: Double) {
        
    }
    
}
#endif

#if canImport(Au10tixLivenessKit)
extension MainViewController: LivenessSessionDelegate {
    
    /**
    Gets Called when Liveness finished
     */
    func livenessSession(_ session: LivenessSession, didFinishWithResult result: LivenessSessionResult) {
        
    }
    
    /**
    Gets Called when Liveness has an update
     */
    func livenessSession(_ session: LivenessSession, didReceiveAnUpdate update: LivenessSessionUpdate) {
        
    }
    
    /**
    Gets Called when Liveness failed
     */
    func livenessSession(_ session: LivenessSession, didFailWithError error: LivenessSessionError) {
        
    }
    
    /**
    Gets Called when Liveness waiting for user action due to 'reason'
     */
    func livenessSession(_ session: LivenessSession, waitingForUserAction reason: LivenessSessionWaitingForUserReason) {
        //you can show some UI prior to proceedToNextStep invokation
        session.proceedToNextStep()
    }
    
    /**
    Gets Called when Liveness session screen recording failed
     */
    func livenessSession(_ session: LivenessSession, didFailScreenRecordingWith error: ScreenRecorderError) {
        
    }
    
}
#endif

#if canImport(Au10tixBaseUI)
extension MainViewController: UIComponentViewControllerNavigationDelegate {
    /**
     Gets called whenever an UI-Comp finished.
     */
    func uiComponentViewControllerDidFinish(_ controller: UIComponentBaseViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    /**
     Gets called whenever an UI-Comp close button pressed.
     */
    func uiComponentViewControllerDidPressClose(_ controller: UIComponentBaseViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
#endif

#if canImport(Au10tixVoiceConsentUI)
extension MainViewController: VCSessionDelegate {
    func vcSession(_ vcSession: Au10tixVoiceConsentUI.VCSession, didFailWith error: Au10tixVoiceConsentUI.VCSessionError) {
        
    }
    
    func vcSession(_ vcSession: Au10tixVoiceConsentUI.VCSession, didCapture videoUrl: URL) {
        
    }
    
    
}
#endif

#if canImport(Au10tixNFCPassportKit)
extension MainViewController: NFCPassportSessionDelegate {
    func nfcPassportSession(_ nfcPassportSession: Au10tixNFCPassportKit.NFCPassportSession, didScan passportMRZ: String, in frame: CIImage) {
        
    }
    
    func nfcPassportSession(_ nfcPassportSession: Au10tixNFCPassportKit.NFCPassportSession, didIndicate extractionProgress: String, of extractionPhase: String?) {
        
    }
    
    func nfcPassportSession(_ nfcPassportSession: Au10tixNFCPassportKit.NFCPassportSession, didExtract nfcInfo: Au10tixNFCPassportKit.PassportInformation) {
        
    }
    
    func nfcPassportSession(_ nfcPassportSession: Au10tixNFCPassportKit.NFCPassportSession, didFailWith error: Au10tixNFCPassportKit.NFCPassportSessionError) {
        
    }
    
    func nfcPassportSession(_ nfcPassportSession: Au10tixNFCPassportKit.NFCPassportSession, didIndicate dataGroupsFound: [String]) {
        
    }
    
}
#endif
