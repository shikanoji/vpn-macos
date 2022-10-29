//
//  Moya+Rx+IPC.swift
//  sysvpn-macos
//
//  Created by macbook on 17/10/2022.
//

import Foundation
import RxSwift
#if !COCOAPODS
    import Moya
#endif
 
public extension Reactive where Base: MoyaProviderType {
    func requestIPC(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        Single.create { [weak base] single in
            
            guard let moyaProvider = base as? MoyaProvider<Base.Target> else {
                return self.request(token, callbackQueue: callbackQueue) as! Disposable
            }
            
            let cancellableToken = moyaProvider.requestIPC(token, callbackQueue: callbackQueue, progress: nil) { result in
                 
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create {
                cancellableToken.cancel()
            }
        }
    }
}

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
        let stubBehavior = stubClosure(target)
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
            case let .success(urlRequest):
                request = urlRequest
            case let .failure(error):
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
        return sendRequestIPC(target, request: request, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
    
    func sendRequestIPC(_ target: Target, request: URLRequest, callbackQueue: DispatchQueue?, progress: Moya.ProgressBlock?, completion: @escaping Moya.Completion) -> Cancellable {
        let cancellableToken = CancellableWrapper()
        let request = plugins.reduce(request) { $1.prepare($0, target: target) }
        /* let initialRequest: DataRequest = session.requestQueue.sync {
         let initialRequest = session.request(request, interceptor: interceptor)
         setup(interceptor: interceptor, with: target, and: initialRequest)
         
         return initialRequest
         }
         */
        IPCFactory.makeIPCRequestService().request(urlRequest: request) { response in
            let moyaCallbackResponse: Result<Moya.Response, MoyaError>!
            
            if cancellableToken.isCancelled {
                moyaCallbackResponse = .failure(MoyaError.underlying(NSError(domain: MoyaIPCErrorDomain.requestCancel, code: -1), nil))
            } else {
                
                 
                if let dataResponse = response.data {
                    let responseIPC = Moya.Response(statusCode: response.statusCode, data: dataResponse, request: request)
                    if response.error != nil {
                        moyaCallbackResponse = .success(responseIPC)
                    } else {
                        moyaCallbackResponse = .success(responseIPC)
                    }
                   
                } else {
                    if let error = response.error {
                        let errorIPC = error as NSError
                        moyaCallbackResponse = .failure(MoyaError.underlying(errorIPC, nil))
                    } else {
                        moyaCallbackResponse = .failure(MoyaError.underlying(NSError(domain: MoyaIPCErrorDomain.unknownError, code: 0), nil))
                    }
                }
            }
            
            let queue = callbackQueue ?? DispatchQueue.main
            queue.async {
                completion(moyaCallbackResponse)
            }
        }
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
