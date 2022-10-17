//
//  XPCServiceUser.swift
//  TunnelKitHost
//
//  Created by macbook on 15/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation


class XPCServiceUser {
    private let machServiceName: String
    private let log: (String) -> Void

    private var currentConnection: NSXPCConnection? {
        willSet {
            if newValue == nil {
                currentConnection?.invalidate()
            }
        }
    }

    init(withExtension machServiceName: String, logger: @escaping (String) -> Void) {
        self.machServiceName = machServiceName
        self.log = logger
    }

  
    

    // MARK: - Private

    private var connection: NSXPCConnection {
        
        let newConnection = NSXPCConnection(machServiceName: machServiceName, options: [])

        // The exported object is the delegate.
        newConnection.exportedInterface = NSXPCInterface(with: AppCommunication.self)
        newConnection.exportedObject = self

        // The remote object is the provider's IPCConnection instance.
        newConnection.remoteObjectInterface = NSXPCInterface(with: ProviderCommunication.self)

        currentConnection = newConnection
        newConnection.resume()

        return newConnection
    }
    
    
}

extension XPCServiceUser {
    
    func getProviderProxy() -> ProviderCommunication? {
        guard let providerProxy = connection.remoteObjectProxyWithErrorHandler({ registerError in
            self.log("Failed to get remote object proxy \(self.machServiceName): \(String(describing: registerError))")
            self.currentConnection = nil
        }) as? ProviderCommunication else {
            self.log("Failed to create a remote object proxy for the provider: \(machServiceName)")
            return nil
        }
        return providerProxy
    }
    
    func getLogs(completionHandler: @escaping (Data?) -> Void) {
        let providerProxy = getProviderProxy()
        providerProxy?.getLogs(completionHandler)
        
    }
    
    
    func request(urlRequest: URLRequest, completion: @escaping (XPCHttpResponse)-> Void ) {
        if let providerProxy = getProviderProxy() {
            var request:[String: NSObject] = [
                HttpFieldName.method.rawValue : (urlRequest.method?.rawValue ?? "GET") as NSObject,
                HttpFieldName.headers.rawValue : (urlRequest.allHTTPHeaderFields ?? [:]) as NSObject
            ]
            
            if let body = urlRequest.httpBody {
                request[HttpFieldName.body.rawValue] = body as NSObject
            }
            
            if let url = urlRequest.url?.absoluteString {
                request[HttpFieldName.url.rawValue] = url as NSObject
            }
            
            providerProxy.request(request: request, completionHandler: { data in
                var requestError: NSError?
                var requestStatusCode = 0
                if let statusCode = data[HttpFieldName.statusCode.rawValue]  as? Int {
                    requestStatusCode = statusCode
                }
                
                if let error = data[HttpFieldName.error.rawValue] as? String {
                    requestError = NSError(domain: error, code: requestStatusCode )
                }
                
                let response = XPCHttpResponse(statusCode: requestStatusCode, data:data[HttpFieldName.data.rawValue] as? Data, error: requestError)
                completion(response)
            })
        }
    }
    
    
}

extension XPCServiceUser: AppCommunication {

}


