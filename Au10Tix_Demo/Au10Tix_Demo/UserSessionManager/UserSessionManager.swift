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
    
    private var serverToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImtleTEifQ.eyJzdWIiOiIwb2E1aHpuazd3UVZGS0JoeDM1NyIsImlzcyI6IjBvYTVoem5rN3dRVkZLQmh4MzU3IiwiYXVkIjoiaHR0cHM6Ly9sb2dpbi5hdTEwdGl4LmNvbS9vYXV0aDIvYXVzM21sdHM1c2JlOVdEOFYzNTcvdjEvdG9rZW4iLCJleHAiOjE2MDUzNzA0MTQsImlhdCI6MTYwNTM2NjgxM30.V2GcpTaWHSfljB3X5u3I7jsb2Fo_872Nm4Iz-Y3Tx8Ks3wDsyfqR4IyfQqFJfNbeuH2a7CGddeomfv2NgIsbDdKMMQERDAQx1byM4juaeF0xRXKQdyspPWgfLzBnEbZZ37b1I06XK-vapNS3GvJFFR6TgvURW26bh4vzzUsQWoWCHMdk6M1wy-QAGpDKVw2ORftW6IDsZvapqGJOIi2rnC-52x_0WiPeK8QOrxl9SYHV8yxp3Zb5gw4S8RW5zieyWm6B9xgwSl70FwOWMhJB_atpVaLSIW5uoF727UrpezqaKgfp8vvovoJY2WLEdmeJI1o-abW3e8N5IGI_G0XY5A"
    
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
