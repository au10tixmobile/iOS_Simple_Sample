//
//  Storyboards.swift
//  Au10Tix_Demo
//
//  Created by Anton Sakovych on 20.10.2020.
//

import UIKit

protocol ControllerRepresentable {
    
    static var initialViewController: UIViewController? { get }
    
}

extension ControllerRepresentable {
    
    static var initialViewController: UIViewController? {
        return UIStoryboard(name: "\(self.self)", bundle: nil).instantiateInitialViewController()
    }
    
}

extension ControllerRepresentable where Self: RawRepresentable, Self.RawValue == String {
    
    var controller: UIViewController {
        return UIStoryboard(name: "\(type(of: self))", bundle: nil)
            .instantiateViewController(withIdentifier: rawValue.capitalizedFirstChar)
    }

}

struct Storyboards {
    
    struct LaunchScreen: ControllerRepresentable { }
    
  
    enum Main: String, ControllerRepresentable {
         case sDCUIViewController
         case pFLUIViewController
    }
}


