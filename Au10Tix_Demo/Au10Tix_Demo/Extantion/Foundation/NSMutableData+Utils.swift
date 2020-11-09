//
//  NSMutableData+Utils.swift
//
//  Created by Anton Sakovych on 03.11.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}


