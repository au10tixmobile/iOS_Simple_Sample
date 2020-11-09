//
//  Requestable.swift
//
//  Created by Anton Sakovych on 12.10.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

enum Method: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

enum EncodingParameter {
    case queryString // "application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type"
    case jsonEncoding // "application/json", forHTTPHeaderField: "Content-Type"
    case multipart // "multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
}

protocol Requestable {
    
    typealias Parameters = [String: Any]
    typealias HTTPHeaders = [String: String]
    
    var attachments: [MultipartItem]? { get }
    var baseURL: String { get }
    var HTTPMethod: Method { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders { get }
    var url: String { get }
    var encoding: EncodingParameter  { get }
    var boundary: String { get }
}

extension Requestable {
    
    var baseURL: String {
        return ""
    }
    
    var HTTPMethod: Method {
        return .get
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var attachments: [MultipartItem]? {
        return nil
    }
    
    var headers: HTTPHeaders {
        return Headers.main()
    }
    
    var encoding: EncodingParameter {
        return .queryString
    }
    
    var boundary: String {
        return ""
    }
}
