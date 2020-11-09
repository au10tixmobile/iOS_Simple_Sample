//
//
//  Created by Anton Sakovych on 06.10.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//


import Foundation

struct RefreshTokenRequest: Requestable {
    var jwtToken: String
    
    private var masterToken: String = ""
    private let scope = "pfl sdc mobilesdk"
    
    
    var url: String {
        return "https://weu-cm-apim-dev.azure-api.net/oauth2/v1/token"
    }
    
    var HTTPMethod: Method {
        return .post
    }
    
    var headers: HTTPHeaders {
        return Headers.main(additional: ["Content-Type": "application/x-www-form-urlencoded"])
    }
    
    var parameters: Parameters? {
        return["scope" : "pfl sdc mobilesdk",
               "client_assertion" : masterToken]}
    
    init(masterToken: String) {
        self.masterToken = masterToken
        jwtToken = masterToken
    }
}

