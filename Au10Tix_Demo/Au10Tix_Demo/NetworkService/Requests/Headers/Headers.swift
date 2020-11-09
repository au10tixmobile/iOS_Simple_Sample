//
//
//  Created by Anton Sakovych on 06.10.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

struct Headers {
    
    static func main(additional: [String: String]? = nil) -> [String: String] {
        
        var headers: [String: String] = [:]
        
        guard let additional = additional else {
            return headers
        }
        
        additional.forEach({ headers[$0.key] = $0.value })
        
        return headers
    }

}
