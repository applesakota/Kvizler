//
//  RESTRequest.swift
//  QuizlerApp
//
//  Created by Petar Sakotic on 6/22/21.
//

import Foundation

extension RESTManager {
    
    enum HTTPMethod: String {
        case get    = "GET"
        case post   = "POST"
        case put    = "PUT"
        case patch  = "PATCH"
        case delete = "DELETE"
    }
}

extension RESTManager {
    
    /// REST Request class contains all HTML response processing logic.
    class RESTRequest {
        
        //MARK: - Globals
        
        let session: URLSession
        var request: URLRequest
        
        // MARK: - Init
        
        init(session: URLSession, request: URLRequest) {
            self.session = session
            self.request = request
        }
        
        init(session: URLSession, url: URL, method: HTTPMethod, useToken: Bool = false) {
            var urlRequest = URLRequest(url: url)
            
            //method
            urlRequest.httpMethod = method.rawValue
            
            //headers
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            if useToken {
                if let token = AppGlobals.securedLocalStorage.loadString(AppConstants.authAccessTokenKey()) {
                    urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
                }
            }
            
            
            self.session = session
            self.request = urlRequest
        }
        
        //MARK: - Copy Init
        
        func clone() -> RESTRequest {
            var request = URLRequest(url: self.request.url!)
            request.httpMethod = self.request.httpMethod
            request.allHTTPHeaderFields = self.request.allHTTPHeaderFields
            
            request.httpBody = self.request.httpBody
            return RESTRequest(session: self.session, request: request)
        }
        
        //MARK: - Public API
        /// Set body to url request.
        /// - Parameter body: NSDictionary instance.
        func setBody(body: NSDictionary) {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        //MARK: - Execution
        
        ///Execute function will execute url request
        /// - Parameter callback: Callback function
        /// Execute function will execute url request.
        /// - Parameter callback: Callback function.
        func execute<T>(_ callback: @escaping (RESTManager.ResponseResult<T>)->Swift.Void) {
            let completionHandler = createCompletionHandler { result in callback(result) }
            session.dataTask(with: request, completionHandler: completionHandler).resume()
        }
        
        
        
        
        //MARK: Utility
        
        private func createCompletionHandler<T>(_ callback: @escaping (RESTManager.ResponseResult<T>) -> Swift.Void) -> ((Data?, URLResponse?, Error?) -> Swift.Void) {
            
            return { data, response, error in
                
                //Error check
                if let error = error {
                    //Cheeck for internet connection
                    if let err = error as? URLError {
                        switch err.code {
                        case URLError.Code.notConnectedToInternet: fallthrough
                        case URLError.Code.networkConnectionLost: fallthrough
                        case URLError.Code.timedOut:
                            let error = RESTManager.Errors.Network()
                            callback(RESTManager.ResponseResult(result: .failure(error), rawData: data, statusCode: nil))
                            
                        default:
                            if (error as NSError).code == 53 {
                                // The operation couldn’t be completed. Software caused connection abort.
                                // This can happen if we execute request instantly after transitioning from background to foreground.
                                self.clone().execute(callback)
                            } else {
                                // Processing unknown URL error.
                                let error = RESTManager.Errors.Client(message: error.localizedDescription, statusCode: -1)
                                callback(RESTManager.ResponseResult(result: .failure(error), rawData: data, statusCode: nil))
                            }
                        }
                    } else {
                        //Processing unknown generic error
                        let error = RESTManager.Errors.Client(message: error.localizedDescription, statusCode: -1)
                        callback(RESTManager.ResponseResult(result: .failure(error), rawData: data, statusCode: nil))
                    }
                    
                } else if let response = response {
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    
                    switch statusCode {
                    case 1 ... 199: // Unexpected
                        let error = RESTManager.Errors.Unknown()
                        callback(RESTManager.ResponseResult(result: .failure(error), rawData: data, statusCode: statusCode))
                        
                        
                    case 200 ... 299: // Success
                        
                        var object: T?
                        if statusCode != 204, data?.isEmpty == false {
                            object = T.decodeData(data)
                        }
                        callback(RESTManager.ResponseResult(result: .success(object), rawData: data, statusCode: statusCode))
                        
                    case 300 ... 399: // Redirecton Unexpected
                        let error = RESTManager.Errors.Unknown()
                        callback(RESTManager.ResponseResult(result: .failure(error), rawData: data, statusCode: statusCode))
                        
                        
                    case 400 ... 499: // Client Error
                        let errorObject : RESTManager.ErrorWrapperObject? = RESTManager.ErrorWrapperObject.decodeData(data)
                        let errorMessage = errorObject?.error?.errorMessage ?? nil
                        
                        //Token expired
                        if statusCode == 401 {
                            AppGlobals.herokuRESTManager.executeRefreshToken { result in
                                switch result {
                                case .success:
                                    self.clone().execute(callback)
                                    
                                case .failure:
                                    AppGlobals.herokuRESTManager.executeLogout { _ in
                                        FlowManager.presentRegistrationScreen()
                                        
                                    }
                                    
                                    let error = RESTManager.Errors.Client(message: errorMessage, statusCode: statusCode)
                                    callback(RESTManager.ResponseResult(result: .failure(error), rawData: data, statusCode: statusCode))
                                }
                            }
                        } else {
                            let error = RESTManager.Errors.Client(message: errorMessage, statusCode: statusCode)
                            callback(RESTManager.ResponseResult(result: .failure(error), rawData: data, statusCode: statusCode))
                        }
                    default: // 500 or bigger, Server Error
                        let error = RESTManager.Errors.Server()
                        callback(RESTManager.ResponseResult(result: .failure(error), rawData: data, statusCode: statusCode))
                        
                        
                    }
                    
                } else {
                    let error = RESTManager.Errors.Unknown()
                    callback(RESTManager.ResponseResult(result: .failure(error), rawData: data, statusCode: nil))
                }
            }
        }
    }
    
}
