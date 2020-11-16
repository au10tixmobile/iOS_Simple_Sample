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
    
    private var serverToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImtleTEifQ.eyJzdWIiOiIwb2E1aHpuazd3UVZGS0JoeDM1NyIsImlzcyI6IjBvYTVoem5rN3dRVkZLQmh4MzU3IiwiYXVkIjoiaHR0cHM6Ly9sb2dpbi5hdTEwdGl4LmNvbS9vYXV0aDIvYXVzM21sdHM1c2JlOVdEOFYzNTcvdjEvdG9rZW4iLCJleHAiOjE2MDU1MjEyMzMsImlhdCI6MTYwNTUxNzYzMn0.fO6oweLxu6ctctNyqW3OTGuScHWD4eCqTCFLSKh4JGUmsBcqYJHBxg8DEqlAryeKRdTpWk4b9n7FNuUxruwa6-iBkr3_nbw4m7DD31Kne3uMSbZZtmFTBRLsQEIWCvbtkdqQj16SsyqxTKQETujnGYBHvny68F3qK0QSXOzxYTB27lOd7rwqqz_Du8SKWzdpelRuCnZsp996RB85N883hOQqndC3eQe5PXisg9HI5mMlIuxmTJqMV1i5Btc72JhRdkgnwYs95Odj4noX7doDNretXdFRyWqF6ZlFhGmVp2BPOcd6rog3Mw4fOZJpJ56XwaYdSRhLuMC21Oa3Jz8kFg"
    
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
