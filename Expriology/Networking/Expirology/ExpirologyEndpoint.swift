//
//  ExpirologyEndpoint.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation

enum ExpirologyEndpoint: Endpoint {
    case expiration(parameters: ExpirologyExpirationParameters)
    
    var baseURL: URL {
        return URL(string: "https://expirology.herokuapp.com")!
    }
    
    var version: String {
        return "1"
    }
    
    var path: String {
        switch self {
        case .expiration: return "foods"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .expiration: return .get
        }
    }
    
    var parameters: Data? {
        switch self {
        case .expiration(parameters: let params): return try? convert(parameters: params)
        }
    }
    
    func asURLRequest() -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        
        switch self {
        case .expiration(parameters: let params): url = url.appendingPathComponent(params.searchTerm)
        }
        
        var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        params: if let parameters = parameters {
            if case ExpirologyEndpoint.expiration = self { } else {
                let dict = try! JSONSerialization.jsonObject(with: parameters, options: []) as! [String: Any]
                guard !dict.isEmpty else { break params }
                urlComps.queryItems = dict.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            }
        }
        
        var urlRequest = URLRequest(url: urlComps.url!)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
    
    func convert<EncodableType: Encodable>(parameters: EncodableType) throws -> Data {
            let encoder = JSONEncoder()
            let json = try encoder.encode(parameters)
            return json
    }
}
