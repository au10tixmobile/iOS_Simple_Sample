//
//
//  Created by Anton Sakovych on 07.10.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

struct LocalStorage {
    enum ServiceItem: String, CaseIterable {
        case token
        case masterToken
//        case userId
    }
    
    static func setValueTo(servise: ServiceItem, value: String) {
        try? KeychainPasswordItem(service: servise.rawValue,
                                  account: servise.rawValue)
            .savePassword(value)
    }
    
    static func getValueFrom(servise: ServiceItem) -> String? {
        guard let result = try? KeychainPasswordItem(service: servise.rawValue,
                                                     account: servise.rawValue).readPassword() else {
                return nil
        }
        
        return result
    }
    
    static func removeValueFrom(servise: ServiceItem) {
        try? KeychainPasswordItem(service: servise.rawValue,
                                  account: servise.rawValue)
            .deleteItem()
    }
    
    static func removeAll() {
        ServiceItem.allCases.forEach({ value in
            do {
                try KeychainPasswordItem(service: value.rawValue, account: value.rawValue).deleteItem()
            } catch {
                
                debugPrint("catch error:\(error)")
            }
            
        })
    }
}
