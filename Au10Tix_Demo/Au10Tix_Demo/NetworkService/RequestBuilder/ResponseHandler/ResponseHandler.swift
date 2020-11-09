//
//
//  Created by Anton Sakovych on 12.10.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

struct ResponseHandler {
    
    static func handleSuccessResponse<M: Modelable>(data: Data?, onSuccess: @escaping (M) -> Void, onError: @escaping (ErrorHandel) -> ()) {
        let codableResult: (model: M?, parseError: ErrorHandel?) = decodeData(data: data)
        if let model = codableResult.model {
            onSuccess(model)
        } else if let error = codableResult.parseError {
            onError(error)
        } else {
            onError(.emptyErrorWith(code: 000))
        }
    }
    
    static func handleNonSucessResponse(data: Data?, onError: @escaping (ErrorHandel) -> Void) {
        let codableError: (model: ErrorHandel?, parseError: ErrorHandel?) = decodeData(data: data)
        onError(codableError.model ?? codableError.parseError ?? .emptyErrorWith(code: 000))
    }
}

// MARK: - Private methods

private extension ResponseHandler {
    
    static func decodeData<M: Modelable>(data: Data?) -> (model: M?, parseError: ErrorHandel?) {
        let decoder = JSONDecoder()
        guard let data = data else {
            return (nil, .missingResponseData)
        }
        do {
            return (try decoder.decode(M.self, from: data), nil)
        } catch {
            return (nil, ErrorHandel(error: error))
        }
    }
}
