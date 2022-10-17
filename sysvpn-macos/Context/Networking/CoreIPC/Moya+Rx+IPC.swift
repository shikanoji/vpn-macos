//
//  Moya+Rx+IPC.swift
//  sysvpn-macos
//
//  Created by macbook on 17/10/2022.
//

import Foundation
import Moya


extension MoyaProvider {
    
    func requestIPC(_ target: Target,
                         callbackQueue: DispatchQueue? = .none,
                         progress: ProgressBlock? = .none,
                         completion: @escaping Completion) -> Cancellable {

        let callbackQueue = callbackQueue ?? DispatchQueue.main
           return requestNormalIPC(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
    
    func requestNormalIPC(_ target: Target, callbackQueue: DispatchQueue?, progress: Moya.ProgressBlock?, completion: @escaping Moya.Completion) -> Cancellable {
            let endpoint = self.endpoint(target)
            let stubBehavior = self.stubClosure(target)
            let cancellableToken = CancellableWrapper()

            // Allow plugins to modify response
            let pluginsWithCompletion: Moya.Completion = { result in
                let processedResult = self.plugins.reduce(result) { $1.process($0, target: target) }
                completion(processedResult)
            }

          
            let performNetworking = { (requestResult: Result<URLRequest, MoyaError>) in
                if cancellableToken.isCancelled {
                    self.cancelCompletion(pluginsWithCompletion, target: target)
                    return
                }

                var request: URLRequest!

                switch requestResult {
                case .success(let urlRequest):
                    request = urlRequest
                case .failure(let error):
                    pluginsWithCompletion(.failure(error))
                    return
                }

                let networkCompletion: Moya.Completion = { result in
                    pluginsWithCompletion(result)
                }

                cancellableToken.innerCancellable = self.performRequestIPC(target, request: request, callbackQueue: callbackQueue, progress: progress, completion: networkCompletion, endpoint: endpoint, stubBehavior: stubBehavior)
            }

            requestClosure(endpoint, performNetworking)

            return cancellableToken
        }
    
    private func performRequestIPC(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, progress: Moya.ProgressBlock?, completion: @escaping Moya.Completion, endpoint: Endpoint, stubBehavior: Moya.StubBehavior) -> Cancellable {
       /* switch stubBehavior {
        case .never:
            switch endpoint.task {
            case .requestPlain, .requestData, .requestJSONEncodable, .requestCustomJSONEncodable, .requestParameters, .requestCompositeData, .requestCompositeParameters:
                return self.sendRequestIPC(target, request: request, callbackQueue: callbackQueue, progress: progress, completion: completion)
            default:
                return self.sendRequestIPC(target, request: request, callbackQueue: callbackQueue, progress: progress, completion: completion)
            }
        default:
            return self.stubRequest(target, request: request, callbackQueue: callbackQueue, completion: completion, endpoint: endpoint, stubBehavior: stubBehavior)
        }*/
        return self.sendRequestIPC(target, request: request, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
    
    func sendRequestIPC(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, progress: Moya.ProgressBlock?, completion: @escaping Moya.Completion) -> Cancellable {
        
        let cancellableToken = CancellableWrapper()
        let request = self.plugins.reduce(request) { $1.prepare($0, target: target) }
        /* let initialRequest: DataRequest = session.requestQueue.sync {
            
            let initialRequest = session.request(request, interceptor: interceptor)
            setup(interceptor: interceptor, with: target, and: initialRequest)

            return initialRequest
        }
*/
       return cancellableToken
    }
    
    

}

 
internal class CancellableWrapper: Cancellable {
    internal var innerCancellable: Cancellable = SimpleCancellable()

    var isCancelled: Bool { innerCancellable.isCancelled }

    internal func cancel() {
        innerCancellable.cancel()
    }
}

internal class SimpleCancellable: Cancellable {
    var isCancelled = false
    func cancel() {
        isCancelled = true
    }
}
