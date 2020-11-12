//
//
//  Created by Anton Sakovych on 03.11.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

// MARK: - RefreshTokenData

public struct BeginProcessingIdentityData: Codable {
    public let requestID: String
    public let requestStateCode: Int
    
    enum CodingKeys: String, CodingKey {
        case requestID = "RequestId"
        case requestStateCode = "RequestStateCode"
    }
    
    public init(requestID: String, requestStateCode: Int) {
        self.requestID = requestID
        self.requestStateCode = requestStateCode
    }
}
