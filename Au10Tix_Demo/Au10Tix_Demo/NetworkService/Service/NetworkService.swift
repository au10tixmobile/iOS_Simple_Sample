//
//
//  Created by Anton Sakovych on 07.10.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation
import UIKit

final class NetworkService {
    
    private var task: URLSessionTask?
    
    private var builder = RequestBuilder()
    
    private let session = URLSession.shared
    
    func runRequest<M: Codable>(_ body: Requestable,
                                  onSuccess: @escaping (M) -> (),
                                  onError: @escaping (ErrorHandel) -> ()) {
        
        let request = builder.buildRequest(from: body)
        // if request is good elsse error
        
        
        task = session.dataTask(with: request, completionHandler: {[weak self] data, response, error in
            
           // guard let self = self else { return }
           
//            guard self.errorVerification(dataError: error, onError: onError) else {
//                self.handleNonSucessResponse(data: data, onError: onError)
//                return
//            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            let statusCode = HTTPStatusCode.init(rawValue: httpResponse.statusCode )
            
            switch statusCode {
            case .success:
                self?.handleSuccessResponse(data: data, onSuccess: onSuccess, onError: onError)
            default:
                self?.handleNonSucessResponse(data: data, onError: onError)
            }
        })
        
        self.task?.resume()
    }
    
    // MARK: error Verifying
    
    private func errorVerification(dataError: Error?, onError: @escaping (ErrorHandel) -> ()) -> Bool {
        if let error = dataError {
            onError(ErrorHandel(error: error))
            return false
        }
        
        return true
    }
    
    deinit {
        self.task?.cancel()
    }
    
    private func handleSuccessResponse<M: Codable>(data: Data?, onSuccess: @escaping (M) -> Void, onError: @escaping (ErrorHandel) -> ()) {
        let codableResult: (model: M?, parseError: ErrorHandel?) = decodeData(data: data)
        if let model = codableResult.model {
            onSuccess(model)
        } else if let error = codableResult.parseError {
            onError(error)
        } else {
            onError(.emptyErrorWith(code: 000))
        }
    }
    
     func handleNonSucessResponse(data: Data?, onError: @escaping (ErrorHandel) -> Void) {
        let codableError: (model: ErrorHandel?, parseError: ErrorHandel?) = decodeData(data: data)
        onError(codableError.model ?? codableError.parseError ?? .emptyErrorWith(code: 000))
    }
}

// MARK: - Private methods
    
private  func decodeData<M: Codable>(data: Data?) -> (model: M?, parseError: ErrorHandel?) {
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
