//
//
//  Created by Anton Sakovych on 11.10.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

enum HTTPStatusCode: Int {
    case processing = 102
    case success = 200
    case handleRestorePassword = 204
    case redirection = 400
    case unAuthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case `none`
    
    init(rawValue: Int) {
        switch rawValue {
        case 100..<200: self = .processing
        case 200..<300: self = .success
        case 300..<401: self = .redirection
        case 401: self = .unAuthorized
        case 402: self = .paymentRequired
        case 403: self = .forbidden
        case 404: self = .notFound
        case 500: self = .internalServerError
        case 501: self = .notImplemented
        case 502: self = .badGateway
        case 503: self = .serviceUnavailable
        default: self = .none
        }
    }
}

struct ErrorHandel: Codable, Equatable {
    var errors: [ErrorNetwork]
}

extension ErrorHandel {
    
    init(error: Error) {
        errors = [ErrorNetwork(status: (error as NSError).code, title: error.localizedDescription)]
    }
    
    static var missingResponseData: ErrorHandel {
        return ErrorHandel(errors: [ErrorNetwork(status: 204, title: "Missing Response data")])
    }

    static func emptyErrorWith(code: Int) -> ErrorHandel {
        return ErrorHandel(errors: [ErrorNetwork(status: code, title: "Something wrong with code: \(code)")])
    }
}

struct ErrorNetwork: Codable, Equatable {
    var status: Int
    var title: String
}
