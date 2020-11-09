//
//
//  Created by Anton Sakovych on 11.10.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

struct RequestBuilder {
    
    typealias Parameters = [String: Any]
    
    func buildRequest(from body: Requestable) -> URLRequest {
        
        // Base URL
        
        let dataURL = URL(string: body.baseURL + body.url)!
        
        // Base Request
        
        var request = URLRequest(url: dataURL,
                                 timeoutInterval: Double.infinity)
        
        request.httpMethod = body.HTTPMethod.rawValue
        
        
        for (key, value) in body.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        switch body.encoding {
        case .queryString:
            encodeQuery(urlRequest: &request, with: body)
        case .jsonEncoding:
            encodeJSON(urlRequest: &request, with: body)
        case .multipart:
            encodeMultipart(urlRequest: &request, with: body)
        }
        
        return request
    }
}

// MARK: Private Methods

private extension RequestBuilder {
    
    func encodeJSON(urlRequest: inout URLRequest, with body: Requestable) {
        
        if  let encodePaparameters = body.parameters {
            do {
                let jsonAsData = try JSONSerialization.data(withJSONObject: encodePaparameters, options: .prettyPrinted)
                urlRequest.httpBody = jsonAsData
                
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                print("Parameter encoding failed.")
            }
        }
    }
    
    // Query
    
    func encodeQuery(urlRequest: inout URLRequest, with body: Requestable) {
        
        if  let encodePaparameters = body.parameters {
            urlRequest.httpBody = encodePaparameters.percentEncoded()
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
        }
    }
    
    // Multipart
    
    func encodeMultipart(urlRequest: inout URLRequest, with body: Requestable) {
        
        let httpBody = NSMutableData()
        
        if  let encodePaparameters = body.parameters {
            for (key, value) in encodePaparameters {
                httpBody.appendString(convertFormField(named: key, value: value as! String, using: body.boundary))
            }
        }
        
        for attachment in body.attachments! {
            
            httpBody.append(convertFileData(fieldName: attachment.parametrName,
                                            fileName: attachment.fileName,
                                            mimeType:  attachment.type,
                                            fileData: attachment.data,
                                            using:  body.boundary))
            
            httpBody.appendString("--\(body.boundary)--")
        }
        
        urlRequest.httpBody = httpBody as Data
    }
    
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        
        return fieldString
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        
        return data as Data
    }
}
