//
//
//  Created by Anton Sakovych on 02.11.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

struct BeginProcessingIdentityRequest: Requestable {
    
    var jwtToken: String = ""
    
    let boundary: String = "Boundary-\(UUID().uuidString)"
    
    private var temp: [MultipartItem]?
    
    var url: String {
        return "https://api.au10tixservicesdev.com/IdentityDocuments/v1/BeginProcessingRequest"
    }
    
    var HTTPMethod: Method {
        return .post
    }
    
    var headers: HTTPHeaders {
        return Headers.main(additional: ["Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Authorization": "Bearer " + jwtToken])
    }
    
    var encoding: EncodingParameter {
        return .multipart
    }
    
    var parameters: Parameters? {
        return ["requestData": "{\r\n  \"identityDocumentProcessingRequest\": {\r\n    \"documentPages\": [\r\n      {\r\n        \"documentImages\": [\r\n          {\r\n            \"imageUri\": \"documentImage_Page0\"\r\n          }\r\n        ]\r\n      }\r\n    ],\r\n  },\r\n}"]
        
    }
    
    var attachments: [MultipartItem]? {
        return temp
    }
    
    init(token: String, attachments: [MultipartItem]) {
        self.jwtToken = token
        self.temp = attachments
    }
}

