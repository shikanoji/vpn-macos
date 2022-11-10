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
        static let notFoundError = 404
    }
    
    public struct ServerError {
        static let range = 500..<600
    }
}

protocol IPCHttpServiceProtocol: AnyObject {
    func performRequest(urlRequest: URLRequest, completionHandler: @escaping ([String: NSObject]) -> Void)
}

class IPCHttpServiceService: IPCHttpServiceProtocol {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
      
    func performRequest(urlRequest: URLRequest, completionHandler: @escaping ([String: NSObject]) -> Void) {
        session.dataTask(with: urlRequest) { data, response, etask in
             
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler([
                    HttpFieldName.statusCode.rawValue: 400 as NSObject,
                    HttpFieldName.error.rawValue: (etask?.localizedDescription ?? "") as NSObject
                ])
                
                return
            }
             
            let statusCode = httpResponse.statusCode
             
            guard (HttpStatusCode.Success.range).contains(statusCode) else {
                completionHandler([
                    HttpFieldName.statusCode.rawValue: statusCode as NSObject,
                    HttpFieldName.error.rawValue: MoyaIPCErrorDomain.stautsError as NSObject,
                    HttpFieldName.data.rawValue: (data ?? Data()) as NSObject
                ])
                
                return
            }
            
            completionHandler([
                HttpFieldName.statusCode.rawValue: 200 as NSObject,
                HttpFieldName.data.rawValue: (data ?? Data()) as NSObject
            ])
            
        }.resume()
    }
}

enum FetchError: Error {
    case bardRequest
}
