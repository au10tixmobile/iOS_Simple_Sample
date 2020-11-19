//
//  ResultViewController.swift
//  Au10Tix_Demo
//
//  Created by Anton Sakovych on 14.11.2020.
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

// MARK: Private Methods

private extension ResultViewController {
    
    func prepare() {
        if resultImage != nil {
            imResult.image = resultImage
        }
        
        if resultString != nil {
            lblResult.text = resultString
        }
    }
    
    @IBAction func popToRoot() {
        self.navigationController?.popViewController(animated: false)
    }
}
