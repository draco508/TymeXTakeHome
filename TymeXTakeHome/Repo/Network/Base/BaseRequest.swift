//
//  BaseRequest.swift
//
//  Created by Draco Nguyen on 07/11/2023.
//
//

import Alamofire

protocol BaseRequest: URLRequestConvertible {
    
    var baseUrl: String { get }
    
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var parameters: Parameters? { get }
    
    var headers: HTTPHeaders? { get }
}



extension BaseRequest {
    
    var headers: HTTPHeaders? { nil }
    
    var parameters: Parameters? { nil }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        switch method {
        case .get:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.httpShouldHandleCookies = false
        if let headers = headers {
            for header in headers {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }
        return urlRequest
    }
}
