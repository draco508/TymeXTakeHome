//
//  BaseApiServiceImpl.swift
//
//  Created by Draco Nguyen on 07/11/2023.
//
//

import Alamofire
import Base_swift

class ApiServiceImpl: PApiService {
    
    
    private(set) var session: Session!
    
    init() {
        session = initSession()
    }
    
    func initSession() -> Session {
        Session(interceptor: Interceptor())
    }
    
    func request<R>(request: Alamofire.URLRequestConvertible) throws -> R? where R: Decodable {
        let semaphore = DispatchSemaphore(value: 0)
        var data: R!
        var error: Error?
        session.request(request).validate().response(queue: .global(qos: .userInteractive)) { response in
            if let statusCode = response.response?.statusCode {
                print("Status code: " + String(statusCode))
            }
            if let request = response.request?.cURL(pretty: true) {
                print(" ======= Request cURL: =====\n" + request)
            } else {
                if let url = response.request?.url?.absoluteString {
                    print("URL: \n" + url)
                }
                if let headers = response.request?.allHTTPHeaderFields {
                    print("Headers: \n\(headers as AnyObject)")
                }
            }
            if let responseData = response.data {
                do {
                    let decoder = JSONDecoder()
                    data = try decoder.decode(R.self, from: responseData)
                    print("Response Data: \n \( String(describing: data)))")
                } catch let e {
                    error = BaseError(code: nil, message: e.localizedDescription)
                    print("Error Data: \n \( e.localizedDescription))")
                }
            } else {
                error = BaseError(code: nil, message: response.error?.localizedDescription)
            }
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        if error != nil {
            throw error!
        }
        return data
    }
    
   
}
