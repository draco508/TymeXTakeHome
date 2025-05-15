//
//  BaseApiService.swift
//
//  Created by Draco Nguyen on 07/11/2023.
//
//

import Alamofire

protocol PApiService {
    func request<T: Codable, R: BaseResponseData<T>>(request: URLRequestConvertible) throws -> R
    func requestNonStructure<R>(request: Alamofire.URLRequestConvertible) throws -> R? where R: Decodable 
}
