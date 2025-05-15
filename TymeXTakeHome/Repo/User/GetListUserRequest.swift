//
//  GetListUserRequest.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import Alamofire

class GetListUserRequest: BaseRequest {
    var baseUrl: String = ApiConfig.baseUrl
    
    var path: String
    
    var method: Alamofire.HTTPMethod = .get
    var parameters: Parameters?
    var headers: HTTPHeaders? {
        ["Content-Type": "application/json;charset=utf-8"]
    }
    
    init(perPage: Int, since: Int) {
        self.path = "users"
        self.parameters = ["per_page": perPage, "since": since]
        
    }
}
