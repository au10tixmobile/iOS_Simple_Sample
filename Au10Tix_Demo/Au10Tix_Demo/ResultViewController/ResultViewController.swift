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
    
    // MARK: - Public properties
    
    var resultImage: UIImage?
    
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
    }
}
