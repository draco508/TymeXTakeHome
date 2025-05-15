//
//  GetListUserRequest.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import Alamofire

class GetUserDetailRequest: BaseRequest {
    var baseUrl: String = ApiConfig.baseUrl
    
    var path: String
    
    var method: Alamofire.HTTPMethod = .get
    var parameters: Parameters?
    var headers: HTTPHeaders? {
        ["Content-Type": "application/json;charset=utf-8"]
    }
    
    init(userName: String) {
        self.path = "users/\(userName)"
    }
}
