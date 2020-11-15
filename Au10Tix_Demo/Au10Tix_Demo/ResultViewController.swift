//
//  ResultViewController.swift
//  Au10Tix_Demo
//
//  Created by Anton Sakovych on 14.11.2020.
//

import UIKit
import Au10tixCore
import Au10tixCommon
import Au10PassiveFaceLiveness
import Au10SmartDocumentCaptureFeature


final class ResultViewController: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
//        static let successMessage: String = "Success"
    }
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak  var lblResult: UILabel!
    @IBOutlet weak  var imResult: UIImageView!
    
    
     var documentCaptureSessionResultImage: Au10Image?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imResult.image = documentCaptureSessionResultImage?.uiImage
    }
}
