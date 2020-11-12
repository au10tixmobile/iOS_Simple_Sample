//
//
//  Created by Anton Sakovych on 03.11.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

struct GeIdentityRequest: Requestable {
    
    private var jwtToken: String
    private var requestId = ""
    
    var url: String {
        return "https://mobile.au10tixservicesqa.com/Au10tixBos4/IdentityDocuments/Results/\(requestId)?imagetypes=photoofholder,visible"
    }
    
    var HTTPMethod: Method {
        return .get
    }
    
    var headers: HTTPHeaders {
        return ["Authorization": "JWT " + jwtToken]
    }
    
    init(masterToken: String, requestId: String) {
        self.jwtToken  = masterToken
        self.requestId = requestId
    }
}
