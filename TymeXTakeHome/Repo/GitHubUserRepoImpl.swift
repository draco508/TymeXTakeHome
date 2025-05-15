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
    
    func getListUser(perPage: Int, since: Int) throws -> DataPage<GitHubUser> {
        let request = GetListUserRequest(perPage: perPage, since: since)
        let response: [GitHubUserData]? = try apiService.requestNonStructure(request: request)
        
        if let rs = response {
            let dataPage = DataPage<GitHubUser>()
            
            dataPage.dataList = rs.compactMap({
                return GithubUserDataToGithubUser().convert(input: $0)
            })
            dataPage.perPage = perPage
            dataPage.hasNextPage = rs.count > perPage
            
            return dataPage
        } else {
            throw BaseError(code: nil, message: "data nil")
        }
    }
    
    func getUserDetail(userName: String) throws -> GitHubUser {
        let request = GetUserDetailRequest(userName: userName)
        let response: GitHubUserDetailData? = try apiService.requestNonStructure(request: request)
        
        if let rs = response {
            return GithubUserDetailDataToGithubUserDetail().convert(input: rs)
        } else {
            throw BaseError(code: nil, message: "data nil")
        }
    }
    
}
