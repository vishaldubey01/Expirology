//
//  TabscannerAPIClient.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation

final class TabscannerAPIClient: APIClient {
    public static let shared = TabscannerAPIClient()
    
    public init() { }
    
    // MARK: - Process image
    
    @discardableResult
    public func processImage(using parameters: TabscannerProcessParameters, completion: @escaping (APIResult<TabscannerProcess>) -> Void) -> URLSessionDataTask {
        let processEndpoint = TabscannerEndpoint.process(parameters: parameters)
        return connect(to: processEndpoint, completion: completion)
    }
    
    // MARK: - APIClient
    
    @discardableResult
    func connect(to request: URLRequestConvertible, completion: @escaping (NetworkingResponse) -> Void) -> URLSessionDataTask {
        let request = request.asURLRequest()
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            #if DEBUG
            print(response as Any)
            #endif
            DispatchQueue.main.async {
                completion((data, response, error))
            }
        }
        
        dataTask.resume()
        return dataTask
    }
    
    @discardableResult
    func connect<T>(to request: URLRequestConvertible, parse: ((NetworkingResponse) -> APIResult<T>)? = nil, completion: @escaping (APIResult<T>) -> Void) -> URLSessionDataTask {
        return connect(to: request) { response in
            if let parse = parse {
                let parsedValue = parse(response)
                completion(parsedValue)
            } else {
                let decoder = JSONDecoder()
                guard let data = response.data else { completion(.failure(response.error!)); return }
                do {
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
    }
}
