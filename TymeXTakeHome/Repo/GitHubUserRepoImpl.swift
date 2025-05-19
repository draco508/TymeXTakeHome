//
//  GitHubUserRepoImpl.swift
//  TymeXTakeHome
//
//  Created by NguyenNV on 14/5/25.
//

import Foundation
import Base_swift

class GitHubUserRepoImpl: PGithubUserRepo {
    
    private let apiService = ApiServiceImpl()
    
    func getListUser(perPage: Int, since: Int) throws -> [GitHubUser] {
        let request = GetListUserRequest(perPage: perPage, since: since)
        let response: [GitHubUserData]? = try apiService.request(request: request)
        
        if let rs = response {
           
            return rs.compactMap({
                return GithubUserDataToGithubUser().convert(input: $0)
            })
        } else {
            throw BaseError(code: "404", message: "Not found")
        }
    }
    
    func getUserDetail(userName: String) throws -> GitHubUser {
        let request = GetUserDetailRequest(userName: userName)
        let response: GitHubUserDetailData? = try apiService.request(request: request)
        
        if let rs = response {
            return GithubUserDetailDataToGithubUserDetail().convert(input: rs)
        } else {
            throw BaseError(code: "404", message: "Not found")
        }
    }
    
}
