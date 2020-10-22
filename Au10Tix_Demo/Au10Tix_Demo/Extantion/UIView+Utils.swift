//
//  UIView+Utils.swift
//  Au10tix
//
//  Created by Anton Sakovych on 27.05.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

extension UIView {
   
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            if let lColor = layer.borderColor {
                return UIColor(cgColor: lColor)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    func findSuperView<T: UIView>(_ view: T.Type) -> T? {
        if let supView = superview {
            if let needTypeSuperView = supView as? T {
                return needTypeSuperView
            }
            return supView.findSuperView(view)
        }
        return nil
    }
}
