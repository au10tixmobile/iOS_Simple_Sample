//
// ResultViewController.swift
// Au10tixSimpleSample
//
// Create By Au10tixon.
//

import UIKit

final class ResultViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var imResult: UIImageView!
    @IBOutlet private weak var lblResult: UILabel!
    
    // MARK: - Public properties
    
    var resultImage: UIImage?
    var resultString: String?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ------
        prepare()
    }
}

// MARK: - Private Methods

private extension ResultViewController {
    
    func prepare() {
        if resultImage != nil {
            imResult.image = resultImage
        }
        
        if resultString != nil {
            lblResult.text = resultString
        }
    }
}

// MARK: Actions

private extension ResultViewController {
    
    @IBAction func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
