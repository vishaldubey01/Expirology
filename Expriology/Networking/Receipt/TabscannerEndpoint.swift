//
//  TabscannerEndpoint.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation

enum TabscannerEndpoint: Endpoint {
    case process(parameters: TabscannerProcessParameters)
    
    var baseURL: URL {
        return URL(string: "https://api.tabscanner.com/api")!
    }
    
    var version: String {
        return "1"
    }
    
    var path: String {
        switch self {
        case .process: return "2/process"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .process: return .post
        }
    }
    
    var parameters: Data? {
        switch self {
        case .process(parameters: let params):
            var data = Data()
            let boundary = UUID().uuidString
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\("documentType")\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(params.documentType)".data(using: .utf8)!)
            
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            // TODO: Make sure the png below is the right type.
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(params.file)
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            return data
        }
    }
    
    func asURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        let urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        var urlRequest = URLRequest(url: urlComps.url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("OfVhBAGmyZJyu27swUjkllVAkRkicpx1ZrhbXLuwgh8d2nhNhIzw9VGD1lRlLi8A", forHTTPHeaderField: "apikey")
        urlRequest.setValue("multipart/form-data; boundary=\(UUID().uuidString)", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
    func convert<EncodableType: Encodable>(parameters: EncodableType) throws -> Data {
            let encoder = JSONEncoder()
            let json = try encoder.encode(parameters)
            return json
    }
}
