//
//  ViewController.swift
//  Au10Tix_Demo
//
//  Created by Anton Sakovych on 06.10.2020.
//  Copyright © 2020 au10tix. All rights reserved.
//

import Foundation

final class UserSessionManager {
    
    #warning("Insert the token from the server here")
    
    private var serverToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImtleTEifQ.eyJzdWIiOiIwb2E1aHpuazd3UVZGS0JoeDM1NyIsImlzcyI6IjBvYTVoem5rN3dRVkZLQmh4MzU3IiwiYXVkIjoiaHR0cHM6Ly9sb2dpbi5hdTEwdGl4LmNvbS9vYXV0aDIvYXVzM21sdHM1c2JlOVdEOFYzNTcvdjEvdG9rZW4iLCJleHAiOjE2MDU0NTMwNDQsImlhdCI6MTYwNTQ0OTQ0M30.MWFQYy8Qe6va-CGFXFqgH4rIIXR56mHZDie24Z0-lDl7BD1SNDkD0cYbseN8jbCSiu4VZCdEe8ShROCpJbMVSVW6MU9GzyKI_vNK9UnIcF1lVIfFgZVYHKjJ-1vAV5WlYAJIO_t9-IQuRlkq_j9RlEx3Td9BC40vpUSXhbNBAMP_tzZp6NgvVPyhPkQPMEw_YfmGWIsaUH7OFHqCZWC7rhW-NxacoJ8dkqvr67BAOpvyuvCw42DkTXBDNdTBdGyjbKbQVXNp8diIizDl3X79k4GWHrYcIoNbD5IFcvQah64jeNhIsPR3wjWk1wf8jDyC_VfBMNcLDgJXJeDegg9EeQ"
    
    let networkService = NetworkService()
}

// MARK: - Public methods

extension UserSessionManager {
    
    func getJWTToken(token: String?, onSuccess: ((_ refreshedData: RefreshTokenData) -> Void)? = nil,
                     onError: ((_ error: ErrorHandel) -> Void)? = nil) {
        
        var requestBody: Requestable
        
        if let shortTokent = token {
            requestBody = RefreshTokenRequest(masterToken: shortTokent)
        } else {
            requestBody = RefreshTokenRequest(masterToken: serverToken)
        }
        
        runRefreshToken(request: requestBody, onSuccess: { response in
            
            let token = response.accessToken
            
            LocalStorage.setValueTo(servise: .token, value: token)
            
            onSuccess?(response)
        }, onError: onError)
    }
    
    func getRequestId(attachments: [MultipartItem], onSuccess: ((_ refreshedData: BeginProcessingIdentityData) -> Void)? = nil,
                      onError: ((_ error: ErrorHandel) -> Void)? = nil) {
        guard let token = LocalStorage.getValueFrom(servise: .token) else {
            return
        }
        
        let requestBody = BeginProcessingIdentityRequest(token: token, attachments: attachments)
        
        runGetRequestId(request: requestBody, onSuccess: onSuccess, onError: onError)
    }
    
    func getEndantity(requestId: String, onSuccess: ((_ refreshedData: BeginProcessingIdentityData) -> Void)? = nil,
                      onError: ((_ error: ErrorHandel) -> Void)? = nil) {
        
        guard let token = LocalStorage.getValueFrom(servise: .token) else {
            return
        }
        
        let requestBody = GeIdentityRequest(masterToken: token, requestId: requestId)
        
        runGetEndantity(request: requestBody, onSuccess: onSuccess, onError: onError)
    }
}

// MARK: - API methods

private extension UserSessionManager {
    func runRefreshToken(request body: Requestable,
                         onSuccess: ((_ refreshedData: RefreshTokenData) -> Void)? = nil,
                         onError: ((_ error: ErrorHandel) -> Void)? = nil) {
        
        networkService.runRequest(body, onSuccess: { onSuccess?($0) }, onError: { onError?($0) })
    }
    
    func runGetRequestId(request body: Requestable,
                         onSuccess: ((_ refreshedData: BeginProcessingIdentityData) -> Void)? = nil,
                         onError: ((_ error: ErrorHandel) -> Void)? = nil) {
        
        networkService.runRequest(body, onSuccess: { onSuccess?($0) }, onError: { onError?($0) })
    }
    
    func runGetEndantity(request body: Requestable,
                         onSuccess: ((_ refreshedData: BeginProcessingIdentityData) -> Void)? = nil,
                         onError: ((_ error: ErrorHandel) -> Void)? = nil) {
        
        networkService.runRequest(body, onSuccess: { onSuccess?($0) }, onError: { onError?($0) })
    }
}
