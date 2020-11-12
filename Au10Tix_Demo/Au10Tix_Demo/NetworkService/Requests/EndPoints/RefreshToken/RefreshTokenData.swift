//
//
//  Created by Anton Sakovych on 07.10.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

// MARK: - RefreshTokenData

public struct RefreshTokenData: Codable {
    public let tokenType: String
    public let expiresIn: Int
    public let accessToken, scope: String

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case scope
    }

    public init(tokenType: String, expiresIn: Int, accessToken: String, scope: String) {
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.accessToken = accessToken
        self.scope = scope
    }
}
