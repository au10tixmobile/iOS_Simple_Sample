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
    
    func runRequest<M: Modelable>(_ body: Requestable,
                                  onSuccess: @escaping (M) -> (),
                                  onError: @escaping (ErrorHandel) -> ()) {
        
        let session = URLSession.shared
        
        let request = builder.buildRequest(from: body)
        
        NetworkLogger.log(request: request)
        
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            print(String(data: data!, encoding: .utf8)!)
            
            guard self.errorVerification(dataError: error, onError: onError) else {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            let statusCode = HTTPStatusCode.init(rawValue: httpResponse.statusCode )
            
            switch statusCode {
            case .success:
                ResponseHandler.handleSuccessResponse(data: data, onSuccess: onSuccess, onError: onError)
            default:
                ResponseHandler.handleNonSucessResponse(data: data, onError: onError)
            }
        })
        
        self.task?.resume()
    }
    
    
    // MARK: error Verifying
    
    func errorVerification(dataError: Error?, onError: @escaping (ErrorHandel) -> ()) -> Bool {
        if let error = dataError {
            onError(ErrorHandel(error: error))
            return false
        }
        
        return true
    }
    
    func cancel() {
        self.task?.cancel()
    }
}
