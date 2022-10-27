//
//  IPCHttpRequest.swift
//  sysvpn-macos
//
//  Created by macbook on 18/10/2022.
//

import Foundation
 
public struct HttpStatusCode {
    public struct Informational {
        static let range = 100..<200
    }
    
    public struct Success {
        static let range = 200..<300
    }
    
    public struct Redirection {
        static let range = 300..<400
    }
    
    public struct ClientError {
        static let range = 400..<500
        static let badRequest = 400
        static let notFoundError = 401
    }
    
    public struct ServerError {
        static let range = 500..<600
    }
}

protocol IPCHttpServiceProtocol: AnyObject {
    func performRequest(urlRequest: URLRequest) async throws -> Data?
}

class IPCHttpServiceService: IPCHttpServiceProtocol {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
      
    func performRequest(urlRequest: URLRequest) async throws -> Data? {
        return try await withCheckedThrowingContinuation { continuation in
         
            session.dataTask(with: urlRequest) { data, response, _ in
                 
                guard let httpResponse = response as? HTTPURLResponse else {
                    continuation.resume(throwing: NSError(domain: MoyaIPCErrorDomain.invalidResponse, code: 400))
                    return
                }
                 
                let statusCode = httpResponse.statusCode
                 
                guard (HttpStatusCode.Success.range).contains(statusCode) else {
                    if statusCode == HttpStatusCode.ClientError.notFoundError {
                        continuation.resume(throwing: NSError(domain: MoyaIPCErrorDomain.stautsError, code: 404))

                    } else {
                        continuation.resume(throwing: NSError(domain: MoyaIPCErrorDomain.invalidResponse, code: 400))
                    }
                    return
                }
                
                continuation.resume(returning: data)
                
            }.resume()
        }
    }
}

enum FetchError: Error {
    case bardRequest
}
